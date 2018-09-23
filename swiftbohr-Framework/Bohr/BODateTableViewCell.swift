//
//  BODateTableViewCell.swift
//  swift-bohr
//
//  Created by Thomas Kluge on 03.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation
import UIKit

open class BODateTableViewCell: BOTableViewCell {
  
  public var datePicker = UIDatePicker()
  private var dateFormatter = DateFormatter()
  
  override func setup() {
    self.datePicker.backgroundColor = .clear
    self.datePicker.datePickerMode = .date
    self.setExpansionView(expansionView: self.datePicker)
    self.dateFormatter.dateFormat = self.dateFormat()
    
    
    self.datePicker.addTarget(self, action: Selector("datePickerValueDidChange"), for: .valueChanged)
    
  }
  
  override func expansionHeight() -> CGFloat {
    return 216
  }
  
  func setDateFormat(dateFormat : String) {
    if (dateFormat.count > 0) {
      self.dateFormatter.dateFormat = dateFormat
    }
  }
  
  func dateFormat()->String {
    if (self.dateFormatter.dateFormat.count == 0) {
      return DateFormatter.dateFormat(fromTemplate: "dd/MM/YYYY", options: 0, locale: Locale.current)!
    }
    
    return self.dateFormatter.dateFormat;
 }
  
  
  override func settingValueDidChange() {
    if let dateValue = self.setting?.value as? Date {
      self.detailTextLabel!.text = self.dateFormatter.string(from: dateValue)
      self.datePicker.date = dateValue
      if (self.actionBlock != nil) {
        self.actionBlock!(dateValue as AnyObject)
      }
    }
  }
  
 @objc private func datePickerValueDidChange() {
  self.setting!.value = self.datePicker.date as AnyObject;
  }

}
