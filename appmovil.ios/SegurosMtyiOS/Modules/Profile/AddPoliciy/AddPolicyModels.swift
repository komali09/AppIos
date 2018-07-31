//
//  AddPolicyModels.swift
//  SegurosMtyiOS
//
//  Created by Israel Gutiérrez Castillo on 17/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//


enum VerifyPolicyInfoType {
    case policy
    case certificate
}

enum VerifyCollectiveError: Error {
    case notValidCertificate
}

enum AddPolicy {
    // MARK: Use cases
    enum AddPolicyValid {
        struct Request {
            var policy: String
            var certicate: String?
            var type: PolicyType
        }
        struct Response {
            var type: PolicyType
            var error: Error?
        }
        struct ViewModel {
            var type: PolicyType
            var validationState: TextFieldValidationState
        }
    }
    
}
