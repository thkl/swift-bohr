//
//  BOTextTableViewCell.swift
//  swift-bohr
//
//  Created by Thomas Kluge on 03.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation
import UIKit

open class BOTextTableViewCell: BOTableViewCell, UITextFieldDelegate {

  enum BOTextFieldInputError {
    case BOTextFieldInputNoError
    case BOTextFieldInputTooShortError
    case BOTextFieldInputNotNumericError
  }
  
  
  public var textField : UITextField?
  public var minimumTextLength : Int = 0
  private typealias InputErrorBlock = (_ cell : BOTextTableViewCell, _ error:BOTextFieldInputError) -> Bool
  private var inputErrorBlock: InputErrorBlock?
  
  override func setup() {
    self.textField = UITextField()
    self.textField?.delegate = self
    self.textField?.textAlignment = .right
    self.textField?.returnKeyType = .done
    self.textField?.contentVerticalAlignment = .center
    let frame = CGRect(x: 0, y: 0, width: 130, height: (self.textField?.intrinsicContentSize.height)!)
    self.textField?.frame = frame
    self.accessoryView = self.textField
  }
  
  func updateAppearance() {
    
  }
  
  override func settingValueDidChange() {
    self.textField?.text = self.setting?.value as? String
    if (self.actionBlock != nil) {
      self.actionBlock!(self.textField?.text as AnyObject)
    }
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
	    textField.endEditing(true)
    return true
  }
  
  func textFieldTrimmedText() -> String {
    return (self.textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    let error = self.validateTextFieldInput(input: self.textFieldTrimmedText())
    if (error != .BOTextFieldInputNoError) {
      self .resetTextFieldAndInvokeInputError(error: error)
    } else {
      self.setting?.value = self.settingValueForInput(input: textField.text!)
    }
  }
  
  func validateTextFieldInput(input : String) -> BOTextFieldInputError {
    return (input.count < self.minimumTextLength) ? BOTextFieldInputError.BOTextFieldInputTooShortError : BOTextFieldInputError.BOTextFieldInputNoError
  }
  
  func resetTextFieldAndInvokeInputError(error : BOTextFieldInputError) {
    self.settingValueDidChange()
    if (self.inputErrorBlock != nil) {
      self.inputErrorBlock!(self,error)
    }
  }
  
  func settingValueForInput(input : String) -> AnyObject {
    return self.textFieldTrimmedText() as AnyObject
  }
}
