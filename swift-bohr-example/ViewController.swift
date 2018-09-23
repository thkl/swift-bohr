//
//  ViewController.swift
//  swift-bohr
//
//  Created by Thomas Kluge on 03.09.18.
//  Copyright © 2018 Thomas Kluge. All rights reserved.
//

import UIKit


class ViewController: BOTableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   }
  
  override func setup() {
    self.addSection(section: BOTableViewSection(withTitle: "Section 0") { (section) in
     section.addCell(cell: BOStepperTableViewCell(withTitle: "Stepper", key: "stepper", { (cell) in
        if let stepperCell = cell as? BOStepperTableViewCell {
          stepperCell.stepper.minimumValue = 0
          stepperCell.stepper.maximumValue = 20
        }
      }))
    })
    
    let section = BOTableViewSection(withTitle: "Section 1") { (section) in
      section.addCell(cell: BOSwitchTableViewCell(withTitle: "Switch", key: "switch", { (cell) in
        
      }))
      
      section.addCell(cell: BOButtonTableViewCell(withTitle: "Button", key: nil, { (cell) in
        if let buttonCell = cell as? BOButtonTableViewCell {
          buttonCell.actionBlock = {(value) in
          }
          buttonCell.visibilityKey = "switch"
          buttonCell.visibilityBlock = {(value)->Bool in
            if let v = value as? Bool {
              return v == true
            }
            return true
          }
        }
      }))
      
      section.addCell(cell: BOTableViewCell(withTitle: "Cell 1", key: "test1", { (cell) in
        cell.visibilityKey = "switch"
        cell.visibilityBlock = {(value)->Bool in
          if let v = value as? Bool {
            return v == true
          }
          return true
        }
      })
      )
      
      section.addCell(cell: BOTextTableViewCell(withTitle: "Text", key: "Cell2_Text", { (cell) in
        if let textCell = cell as? BOTextTableViewCell {
          textCell.textField?.placeholder = "Enter Text"
          
        }
        cell.visibilityKey = "switch"
        cell.visibilityBlock = {(value)->Bool in
          if let v = value as? Bool {
            return v == true
          }
          return true
        }
      }))
      
      section.addCell(cell: BONumberTableViewCell(withTitle: "Number", key: "Cell3_Number", { (cell) in
        if let textCell = cell as? BONumberTableViewCell {
          textCell.textField?.placeholder = "Enter a Number"
        }
        cell.visibilityKey = "switch"
        cell.visibilityBlock = {(value)->Bool in
          if let v = value as? Bool {
            return v == true
          }
          return true
        }
      }))
      
      section.addCell(cell: BODateTableViewCell(withTitle: "Date", key: "Cell4_Date", { (cell) in
        cell.visibilityKey = "switch"
        cell.visibilityBlock = {(value)->Bool in
          if let v = value as? Bool {
            return v == true
          }
          return true
        }
      }))
      
      section.addCell(cell: BOPickerTableViewCell(withTitle: "Picker", key: "Cell4_Picker", { (cell) in
        if let pickerCell = cell as? BOPickerTableViewCell {
          pickerCell.pickerDescriptions = ["Germany",
                                           "UK",
                                           "Spain",
                                           "Austria",
                                           "USA"]
          pickerCell.pickerValues = ["de",
                                     "uk",
                                     "spain",
                                     "aus",
                                     "us"]
        }
        cell.visibilityKey = "switch"
        cell.visibilityBlock = {(value)->Bool in
          
          if let v = value as? Bool {
            return v == true
          }
          return true
          
        }
      }))
      
    }
    
    self.addSection(section: section)
    
    self.addSection(section: BOTableViewSection(withTitle: "Section 2") { (section) in
      section.addCell(cell: BOButtonTableViewCell(withTitle: "Button", key: nil, { (cell) in
        if let buttonCell = cell as? BOButtonTableViewCell {
          buttonCell.actionBlock = {(value) in
            let alert = UIAlertController(title: "Yo dawn", message: "i heard you like alerts", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
          }
        }
      }))
      section.footerTitle = "Static footer Title"
    })
    super.setup()

  }
}

