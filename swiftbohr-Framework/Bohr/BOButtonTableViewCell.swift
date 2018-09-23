//
//  BOButtonTableViewCell.swift
//  swiftBohr
//
//  Created by Thomas Kluge on 03.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation
import UIKit

open class BOButtonTableViewCell: BOTableViewCell {
  
  
  override func setup() {
    self.selectionStyle = .default
    self.textLabel!.textAlignment = .center
  }
  
  
  override func wasSelectedFromViewController(viewController: BOTableViewController) {
    if (self.actionBlock != nil) {
      self.actionBlock!(nil)
    }
  }
  
    
}
