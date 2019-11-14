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
        sut.password = "Hogwarts"
        sut.confirmPassword = "Hogwarts"
        sut.displayPasswordsMatchError = false
        sut.processInput()
        XCTAssertEqual(sut.displayUsernameFormatError, true, "Username must not be empty")
    }

    func testEmptyPassword() {
          sut.firstName = "Harry"
          sut.lastName = "Potter"
          sut.username = "Harry"
          sut.password = " "
          sut.confirmPassword = ""
          sut.displayPasswordsMatchError = false
          sut.processInput()
          XCTAssertEqual(sut.displayPasswordFormatError, true, "Password must not be empty")
      }

    func testNormal() {
            sut.firstName = "Harry"
            sut.lastName = "Potter"
            sut.username = "Harry"
            sut.password = "Gryffindor"
            sut.confirmPassword = "Gryffindor"
            sut.processInput()
            XCTAssertEqual(sut.displayPasswordFormatError, false, "No errors should occur")
    }

    func testNonMatchingPassword() {
            sut.firstName = "Harry"
            sut.lastName = "Potter"
            sut.username = "Harry"
            sut.password = "Gryffindor01!"
            sut.confirmPassword = "Gryffindor10"
            sut.processInput()
            XCTAssertEqual(sut.displayPasswordsMatchError, true, "Both passwords must match")
    }

    func invalidUsernameError() {
            sut.firstName = "Harry"
            sut.lastName = "Potter"
            sut.username = ""
            sut.password = "Gryffindor01"
            sut.confirmPassword = "Gryffindor01"
            sut.processInput()
            XCTAssertEqual(sut.displayUsernameFormatError, true, "Blank username should not be allowed")
    }

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
