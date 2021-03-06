//
//  CheckPolicyInteractor.swift
//  SegurosMtyiOS
//
//  Created by Mariana on 19/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import RxSwift

protocol CheckPolicyBusinessLogic {
    func validatePolicy(request: CheckPolicy.RegisterPolicy.Request)
}

protocol CheckPolicyDataStore {
    var policy: String { get set }
    var certificate: String? { get set }
}

class CheckPolicyInteractor: CheckPolicyBusinessLogic, CheckPolicyDataStore {
    var presenter: (CheckPolicyPresentationLogic & ErrorPresentationLogic)?
    var worker: RegisterWorker?
    
    // MARK: DataStore
    
    var policy: String = ""
    var certificate: String?
    
    // MARK: Do something
    
    var disposableBag: DisposeBag = DisposeBag()
    
    func validatePolicy(request: CheckPolicy.RegisterPolicy.Request) {
        worker = RegisterWorker()
        worker?.verifyPolicy(request.policy, certificateId: request.certicate).subscribe({ [weak self] event in
            switch event {
            case .next(_):
                self?.policy = request.policy
                self?.certificate = request.certicate
                let response = CheckPolicy.RegisterPolicy.Response(type: request.type, error: nil)
                self?.presenter?.presentPolicyValidationSuccess(response: response)
            case .error(let error):
                let response = CheckPolicy.RegisterPolicy.Response(type: request.type, error: error)
                self?.presenter?.presentPolicyValidationError(response: response)
            default:
                break
            }
        }).disposed(by: self.disposableBag)
    }
}
