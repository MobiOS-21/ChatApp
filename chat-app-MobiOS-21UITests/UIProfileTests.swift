//
//  UIProfileTests.swift
//  chat-app-MobiOS-21UITests
//
//  Created by Александр Дергилёв on 06.12.2021.
//

import XCTest

class UIProfileTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testProfileInputs() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars
        
        let navBarProfileBtn = navBar.buttons["profileButton"]
        _ = navBarProfileBtn.waitForExistence(timeout: 5)
        XCTAssert(navBarProfileBtn.exists)
        navBarProfileBtn.tap()
        
        let nameTextField = app.textFields.firstMatch
        _ = nameTextField.waitForExistence(timeout: 3)
        XCTAssert(nameTextField.exists)
        
        let descrTextView = app.textViews.firstMatch
        _ = descrTextView.waitForExistence(timeout: 3)
        XCTAssert(descrTextView.exists)
        
        let textFieldCount = app.descendants(matching: .textField).count
        let textViewCount = app.descendants(matching: .textView).count
        
        XCTAssertEqual(textFieldCount, 1)
        XCTAssertEqual(textViewCount, 1)
    }
}
