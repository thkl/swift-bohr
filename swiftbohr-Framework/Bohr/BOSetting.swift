//
//  BOSetting.swift
//  swift-bohr
//
//  Created by Thomas Kluge on 03.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import Foundation

open class BOSetting: NSObject {
  
  public var key : String?
  
  public var value : AnyObject? {
    
    set (newValue)  {
      UserDefaults.standard.set(newValue, forKey: self.key!)
      UserDefaults.standard.synchronize()
    }
    
    get {
      return UserDefaults.standard.object(forKey : self.key!) as AnyObject
    }
  }
  
  
  public typealias ValueDidChangeBlock = () -> Void
  public var valueDidChangeBlock: ValueDidChangeBlock?
  
  init(withKey : String) {
    super.init()
    self.key = withKey
    UserDefaults.standard.addObserver(self, forKeyPath: withKey, options: .new, context: nil)
  }
  
  convenience init (settingWithKey : String) {
    self.init(withKey: settingWithKey)
  }
  
  override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    self.value = change![NSKeyValueChangeKey.newKey] as AnyObject
    if (self.valueDidChangeBlock != nil) {
      self.valueDidChangeBlock!()
    }
  }
  
  func setValueDidChangeBlock(aValueDidChangeblock :ValueDidChangeBlock?) {
    self.valueDidChangeBlock = aValueDidChangeblock
    if (aValueDidChangeblock != nil) {
      self.valueDidChangeBlock!()
    }
  }
  
}
