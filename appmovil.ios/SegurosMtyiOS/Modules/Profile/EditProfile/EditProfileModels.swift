//
//  EditProfileModels.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 28/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

import UIKit

enum EditProfile {

    enum GetUserInfo {
        struct Response {
            let email: String!
            let profilePic: UIImage?
        }
        struct ViewModel {
            let email: String!
            let userPicture: UIImage?
        }
    }

    enum SaveProfile {
        struct Request {
            let email: String!
            let image: UIImage?
        }
        struct OnlyImageRequest {
            let image: UIImage?
        }
        struct ViewModel {
            let msg: String!
        }
    }
}
