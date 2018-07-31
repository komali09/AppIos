//
//  Session.swift
//  SegurosMtyiOS
//
//  Created by Rafael Jimeno Osornio on 12/6/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

class Session: NSObject {

    static let shared = Session()
    private override init() {}
    
    var user: User?
    
}
