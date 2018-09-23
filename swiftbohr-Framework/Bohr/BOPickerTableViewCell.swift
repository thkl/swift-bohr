//
//  BOPickerTableViewCell.swift
//  swift-bohr
//
//  Created by Thomas Kluge on 03.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation
import UIKit

open class BOPickerTableViewCell: BOTableViewCell,UIPickerViewDataSource,UIPickerViewDelegate {
  
  public var picker = UIPickerView()
  public var pickerValues = Array<String>()
  public var pickerDescriptions = Array<String>()
  
  override func setup() {
    self.picker.backgroundColor = .clear
    self.setExpansionView(expansionView: self.picker)
    self.picker.showsSelectionIndicator = true
    self.picker.dataSource = self
    self.picker.delegate = self
  }
  
  override func expansionHeight() -> CGFloat {
    return 216
  }
  
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerValues.count
  }
  
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.pickerDescriptions[row]
  }
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.detailTextLabel!.text = self.pickerDescriptions[row]
    let newValue = self.pickerValues[row] as AnyObject
    self.setting?.value = newValue
      if (self.actionBlock != nil) {
        self.actionBlock!(newValue as AnyObject)
      }
  }
  
  override public func settingValueDidChange() {
    if let sVal = self.setting?.value as? String {
      if let row = self.pickerValues.firstIndex(of: sVal) {
        if (self.pickerValues.count > row) {
          self.detailTextLabel!.text = self.pickerDescriptions[row]
          self.picker.selectRow(row, inComponent: 0, animated: false)
        }
      }
    }
  }
  
}
