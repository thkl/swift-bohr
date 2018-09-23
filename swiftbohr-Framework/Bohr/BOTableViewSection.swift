  //
  //  BOTableViewSection.swift
  //  swift-bohr
  //
  //  Created by Thomas Kluge on 03.09.18.
  //  Copyright © 2018 Thomas Kluge. All rights reserved.
  //
  
  import Foundation
  import UIKit
  
  open class BOTableViewSection: NSObject {
    
    public var headerTitle : String?
    public var headerTitleColor : UIColor?
    public var headerTitleFont : UIFont?
    public var footerTitle : String?
    public var footerTitleColor : UIColor?
    public var footerTitleFont : UIFont?
    
    private var rawCells = Array<BOTableViewCell>()
    
    
    public override init() {
      super.init()
      self.footerTitleFont = UIFont.systemFont(ofSize: 13)
    }
    
    required public convenience init(withTitle: String, _ handler: @escaping (_ cell : BOTableViewSection) ->Void) {
      self.init()
      self.headerTitle = withTitle
      handler(self)
    }
    
    public func addCell (cell : BOTableViewCell) {
      self.rawCells.append(cell)
    }
    
    func cells()->Array<BOTableViewCell> {
      
      let result = self.rawCells.filter({ (cell) -> Bool in
        if (cell.visibilityKey != nil) {
          
          return cell.visibilityBlock!(UserDefaults.standard.object(forKey: cell.visibilityKey!) as Any)
        }
        return true
      })
      
      return result
      
    }
    
    
    
  }
  
  
