//
//  EditProfileInteractorTests.swift
//  SegurosMtyiOS
//
//  Created by Juan Eduardo Pacheco Osornio on 02/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//

@testable import Seguros_Mty
import XCTest

class EditProfileInteractorTests: XCTestCase {

    // MARK: Subject under test
    var sut: EditProfileInteractor!

    // MARK: Test lifecycle
    override func setUp() {
        super.setUp()
        setupEditProfileInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup
    func setupEditProfileInteractor() {
        sut = EditProfileInteractor()
    }

    // MARK: Test doubles

    // Mock Presenter
    class EditProfilePresentationLogicSpy: EditProfilePresentationLogic {
        var userInfoPresented = false
        var saveProfilePresented = false

        func presentUserInfo(response: EditProfile.GetUserInfo.Response) { userInfoPresented = true }
        func presentSaveProfile(response: EditProfile.SaveProfile.Response) { saveProfilePresented = true }
    }

    // MARK: Tests ************************************************************************************************

    func testShouldPresentUserInfo() {
        let spy = EditProfilePresentationLogicSpy()
        sut.presenter = spy
        sut.requestUserInfo()
        XCTAssertTrue(spy.userInfoPresented, "The interactor should call the presenter with user info.")
    }

//    func testShouldPresentSaveProfile() {
//        let spy = EditProfilePresentationLogicSpy()
//        sut.presenter = spy
//        sut.currentUser = UserInfo()
//        let req = EditProfile.SaveProfile.Request(email: "test@test.com", image: nil)
//        sut.requestSaveProfile(request: req)
//        XCTAssertTrue(spy.saveProfilePresented, "The interactor should call the presenter with save profile info")
//    }
}
