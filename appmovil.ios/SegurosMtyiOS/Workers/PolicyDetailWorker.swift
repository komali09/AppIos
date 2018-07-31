//
//  PolicyDetailWorker.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/9/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import RxSwift
import PassKit

class PolicyDetailWorker {
    
    /**
     Method used to get an asurance policy detail
     - parameter policyId: identifier for the requested policy
     - parameter certificateId: certificate identifier for the requested policy
     */
    func getInsurancePolicyDetail(policyId:String, certificateId: String?) -> Observable<InsurancePolicy> {
        return Observable.create { observable in
            let disposable = ServiceManager.getInsurancePolicyDetail(policyId: policyId, certificateId: certificateId).subscribe { event in
                switch event {
                case .next(let result):
                    observable.onNext(result)
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
    
    /**
     Method used to set an asurance policy as Principal
     - parameter policyId: identifier for the requested policy
     - parameter certificateId: certificate identifier for the requested policy
     */
    func setPrincipalPlan(policyId:String, certificateId: String?) -> Observable<Bool> {
        return Observable.create { observable in
            let disposable = ServiceManager.setPrincipalPlan(policyId: policyId, certificateId: certificateId).subscribe { event in
                switch event {
                case .next(let result):
                    observable.onNext(result)
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
    
    /**
     Method used to get asurance a policy beneficiaries
     - parameter policyId: identifier for the requested policy
     - parameter certificateId: certificate identifier for the requested policy
     */
    func getInsurancePolicyBeneficiaries(policyId:String, certificateId: String?) -> Observable<[Beneficiarie]> {
        return Observable.create { observable in
            let disposable = ServiceManager.insurancePolicyBeneficiaries(policyId: policyId, certificateId: certificateId).subscribe { event in
                switch event {
                case .next(let result):
                    if result.count > 0 {
                        observable.onNext(result)
                    } else {
                        observable.onError(NetworkingError.noData)
                    }
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
    
    /**
     Method used to get coverages a policy
     - parameter policyId: identifier for the requested policy
     - parameter certificateId: certificate identifier for the requested policy
     */
    func getInsurancePolicyCoverages(policyId:String, certificateId: String?) -> Observable<[Coverage]> {
        return Observable.create { observable in
            let disposable = ServiceManager.getCoveragesOfPolicy(policyId: policyId, certificateId: certificateId).subscribe { event in
                switch event {
                case .next(let result):
                    observable.onNext(result)
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
    
    /**
     Method used to get the wallet for a policy
     - parameter policyId: identifier for the requested policy
     - parameter certificateId: certificate identifier for the requested policy
     */
    func getWallet(isTitularBeneficiare: Bool, nameBeneficiare: String?, fatherNameBeneficiare: String?, motherNameBeneficiare: String?, policyId:String, certificateId: String?) -> Observable<PKPass>{
        return Observable.create { observable in
            let disposable = ServiceManager.wallet(isTitularBeneficiare: isTitularBeneficiare, nameBeneficiare: nameBeneficiare, fatherNameBeneficiare: fatherNameBeneficiare, motherNameBeneficiare: motherNameBeneficiare, policyId: policyId, certificateId: certificateId).subscribe { event in
                switch event {
                case .next(let result):
                    var error : NSError?
                    let pass = PKPass(data: result, error: &error)
                    if let passError = error {
                        observable.onError(passError)
                    }else {
                        observable.onNext(pass)
                    }
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
    
    /**
     Method used to get the certificate file for a policy
     - parameter policyId: identifier for the requested policy
     - parameter certificateId: certificate identifier for the requested policy
     */
    func getCertificate(with policyId: String, certificateId: String) -> Observable<URL> {
        return Observable.create { observable in
            let disposable = ServiceManager.getCertificate(policyId: policyId, certificateId: certificateId).subscribe { event in
                switch event {
                case .next(let result):
                    let filename = "\(policyId)-\(certificateId)"
                    
                    do {
                        let filePath = try self.decodeDataFile(data: result, fileName: filename)
                        observable.onNext(filePath)
                    } catch let error {
                        observable.onError(error)
                    }
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
    
    private func decodeDataFile(data: Data, fileName: String) throws -> URL {
        do {
            let DocumentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let pathURLFile = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("pdf")
            
            debugPrint("Saving File: \(pathURLFile.path)")
            
            try data.write(to: pathURLFile, options: .atomicWrite)
            
            return pathURLFile
        } catch {
            throw NetworkingError.noData
        }
    }
}
