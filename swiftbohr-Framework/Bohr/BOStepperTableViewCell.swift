//
//  BOStepperTableViewCell.swift
//  swift-bohr
//
//  Created by Thomas Kluge on 23.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation
import UIKit

open class BOStepperTableViewCell: BOTableViewCell {
  
  public var stepper = UIStepper()
  
  override public func setup() {
    self.stepper = UIStepper()
    self.stepper.addTarget(self, action: #selector(stepperValueDidChange), for: .valueChanged)
    self.accessoryView = self.stepper
  }
  
  
  
  @objc private func stepperValueDidChange() {
    let newValue = self.stepper.value
    self.setting?.value = newValue as AnyObject
    if (self.actionBlock != nil) {
      self.actionBlock!(newValue as AnyObject)
      
    }
  }
  
  
  override public func settingValueDidChange() {
    let newValue = self.setting?.value
    if ((newValue != nil) && (newValue?.doubleValue != nil)) {
      self.stepper.value = (newValue?.doubleValue)!
    }
  }
  
  override func footerTitle()->String? {
    let newValue = self.setting?.value
    if ((newValue != nil) && (newValue?.doubleValue != nil)) {
      return String(format: "%f",(newValue?.doubleValue)!)
    }
    return nil
  }
  
  /*
   
   
   
   - (void)updateAppearance {
   self.stepper.onTintColor = self.secondaryColor;
   }
   
   */
}
