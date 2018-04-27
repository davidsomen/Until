//
//  DaysUntilUITests.swift
//  DaysUntilUITests
//
//  Created by David Somen on 2018/04/13.
//  Copyright © 2018 David Somen. All rights reserved.
//

import XCTest
@testable import DaysUntil

class DaysUntilUITests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateEvent()
    {
        
    }
    
    func testDeleteEvent()
    {
        
    }
    
    func testEditEvent()
    {
        
    }
    
    func testScreenshots()
    {
        let app = XCUIApplication()

        app.tables.cells.firstMatch.tap()
        
        snapshot("1-Edit")
        
        app.buttons["cancelButton"].tap()
        
        let elementsQuery = app.tables.scrollViews.otherElements
        
        snapshot("0-Events-Orange")
        
        let button = elementsQuery.children(matching: .button).element(boundBy: 1)
        button.swipeLeft()
        
        let button2 = elementsQuery.children(matching: .button).element(boundBy: 2)
        button2.tap()
        
        let okButton = app.alerts.buttons.firstMatch
        
        if okButton.waitForExistence(timeout: 1)
        {
            okButton.tap()
        }
        
        snapshot("2-Events-Purple")
        
        button2.swipeLeft()

        let button3 = elementsQuery.children(matching: .button).element(boundBy: 3)
        button3.tap()
        
        if okButton.waitForExistence(timeout: 1)
        {
            okButton.tap()
        }
        
        snapshot("3-Events-Blue")
        
        button3.swipeLeft()
        
        let button4 = elementsQuery.children(matching: .button).element(boundBy: 4)
        button4.tap()
        
        if okButton.waitForExistence(timeout: 1)
        {
            okButton.tap()
        }
        
        snapshot("4-Events-Green")
    }
}
