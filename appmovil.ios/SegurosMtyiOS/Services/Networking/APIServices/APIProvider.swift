//
//  APIProvider.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 09/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import UIKit
import Moya
import RxSwift
import Alamofire
import Reachability

class APIProvider<T>: MoyaProvider<T> where T: TargetType {
    internal var customManager : Alamofire.SessionManager = {
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["148.243.174.54": .disableEvaluation,
                                                                "148.243.174.61": .disableEvaluation]
        
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
    init(stub: Bool = false) {
        let stubClosure: MoyaProvider<T>.StubClosure = stub ? MoyaProvider.delayedStub(1.0) : MoyaProvider.neverStub
        super.init(stubClosure: stubClosure, manager: customManager)
    }
}

