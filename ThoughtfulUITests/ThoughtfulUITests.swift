//
//  ThoughtfulUITests.swift
//  ThoughtfulUITests
//
//  Created by Nabil Ridhwan on 20/6/24.
//

import XCTest

final class ThoughtfulUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_HomeView_addThoughtButton_shouldShowAddScreen() {
        let app = XCUIApplication()
        app.buttons["Add"].tap()
        app.collectionViews/*@START_MENU_TOKEN@*/ .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements.buttons["What are three things you are grateful for today?"].tap()
        app.collectionViews/*@START_MENU_TOKEN@*/ .textViews["Type your reply..."]/*[[".cells.textViews[\"Type your reply...\"]",".textViews[\"Type your reply...\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
        app.collectionViews/*@START_MENU_TOKEN@*/ .textViews["Type your reply..."]/*[[".cells.textViews[\"Type your reply...\"]",".textViews[\"Type your reply...\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .typeText("TEST SUITE")
        app.navigationBars.buttons["Add"].tap()

        let newThought = app.staticTexts["TEST SUITE"]
        XCTAssertTrue(newThought.exists, "The new thought should be displayed on the screen")
    }

    func test_HomeView_addThoughtFlow_shouldNotAllowAddWhenResponseIsEmpty() {
        let app = XCUIApplication()
        app.buttons["Add"].tap()
        app.collectionViews/*@START_MENU_TOKEN@*/ .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements.buttons["Who is someone you feel especially grateful to have in your life? Why?"].tap()

        let addButton = app.navigationBars/*@START_MENU_TOKEN@*/ .buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        XCTAssertFalse(addButton.isEnabled, "Add should not be allowed when Response is empty")
    }

    func test_HomeView_addThoughtFlow_shouldRemoveEmotionOnClickAgain() {
        let app = XCUIApplication()
        app.buttons["Add"].tap()

        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/ .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements.buttons["What are three things you are grateful for today?"].tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/ .textViews["Type your reply..."]/*[[".cells.textViews[\"Type your reply...\"]",".textViews[\"Type your reply...\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()

        let emotionButton = collectionViewsQuery/*@START_MENU_TOKEN@*/ .buttons["Emotion"]/*[[".cells.buttons[\"Emotion\"]",".buttons[\"Emotion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        emotionButton.tap()

        let elementsQuery = app.scrollViews.otherElements
        elementsQuery/*@START_MENU_TOKEN@*/ .images["awesomeNoFace"]/*[[".buttons[\"Awesome\"].images[\"awesomeNoFace\"]",".images[\"awesomeNoFace\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
        emotionButton.tap()
        elementsQuery.buttons["Awesome"].tap()

        let emotion = app.buttons["Awesome"]
        XCTAssertFalse(emotion.exists, "The emotion should be removed")
    }

    func test_SettingsView_nameField_shouldChangeGreetingBasedOnName() {
        let app = XCUIApplication()
        app.buttons["Settings"].tap()

        //        Random UUID string
        let nameToInput = "testuser123"
        let nameTextField = app.collectionViews/*@START_MENU_TOKEN@*/ .textFields["Name"]/*[[".cells.textFields[\"Name\"]",".textFields[\"Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        nameTextField.tap()
        nameTextField.clearText()
        nameTextField.typeText(nameToInput)

        //        Dismiss keyboard
        nameTextField.typeText("\n")

        app.buttons["Home"].tap()

        //        https://stackoverflow.com/a/47253096
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", nameToInput)
        let elementQuery = app.staticTexts.containing(predicate)

        XCTAssertTrue(elementQuery.count > 0, "The app should change the name based on the Settings page")
    }
}

extension XCUIElement {
    func clearText() {
        //
        // cf. and tip courtesy of
        //    https://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
        //

        guard let stringValue = value as? String else {
            return
        }
        // workaround for apple bug
        if let placeholderString = placeholderValue, placeholderString == stringValue {
            return
        }

        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        typeText(deleteString)
    }

    func typeTextAndPressEnter(_ text: String) {
        typeText("\(text)\n")
    }
}
