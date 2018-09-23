//
//  BONumberTableViewCell.swift
//  swift-bohr
//
//  Created by Thomas Kluge on 03.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation

open class BONumberTableViewCell: BOTextTableViewCell {
  
  public var numberOfDecimals : Int = 0
  
  
  
  override func setup() {
    super.setup()
    self.textField?.keyboardType = .numberPad
  }
  
  override func validateTextFieldInput(input: String) -> BOTextTableViewCell.BOTextFieldInputError {
    return (!input.isNumeric()) ? .BOTextFieldInputNotNumericError : super.validateTextFieldInput(input: input)
  }
  
  override func settingValueForInput(input: String) -> AnyObject {
    if (self.validateTextFieldInput(input: input) == .BOTextFieldInputNoError) {
      return input.number()
    }
    return NSNumber(value: 0)
  }
  
  override func settingValueDidChange() {
    if let nValue = self.setting?.value as? NSNumber {
      self.textField!.text = nValue.stringWithDecimals(decimals: self.numberOfDecimals)
      if (self.actionBlock != nil) {
        self.actionBlock!(self.textField?.text as AnyObject)
      }
    }
  }
}


extension NSNumber {
  
  func stringWithDecimals(decimals : Int)->String {
    let formatter =  NumberFormatter()
    formatter.locale = Locale.current
    formatter.maximumFractionDigits = decimals
    return formatter.string(from: self)!
  }
  
}

extension String {
  
  func isNumeric()->Bool {
    if (self.count > 0) {
      let scanner = Scanner(string: self)
      scanner.locale = Locale.current
      return (scanner.scanDecimal(nil) && scanner.isAtEnd)
    }
    return true
  }
  
  func number()->NSNumber {
    let formatter =  NumberFormatter()
    formatter.locale = Locale.current
    if let result = formatter.number(from: self) {
      return result
    }
    return NSNumber(value: 0)
  }
  
}
