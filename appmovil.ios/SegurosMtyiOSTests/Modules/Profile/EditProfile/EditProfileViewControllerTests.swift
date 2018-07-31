//
//  EditProfileViewControllerTests.swift
//  SegurosMtyiOS
//
//  Created by Juan Eduardo Pacheco Osornio on 02/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//

import XCTest

@testable import Seguros_Mty

class EditProfileViewControllerTests: XCTestCase {

    // MARK: Subject under test
    var sut: EditProfileViewController!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupEditProfileViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup
    func setupEditProfileViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "EditProfile", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles

    // Mock Interactor
    class EditProfileBusinessLogicSpy: EditProfileBusinessLogic {
        var userInfoRequested = false
        var saveProfileRequested = false

        func requestUserInfo() { userInfoRequested = true }
        func requestSaveProfile(request: EditProfile.SaveProfile.Request) { saveProfileRequested = true }
    }

    // Mock Router
    class EditProfileRoutingLogicSpy: NSObject, EditProfileRoutingLogic, EditProfileDataPassing {
        var dataStore: EditProfileDataStore?
        var routedToEditPassword = false

        func goToEditPasswordViewController() { routedToEditPassword = true }
    }

    // MARK: Tests ***********************************************************************************************

    // Requests
    func testShouldRequestUserInfo() {
        let spy = EditProfileBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        XCTAssertTrue(spy.userInfoRequested, "Should request user info on view load.")
    }

    func testShouldRequestSaveProfile() {
        let spy = EditProfileBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        sut.saveButtonPressed(sut.saveButton)
        XCTAssertTrue(spy.saveProfileRequested, "Should request info saving on save button press")
    }

    // Displays
    func testShouldDisplayUserInfo() {
        let testEmail = "test@test.com"
        let viewModel = EditProfile.GetUserInfo.ViewModel(email: testEmail, userPicture: nil)
        loadView()
        sut.displayUserInfo(viewModel: viewModel)
        XCTAssertEqual(sut.emailTextField.text, testEmail, "Should update UI with User info")
    }

    // Routing
    func testShouldRouteToEditPassword() {
        let spy = EditProfileRoutingLogicSpy()
        sut.router = spy
        loadView()
        sut.editPasswordPressed(UIButton())
        XCTAssertTrue(spy.routedToEditPassword, "Should route to Edit Password Scene on Cambiar Contraseña button")
    }
}
