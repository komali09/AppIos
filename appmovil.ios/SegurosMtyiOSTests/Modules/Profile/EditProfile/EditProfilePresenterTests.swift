//
//  EditProfilePresenterTests.swift
//  SegurosMtyiOS
//
//  Created by Juan Eduardo Pacheco Osornio on 02/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//

import XCTest
@testable import Seguros_Mty

class EditProfilePresenterTests: XCTestCase {

    // MARK: Subject under test
    var sut: EditProfilePresenter!

    // MARK: Test lifecycle
    override func setUp() {
        super.setUp()
        setupEditProfilePresenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup
    func setupEditProfilePresenter() {
        sut = EditProfilePresenter()
    }

    // MARK: Test doubles
    class EditProfileDisplayLogicSpy: EditProfileDisplayLogic {
        var userInfoDisplayed = false
        var saveProfileDisplayed = false

        func displayUserInfo(viewModel: EditProfile.GetUserInfo.ViewModel) { userInfoDisplayed = true }
        func displaySaveProfile(viewModel: EditProfile.SaveProfile.ViewModel) { saveProfileDisplayed = true }
    }

    // MARK: Tests **************************************************************************************************

    func testShouldDisplayUserInfo() {
        let spy = EditProfileDisplayLogicSpy()
        sut.viewController = spy
        let resp = EditProfile.GetUserInfo.Response(email: "test@test.com", profilePic: nil)
        sut.presentUserInfo(response: resp)
        XCTAssertTrue(spy.userInfoDisplayed, "The Presenter should call the view controller to display the user info.")
    }

    func testShouldDisplaySaveProfile() {
        let spy = EditProfileDisplayLogicSpy()
        sut.viewController = spy
        let resp = EditProfile.SaveProfile.Response(error: nil)
        sut.presentSaveProfile(response: resp)
        XCTAssertTrue(spy.saveProfileDisplayed, "The Presenter should call the view controller to display the save info.")
    }
}
