//
//  AboutModels.swift
//  SegurosMtyiOS
//
//  Created by Israel Gutiérrez Castillo on 23/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import MessageUI

enum About {
    // MARK: Use cases
    
    enum SendMail {
        struct Request {
            
            var emailDirectionToSend: String
            
        }
        
        struct ViewModel {
            
            var mailComposeViewController: MFMailComposeViewController
            
        }
    }
}