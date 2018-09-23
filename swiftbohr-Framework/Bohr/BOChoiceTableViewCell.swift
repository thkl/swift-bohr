//
//  BOChoiceTableViewCell.swift
//  swift-bohr
//
//  Created by Thomas Kluge on 03.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation
import UIKit

open class BOChoiceTableViewCell: BOTableViewCell {
  
  public var options = Array<String>()
  public var optionValues = Array<Int>()
  public var footerTitles = Array<String>()
  
  override func setup() {
    self.selectionStyle = .default
  }
  
  func footerTitle()->String? {
    if let iVal = self.setting?.value as? Int {
      let currentOption = self.indexFromCurrentValue(value: iVal)
      if (currentOption < self.footerTitles.count) {
        return self.footerTitles[currentOption]
      }
    }
    return nil
  }
  
  
  func indexFromCurrentValue(value : Int)->Int {
    var index = value
    if (self.optionValues.count > 0) {
      index = self.optionValues.firstIndex(of: value)!
    }
    return index
  }
  
  func valueForIndex(index : Int)->Int {
    if (self.optionValues.count > index) {
      return self.optionValues[index]
    }
    return index
  }
  
  override func wasSelectedFromViewController(viewController: BOTableViewController) {
    if (self.accessoryType != .disclosureIndicator) {
      if let iVal = self.setting?.value as? Int {
        let currentOption = self.indexFromCurrentValue(value: iVal)
        if (currentOption < self.options.count - 1) {
          self.setting!.value = self.valueForIndex(index: currentOption+1) as AnyObject
        } else {
          self.setting!.value = 0 as AnyObject
        }
      }
    }
  }
  
  override func settingValueDidChange() {
    if let iVal = self.setting?.value as? Int {
      self.detailTextLabel!.text = self.options[self.indexFromCurrentValue(value: iVal)]
      if (self.actionBlock != nil) {
        self.actionBlock!(self.detailTextLabel!.text as AnyObject)
      }
    }
  }
}
