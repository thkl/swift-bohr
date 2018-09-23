//
//  BOTableViewController.swift
//  swift-bohr
//
//  Created by Thomas Kluge on 03.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation
import UIKit

open class BOTableViewController: UITableViewController {
  
  private var _sections = Array<BOTableViewSection>()
  private var _footerViews : Array<UITableViewHeaderFooterView>?
  
  fileprivate var expansionIndexPath : NSIndexPath?
  
  public func setup() {
    
  }
  
  public func addSection(section : BOTableViewSection) {
    self._sections.append(section)
  }
  
  override init(style: UITableView.Style) {
    super.init(style: style)
    self.commonInit()
  }
  
  convenience init() {
    self.init(style: .grouped)
  }
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    self.commonInit()
  }
  
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func commonInit() {
    self.tableView.estimatedRowHeight = 55
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.keyboardDismissMode = .onDrag
    self.tableView.tableFooterView = UIView()
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self.tableView, action: #selector(self.tableView.endEditing(_:)))
    
    tapGestureRecognizer.cancelsTouchesInView = false
    self.tableView.addGestureRecognizer(tapGestureRecognizer)
    self.setup()
  }
  
  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
      self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
      self.navigationController?.transitionCoordinator?.notifyWhenInteractionChanges({ (coordinatorContext) in
        if (coordinatorContext.isCancelled) {
          self.tableView.selectRow(at: selectedRowIndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        }
      })
    }
  }
  
  override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let section = self._sections[section]
    return section.headerTitle
  }
  
  override open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let headerView = view as? UITableViewHeaderFooterView {
      let section = self._sections[section]
      if (section.headerTitleColor != nil) {
        headerView.textLabel?.textColor = section.headerTitleColor
      }
      if (section.headerTitleFont != nil) {
        headerView.textLabel?.font = section.headerTitleFont
      }
    }
  }
  
  override open func numberOfSections(in tableView: UITableView) -> Int {
    return (_sections.count)
  }
  
  override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let section = self._sections[section]
    return section.cells().count
  }
  
  override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = self._sections[indexPath.section]
    let cell = section.cells()[indexPath.row]
    let cHeight = self.heightForCell(cell: cell)
    
    var cellHeight = max(self.tableView.estimatedRowHeight, cHeight)
    
    cell.setHeight(height: cellHeight)
    
    if ((self.expansionIndexPath != nil) && (self.expansionIndexPath!.isEqual(indexPath))) {
      cellHeight += cell.expansionHeight()
    }
    
    return cellHeight
  }
  
  func heightForCell(cell : BOTableViewCell)->CGFloat {
    
    if (cell.expansionHeight() > 0) {
      let cleanCell = UITableViewCell(style: .default, reuseIdentifier: nil)
      cleanCell.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: 0)
      cleanCell.textLabel?.numberOfLines = 0
      cleanCell.textLabel?.text = cell.textLabel?.text
      cleanCell.accessoryView = cell.accessoryView
      cleanCell.accessoryType = cell.accessoryType
      return cleanCell.systemLayoutSizeFitting(cleanCell.frame.size).height
    }
    
    return cell.systemLayoutSizeFitting(cell.frame.size).height
  }
  
  override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let section = self._sections[indexPath.section]
    let cell = section.cells()[indexPath.row]
    cell.indexPath = indexPath as NSIndexPath
    cell.setup()
    
    if ((cell.setting != nil) && (cell.setting?.valueDidChangeBlock == nil)) {
      
      cell.setting?.setValueDidChangeBlock(aValueDidChangeblock: {
        
        DispatchQueue.main.async {
          cell.settingValueDidChange()
          self.reloadTableView()
        }
        
      })
      
    }
    
    UIView.performWithoutAnimation {
      cell.settingValueDidChange()
    }
    
    return cell
  }
  
  override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    // cell._updateAppearance
    // cell.updateAppearance
  }
  
  
  override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section = self._sections[indexPath.section]
    let cell = section.cells()[indexPath.row]
    
    if (cell.expansionHeight() > 0) {
      if ((self.expansionIndexPath != nil) && ((self.expansionIndexPath!.isEqual(indexPath as NSIndexPath)))) {
        self.expansionIndexPath = nil
      } else {
        self.expansionIndexPath = indexPath as NSIndexPath
      }
      
      self.tableView.deselectRow(at: indexPath, animated: false)
      self.tableView.beginUpdates()
      self.tableView.endUpdates()
      self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
      
    } else if (cell.destinationViewController != nil) {
      if (cell.willShowDestinationViewController != nil) {
        cell.willShowDestinationViewController!(cell.destinationViewController!)
      }
      self.navigationController?.pushViewController(cell.destinationViewController!, animated: true)
    } else {
        cell.wasSelectedFromViewController(viewController: self)
    }
    
    if (cell.accessoryType != .disclosureIndicator) {
      self.tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  
  func reloadTableView() {
    let affectedIndexes = NSMutableIndexSet()
    for s in 0...(self._sections.count - 1) {
      let numberOfRows = self.tableView.numberOfRows(inSection: s)
      let section = self._sections[s]
      if (numberOfRows != section.cells().count) {
        affectedIndexes.add(s)
      } else {
        
        if (numberOfRows > 0) {
          for r in 0...(numberOfRows - 1) {
            if let lastCell = self.tableView.cellForRow(at: IndexPath(row: r, section: s)) {
              if ((self.tableView.visibleCells.contains(lastCell)) &&
                (self._sections[s].cells().contains(lastCell as! BOTableViewCell))) {
                affectedIndexes.add(s)
              }
              
            }
          }
        }
      }
    }
      if (affectedIndexes.count > 0) {
        self.tableView.beginUpdates()
        self.tableView.reloadSections(affectedIndexes as IndexSet, with: .fade)
        self.tableView.endUpdates()
      }
      
      UIView.performWithoutAnimation {
        let previousContentOffset = self.tableView.contentOffset
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.contentOffset = previousContentOffset
      }
    
  }
  
  func footerViews()->Array<UITableViewHeaderFooterView> {
    if (_footerViews == nil) {
      _footerViews = Array<UITableViewHeaderFooterView>()
      for _ in 0...self.tableView.numberOfSections {
        let footerView = UITableViewHeaderFooterView()
        _footerViews?.append(footerView)
      }
    }
    return _footerViews!
  }
  
  override open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
    let footerView = self.footerViews()[section]
    footerView.textLabel?.text = self.tableView(self.tableView, titleForFooterInSection: section)
    footerView.textLabel?.numberOfLines = 0
    let previousOrigin = footerView.textLabel?.frame.origin
    footerView.sizeToFit()
    let size = footerView.textLabel?.frame.size
    footerView.textLabel?.frame = CGRect(x: (previousOrigin?.x)!,
                                         y: (previousOrigin?.y)!,
                                         width: (size?.width)!, height: (size?.height)!)
    
    return footerView.intrinsicContentSize.height
  }
  
  
}
