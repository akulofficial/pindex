//
//  PindexTests.swift
//  PindexTests
//
//  Created by Akul Gulrajani on 9/29/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import XCTest
@testable import Pindex


var sut: CreateAccountView!
class PindexTests: XCTestCase {
    var sut: CreateAccountView!

    override func setUp() {
        super.setUp()
        sut = CreateAccountView()

    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testEmptyUsername() {
        sut.firstName = "Harry"
        sut.lastName = "Potter"
        sut.username = ""
        sut.password = "Hogwarts123!"
        sut.confirmPassword = "Hogwarts123!"
        let testResult = sut.isUsernameValid(username: sut.username)
        XCTAssertEqual(testResult, false, "Username must not be empty")
    }

    func testEmptyPassword() {
          sut.firstName = "Harry"
          sut.lastName = "Potter"
          sut.username = "Harry"
          sut.password = ""
          sut.confirmPassword = ""
          let testResult = sut.isPasswordValid(password: sut.password)
          XCTAssertEqual(testResult, false, "Password must not be empty")
      }

    func testUsernameNormal() {
        sut.firstName = "Harry"
        sut.lastName = "Potter"
        sut.username = "Harryf"
        sut.password = "1"
        sut.confirmPassword = "1"
        let testResult = sut.isUsernameValid(username: sut.username)
        XCTAssertEqual(testResult, false, "No errors should occur")
    }
    
    func testPasswordNormal() {
        sut.firstName = "Harry"
        sut.lastName = "Potter"
        sut.username = "Harry"
        sut.password = "Gryffindor01"
        sut.confirmPassword = "Gryffindor01"
        let testResult = sut.isPasswordValid(password: sut.password)
        XCTAssertEqual(testResult, false, "No errors should occur")
    }

    func testNonMatchingPassword() {
            let password = "Gryffindor01"
            let confirmPassword = "Gryffindor10"
            let testResult = sut.isPasswordMatch(passwordOne: password, passwordTwo: confirmPassword)
            XCTAssertEqual(testResult,  false, "Both passwords must match")
    }

//    func invalidUsernameError() {
//            sut.firstName = "Harry"
//            sut.lastName = "Potter"
//            sut.username = ""
//            sut.password = "Gryffindor01"
//            sut.confirmPassword = "Gryffindor01"
//            sut.processInput()
//            XCTAssertEqual(sut.displayUsernameFormatError, true, "Blank username should not be allowed")
//    }

//    func invalidFirstNameError() {
//              sut.firstName = ""
//              sut.lastName = "Potter"
//              sut.username = ""
//              sut.password = "Gryffindor01"
//              sut.confirmPassword = "Gryffindor01"
//              sut.processInput()
//              XCTAssertEqual(sut.displayFirstNameError, true, "Blank password should not be allowed")
//      }

//    func invalidLastNameError() {
//            sut.firstName = "Harry"
//            sut.lastName = ""
//            sut.username = "harryp"
//            sut.password = "Gryffindor01"
//            sut.confirmPassword = "Gryffindor01"
//            sut.processInput()
//            XCTAssertEqual(sut.displayInvalidLastNameError, true, "Blank password should not be allowed")
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
