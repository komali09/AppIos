//
//  PolicyAssistanceDetailWorker.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/24/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
import RxSwift

class PolicyAssistanceDetailWorker {
    /**
     Method used to get assistances info
     - parameter assistanceType: identifier for the requested assistance
     */
    func getAssistancesInfo(assistanceType: AssistanceType) -> Observable<[AssistanceItem]> {
        return Observable.create { observable in
            let disposable = ServiceManager.getAssistancesInfo(id: assistanceType.rawValue).subscribe { event in
                switch event {
                case .next(let result):
                    observable.onNext(result.sorted())
                case .error(let error):
                    observable.onError(error)
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
}
