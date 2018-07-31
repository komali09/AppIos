//
//  PrivacyModels.swift
//  SegurosMtyiOS
//
//  Created by Mariana on 26/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

enum Privacy {
    
    enum WebViewPrivacy {
        struct Request {
            var url: String
        }
        struct Response {
            var isSuccess: Bool
            var url: String?
        }
        struct ViewModel {
            var url: String
        }
    }
}