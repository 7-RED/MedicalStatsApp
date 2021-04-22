//
//  CucumberishInitializer.swift
//  MSBDDUITests
//
//  Created by 陳其宏 on 2021/4/22.
//

import Foundation
import XCTest
import Cucumberish

class CucumberishInitializer: NSObject{
    
    @objc class func setupCucumberish(){
        before({ _ in
            
            Given("I launch the app"){args, _ in
                XCUIApplication().launch()
            }
            
            When("I enter \"([^\\\"]*)\" in the textfield and press add button"){args, _ in
                
                let task = (args?[0])!
                
                let taskTextField = XCUIApplication().textFields["taskNameTextField"]
                taskTextField.tap()
                taskTextField.typeText(task + "\n")
                
                XCUIApplication().buttons["addTaskButton"].tap()
                
                
            }
            
            Then("I should see \"([^\\\"]*)\" item added to the list"){args, _ in
                
                let expectedCount = Int((args?[0])!)
                
                let count = XCUIApplication().tables.children(matching: .cell).count
                XCTAssertEqual(expectedCount!, count)
                
                
            }
            
            
        })
        
        let bundle = Bundle(for: CucumberishInitializer.self)
        Cucumberish.executeFeatures(inDirectory: "Features",from: bundle, includeTags: nil,excludeTags: nil)
    }
}
