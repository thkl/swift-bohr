//
//  BOTableViewCell.swift
//  swift-bohr
//
//  Created by Thomas Kluge on 03.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation
import UIKit

open class BOTableViewCell: UITableViewCell {
  
  public var visibilityKey : String?
  public typealias VisibilityBlock = (_ settingValue : Any) -> Bool
  public var visibilityBlock: VisibilityBlock?
  
  public typealias ActionBlock = (_ selectedValue : AnyObject?) -> Void
  public var actionBlock: ActionBlock?

  public typealias PreperationBlock = (_ destionationViewcontroller : UIViewController) -> Void
  public var willShowDestinationViewController: PreperationBlock?

  
  public var key : String?
  
  public var setting : BOSetting?
  public var indexPath : NSIndexPath?
  
  public var destinationViewController : UIViewController?
  
  public var height : CGFloat = 40
  
  private var expansionView: UIView?
  private var expansionViewTopConstraint: NSLayoutConstraint?
  
  required public convenience init(withTitle: String, key : String? , _ handler: @escaping (_ cell : BOTableViewCell) ->Void) {
    self.init(style: (key != nil) ? .value1 : .default , reuseIdentifier: nil)
    self.setup()
    handler(self)
    self.preservesSuperviewLayoutMargins = false
    self.clipsToBounds = true
    self.textLabel?.numberOfLines = 0
    self.textLabel?.text = withTitle
    self.key = key
    if (self.key != nil) {
      self.setting = BOSetting(settingWithKey: self.key!)
    }
  }
  
  
  func setExpansionView(expansionView : UIView) {
    
    if (self.expansionView != expansionView) {
      self.expansionView?.removeFromSuperview()
      self.expansionView = expansionView
      self.contentView.addSubview(self.expansionView!)
      
      self.expansionViewTopConstraint = NSLayoutConstraint(item: self.expansionView!, attribute: .top, relatedBy: .equal, toItem: self.expansionView?.superview, attribute: .top, multiplier: 1, constant: 0)
      
      let leftConstraint = NSLayoutConstraint(item: self.expansionView!, attribute: .left, relatedBy: .equal, toItem: self.expansionView?.superview, attribute: .left, multiplier: 1, constant: 0)
      
      let rightConstraint = NSLayoutConstraint(item: self.expansionView!, attribute: .right, relatedBy: .equal, toItem: self.expansionView?.superview, attribute: .right, multiplier: 1, constant: 0)
      
      let heightConstraint = NSLayoutConstraint(item: self.expansionView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.expansionHeight())
      
      self.expansionView?.translatesAutoresizingMaskIntoConstraints = false
      self.expansionView?.superview?.addConstraints([self.expansionViewTopConstraint!,leftConstraint,rightConstraint,heightConstraint])
    }
    
  }
  
  func expansionHeight()->CGFloat {
    if (self.expansionView != nil) {
      return (self.expansionView?.intrinsicContentSize.height)!;
    } else {
      return 0
    }
  }
  
  func setHeight(height: CGFloat) {
    if (self.height != height) {
      self.height = height
      self.expansionViewTopConstraint?.constant = height
    }
  }
  
  func settingValueDidChange() {
    if (self.setting?.value != nil) {
      self.detailTextLabel!.text = self.setting?.value as? String
    }
  }
  
  @objc func wasSelectedFromViewController(viewController : BOTableViewController) {
    
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    if (self.expansionHeight() > 0) {
      let yOffset = (self.height - self.frame.size.height) / 2
      self.textLabel?.center = CGPoint(x: (self.textLabel?.center.x)!, y: (self.textLabel?.center.y)! + yOffset)
      self.detailTextLabel?.center =  CGPoint(x: (self.detailTextLabel?.center.x)!, y: (self.detailTextLabel?.center.y)! + yOffset)
    }
  }
  
  func setup() {}
}
