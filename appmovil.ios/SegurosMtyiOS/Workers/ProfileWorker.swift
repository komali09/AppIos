//
//  ProfileWorker.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/7/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
import RxSwift

class ProfileWorker {

    // MARK: - Public Methods
    func loadUserInfo() -> UserInfo? {
        return UserDefaultsManager.shared.userInfo
    }
    
    // MARK: - Public Methods
    func loadUserPhone() -> String? {
        return KeychainManager.shared.phoneNumber
    }
    
    func saveUserInfo(_ userInfo: UserInfo) {
        UserDefaultsManager.shared.userInfo = userInfo
    }
    
    /**
     Realiza la peticion al servicio para obtener los contactos de emergencia
     */
    func getEmergencyContactsData() -> Observable<[EmergencyContact]> {
        return Observable.create { observable in
            let disposable = ServiceManager.getEmergencyContacts().subscribe { event in
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
     Execute the request to get the insurance policies of the user
    */
    func getInsurancePolicies() -> Observable<[InsurancePolicy]> {

        return Observable.create { observable in
            let disposable = ServiceManager.getInsurancePolicies().subscribe { event in
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
     Execute the request to get the advisor info of the user
     */
    func getAdvisorInfo() -> Observable<Advisor> {
        
        return Observable.create { observable in
            let disposable = ServiceManager.getAdvisorInfo().subscribe { event in
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
     Gets the current profile pic, if it exists
     */
    func loadUserProfilePic() -> UIImage? {
        guard let phoneNumber = loadUserPhone() else { return nil }
        return FilesManager.getImageInDocuments(name: "UserProfile\(phoneNumber).png") ?? UIImage(named: "defaultAvatar")
    }

    /**
     Saves the edited user info on device and on service.
     */
    func editUserEmail(email: String) -> Observable<Bool> {
        IALoader.shared.show(LocalizableKeys.Loader.editProfile)
        return Observable.create { observable in
            let disposable = ServiceManager.updateEmailAddress(email: email).subscribe { event in
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
     Realiza la peticion al servicio para cerrar sesión
     */
    func logout() -> Observable<Bool> {
        IALoader.shared.show(LocalizableKeys.Loader.logout)
        return Observable.create { observable in
            let disposable = ServiceManager.logout().subscribe { event in
                UserDefaultsManager.shared.deleteAll()
                
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
}
