//
//  BOSwitchTableViewCell.swift
//  swiftBohr
//
//  Created by Thomas Kluge on 04.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation
import UIKit

open class BOSwitchTableViewCell: BOTableViewCell {
  
  public var toggleSwitch = UISwitch()
  public var onFooterTitle : String?
  public var offFooterTitle : String?
  
  
  override public func setup() {
    self.toggleSwitch = UISwitch()
    self.toggleSwitch.addTarget(self, action: #selector(toggleSwitchValueDidChange), for: .valueChanged)
    self.accessoryView = self.toggleSwitch
  }
  
  
  @objc private func toggleSwitchValueDidChange() {
    let newState = self.toggleSwitch.isOn as AnyObject
    self.setting?.value = newState
    if (self.actionBlock != nil) {
      self.actionBlock!(newState)
    }
  }
  
  
  override public func settingValueDidChange() {
    if let newState = self.setting?.value as? Bool {
      self.toggleSwitch.setOn(newState, animated: UIView.areAnimationsEnabled)
    }
  }
  
  override func footerTitle()->String? {
    if let newState = self.setting?.value as? Bool {
      return newState ? self.onFooterTitle : self.offFooterTitle
    }
    return nil
  }
  
  /*
   
   
   
   - (void)updateAppearance {
   self.toggleSwitch.onTintColor = self.secondaryColor;
   }
   
   */
}
