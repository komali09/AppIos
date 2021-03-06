//
//  CheckCodeModels.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 07/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

enum ValidationCodeProccessType: Int {
    case recovery = 1
    case activate = 2
}

enum VerifyCodeStatus {
    case success(message: String)
    case invalidPhoneOrCode(message: String)
    case errorWithData(message: String)
    case other(message:String)
}

enum CheckCode {
    // MARK: Use cases
    enum VerifyCode {
        struct Response {
            var error:Swift.Error?
            var validationCodeProccessType: ValidationCodeProccessType
        }
        struct ViewModel {
            var status: VerifyCodeStatus
            var validationCodeProccessType: ValidationCodeProccessType
        }
    }
}
