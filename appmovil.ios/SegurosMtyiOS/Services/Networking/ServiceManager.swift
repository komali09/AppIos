//
//  ServiceManager.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 11/29/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Alamofire
import Foundation
import Moya
import RxSwift


// MARK: - Servicios de Flujo de Login
/**
 Clase donde se centralizan los request a servicios web en la app
 */
class ServiceManager {    
    /**
     Método utilizado para validar el numero de telefono en el servidor
     - parameter phoneNumber: número teléfonico del usuario
     */
    static func validateNumber(phoneNumber: String) -> Observable<ValidateNumberResponse> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.validateNumber(phone: phoneNumber))
                .filterSuccessStatusCodes()
                .map(ApiResponse<ValidateNumberResponse>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para iniciar sesión en la aplicación
       - parameter phoneNumber: número teléfonico del usuario
       - parameter password: contraseña del usuario
     */
    static func login(phoneNumber: String, password: String) -> Observable<UserInfo> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.login(phone: phoneNumber, password: password))
                .filterSuccessStatusCodes()
                .map(ApiResponse<UserInfo>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    KeychainManager.shared.sessionToken = result.body.token
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para iniciar el proceso de recuperar contraseña
     - parameter phoneNumber: número teléfonico del usuario
     */
    static func generateCodeRecoverPassword(phoneNumber: String) -> Observable<GenerateCodeResponse> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.generateCodeToRecoverPassword(phone: phoneNumber))
                .filterSuccessStatusCodes()
                .map(ApiResponse<GenerateCodeResponse>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para iniciar el proceso de activar una cuenta
     - parameter phoneNumber: número teléfonico del usuario
     */
    static func generateCodeToActiveAccount(phoneNumber: String) -> Observable<GenerateCodeResponse> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.generateCodeToActiveAccount(phone: phoneNumber))
                .filterSuccessStatusCodes()
                .map(ApiResponse<GenerateCodeResponse>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    
    /**
     Método utilizado para obtener la fecha y hora actual del servidor
     */
    static func getServerTimestamp() -> Observable<Int> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.getServerTimestamp)
                .filterSuccessStatusCodes()
                .map(ApiResponse<Int>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    
    /**
     Método utilizado para iniciar el proceso de activar una cuenta
     - parameter phoneNumber: número teléfonico del usuario
     - parameter code: código que llego desde el SMS
     - parameter validationCodeProccessType: tipo de validación, si es para activar una cuenta o para recuperar una contraseña
     */
    static func verifyCodeSMS(phoneNumber: String, code: String, totpCode: String, validationCodeProccessType: ValidationCodeProccessType) -> Observable<VerifyCodeResponse> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.verifyCodeSMS(phone: phoneNumber, code: code, totpCode: totpCode, type: validationCodeProccessType))
                .filterSuccessStatusCodes()
                .map(ApiResponse<VerifyCodeResponse>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                   observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para asignar una contraseña a una cuenta
     - parameter phoneNumber: número teléfonico del usuario
     - parameter password: contraseña del usuario
     */
    static func renewPassword(phoneNumber: String, password: String, smsCode: String, totpCode: String) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.renewPassword(phone: phoneNumber, password: password, smsCode: smsCode, totpCode: totpCode))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(_):
                    observable.onNext(true)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para cambiar la contraseña a una cuenta
     - parameter oldPassword: vieja contraseña del usuario
     - parameter newPassword: nueva contraseña del usuario
     */
    static func changePassword(oldPassword: String, newPassword: String) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.changePassword(oldPassword: oldPassword, newPassword: newPassword))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(_):
                    observable.onNext(true)
                case .error(let moyaError):
                    observable.onError(moyaError)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }

}

// MARK: - Servicios de registro
extension ServiceManager {
    static func register(name: String, fatherLastName: String, motherLastName: String?, email: String, phone: String, password: String, date: String, policyId: String, certificateId: String?) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.register(name: name, fatherLastName: fatherLastName, motherLastName: motherLastName, email: email, phone: phone, password: password, date: date, policyId: policyId, certificateId: certificateId))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(_):
                    observable.onNext(true)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
}

// MARK: - Servicios de Pantalla Directorio
extension ServiceManager {
    /**
     Método utilizado para obtener las locaciones de Directorio
     - parameter planIncluded: obtener las locaciones que estan o no en el plan del usuario
     - parameter locationTypes: tipos de locaciones que se quieren obtener (Todos, Hospitales, Rehabilitación, Ópticas, Médicos, Enfermeria, etc.)
     - parameter searchTerms: Terminos de busqueda realizados (opcional)
     - parameter state: id de estado a consultar
     */
    static func getLocations(isPlanIncluded: Bool, serviceTypes: [ServiceType], state:Int, doctorTypes: [Specialty], searchTerms:String?) -> Observable<[Location]> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.locations(isPlanIncluded: isPlanIncluded, serviceTypes: serviceTypes, state:state, doctorTypes: doctorTypes, searchTerms: searchTerms))
                .filterSuccessStatusCodes()
                .map(ApiResponse<ApiListResponse<Location>>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body.list)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para obtener las locaciones favoritas de Directorio
     - parameter state: id de estado a consultar
     */
    static func getFavoriteLocations(state:Int) -> Observable<[Location]> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.favoriteLocations(state:state))
                .filterSuccessStatusCodes()
                .map(ApiResponse<ApiListResponse<Location>>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body.list)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para obtener el detalle de una ubicación especifica
     - parameter businessId: businessId de ubicacion
     - parameter providerId: providerId de ubicacion
     */
    static func getLocationDetail(businessId:Int, providerId: String) -> Observable<Location> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.locationDetail(businessId: "\(businessId)", providerId: providerId))
                .filterSuccessStatusCodes()
                .map(ApiResponse<Location>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para agregar una ubicacion especifica a favoritos
     - parameter businessId: businessId de ubicacion
     - parameter providerId: providerId de ubicacion
     - parameter state: id de estado a consultar
     */
    static func addLocationToFavorites(businessId:Int, providerId: String) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.addLocationToFavorites(businessId: "\(businessId)", providerId: providerId))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(_):
                    observable.onNext(true)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para remover una ubicacion especifica de favoritos
     - parameter businessId: businessId de ubicacion
     - parameter providerId: providerId de ubicacion
     - parameter state: id de estado a consultar
     */
    static func removeLocationFromFavorites(businessId:Int, providerId: String) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.removeLocationFromFavorites(businessId: "\(businessId)", providerId: providerId))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(_):
                    observable.onNext(false)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para obtener las sugerencias de texto para la caja de búsqueda
     - parameter searchTerms: Terminos de busqueda realizados
     */
    static func getLocationSearchSuggestions(searchTerms:String, state: Int) -> Observable<[String]> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.locationSearchSuggestions(searchTerms: searchTerms, state: state))
                .filterSuccessStatusCodes()
                .map(ApiResponse<ApiListResponse<String>>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body.list)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para obtener los estados disponibles
     */
    static func getStates() -> Observable<[State]> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.states())
                .filterSuccessStatusCodes()
                .map(ApiResponse<ApiListResponse<State>>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body.list)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para obtener la lista de especialidades de doctores para usarlo como filtros en las ubicaciones de hospitales
     */
    static func getDoctorSpecialities() -> Observable<[Specialty]> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.doctorSpecialities())
                .filterSuccessStatusCodes()
                .map(ApiResponse<ApiListResponse<Specialty>>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body.list)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
}

// MARK: - Servicios de Pantalla Perfil
extension ServiceManager {
    // MARK: - Polizas de seguro
    /**
     Method used to get all the asurance policies
     */
    static func getInsurancePolicies() -> Observable<[InsurancePolicy]> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.insurancePolicies())
                .filterSuccessStatusCodes()
                .map(ApiResponse<[InsurancePolicy]>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Method used to get an asurance policy detail
     - parameter policyId: identifier for the requested policy
     - parameter certificateId: certificate identifier for the requested policy
     */
    static func getInsurancePolicyDetail(policyId: String, certificateId: String?) -> Observable<InsurancePolicy> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.insurancePolicyDetail(policyId: policyId, certificateId: certificateId))
                .filterSuccessStatusCodes()
                .map(ApiResponse<InsurancePolicy>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método usado para obtener las coberturas de una póliza
     - parameter policyId: id de la póliza
     - parameter certificateId: certificado de la póliza
     */
    static func getCoveragesOfPolicy(policyId: String, certificateId: String?) -> Observable<[Coverage]> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.getCoveragesOfPolicy(policy: policyId, certificate: certificateId))
                .filterSuccessStatusCodes()
                .map(ApiResponse<ApiListResponse<Coverage>>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body.list)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
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
    static func setPrincipalPlan(policyId: String, certificateId: String?) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.setPrincipalPlan(policyId: policyId, certificateId: certificateId))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(_):
                    observable.onNext(true)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    
    /**
     Method used to get an asurance policy detail
     */
    static func insurancePolicyBeneficiaries(policyId: String, certificateId: String?) -> Observable<[Beneficiarie]> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.insurancePolicyBeneficiaries(policyId: policyId, certificateId: certificateId))
                .filterSuccessStatusCodes()
                .map(ApiResponse<BeneficiarieResponse>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body.list)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Method used to get the wallet for a policy
     */
    static func wallet(isTitularBeneficiare: Bool, nameBeneficiare: String?, fatherNameBeneficiare: String?, motherNameBeneficiare: String?, policyId: String, certificateId: String?) -> Observable<Data> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.wallet(isTitularBeneficiare: isTitularBeneficiare, nameBeneficiare: nameBeneficiare, fatherNameBeneficiare: fatherNameBeneficiare, motherNameBeneficiare: motherNameBeneficiare, policyId: policyId, certificateId: certificateId))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.data)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    static func getCertificate(policyId: String, certificateId: String) -> Observable<Data>  {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.certificate(policyId: policyId, certificateId: certificateId))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.data)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    // MARK: - Asistencias
    /**
     Method used to get all the advisor info
     - parameter assistanceType: identifier for the requested assistance
     */
    static func getAssistancesInfo(id: Int) -> Observable<[AssistanceItem]> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.assistances(type: id))
                .filterSuccessStatusCodes()
                .map(ApiResponse<[AssistanceItem]>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }

    
    // MARK: - Agentes
    /**
     Method used to get all the advisor info
     */
    static func getAdvisorInfo() -> Observable<Advisor> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.advisorInfo())
                .filterSuccessStatusCodes()
                .map(ApiResponse<Advisor>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }

    // MARK: - Perfil
    /**
     Método utilizado para actualizar el correo electrónico del usuario
     - parameter email: Nueva dirección de correo del usuario
     */
    static func updateEmailAddress(email: String) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }

        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.editProfile(email: email))
                .filterSuccessStatusCodes()

            let disposable = request.subscribe { event in
                switch event {
                case .success(_):
                    observable.onNext(true)
                case .error(let moyaError):
                    observable.onError(moyaError)
                }
            }

            return Disposables.create {
                disposable.dispose()
            }
        }
    }

    /**
     Método utilizado para cerrar sesión en la aplicación
     */
    static func logout() -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else { return Observable.error(NetworkingError.noInternet) }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.logout())
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(_):
                    observable.onNext(true)
                case .error(let moyaError):
                    observable.onError(moyaError)
                }
            }

            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para obtener los contactos de emergencia del usuario
     */
    static func getEmergencyContacts() -> Observable<[EmergencyContact]> {
        guard ReachabilityManager.shared.isOnline else {
            return Observable.error(NetworkingError.noInternet)
        }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.getEmergencyContacts())
                .filterSuccessStatusCodes()
                .map(ApiResponse<ApiListResponse<EmergencyContact>>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body.list)
                case .error(let moyaError):
                    observable.onError(moyaError)
                }
            }
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para agregar un contacto de emergencia
     */
    static func addEmergencyContact(emergencyContact: EmergencyContact) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else {
            return Observable.error(NetworkingError.noInternet)
        }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.addEmergencyContact(emergencyContact: emergencyContact))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    debugPrint(result)
                    // KeychainManager.shared.sessionToken = result.body.sessionToken ?? ""
                    observable.onNext(true)
                case .error(let moyaError):
                    observable.onError(moyaError)
                }
            }
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para editar un contacto de emergencia
     */
    static func editEmergencyContact(emergencyContact: EmergencyContact) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else {
            return Observable.error(NetworkingError.noInternet)
        }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.editEmergencyContact(emergencyContact: emergencyContact))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    debugPrint(result)
                   // KeychainManager.shared.sessionToken = result.body.sessionToken ?? ""
                    observable.onNext(true)
                case .error(let moyaError):
                    observable.onError(moyaError)
                }
            }
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para eliminar un contacto de emergencia
     */
    static func deleteEmergencyContact(emergencyContactID: Int) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else {
            return Observable.error(NetworkingError.noInternet)
        }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.deleteEmergencyContact(emergencyContactID: emergencyContactID))
                .filterSuccessStatusCodes()
                .map(ApiResponse<EmergencyResponse>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    KeychainManager.shared.sessionToken = result.body.sessionToken ?? ""
                    observable.onNext(true)
                case .error(let moyaError):
                    observable.onError(moyaError)
                }
            }
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para realizar la petición de emergencia
     */
    static func emergencyPetition( type: Int ) -> Observable<EmergencyResponse> {
        guard ReachabilityManager.shared.isOnline else {
            return Observable.error(NetworkingError.noInternet)
        }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.emergencyPetition(type: type))
                .filterSuccessStatusCodes()
                .map(ApiResponse<EmergencyResponse>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    //KeychainManager.shared.sessionToken = result.body.token
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para agregar una nueva póliza
     */
    static func verifyPolicy(newPolicy: String, newCertificate: String? ) -> Observable<PolicyType> {
        guard ReachabilityManager.shared.isOnline else {
            return Observable.error(NetworkingError.noInternet)
        }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
             let request = provider.rx.request(.validatePolicy(policy: newPolicy, certificate: newCertificate))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(_):
                    if let _ = newCertificate {
                        observable.onNext(PolicyType.collective)
                    } else {
                        observable.onNext(PolicyType.individual)
                    }
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para agregar una nueva póliza
     */
    static func addPolicy(newPolicy: String, newCertificate: String? ) -> Observable<Bool> {
        guard ReachabilityManager.shared.isOnline else {
            return Observable.error(NetworkingError.noInternet)
        }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            let request = provider.rx.request(.addPolicy(policy: newPolicy, certificate: newCertificate))
                .filterSuccessStatusCodes()
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(_):
                    observable.onNext(true)
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Método utilizado para verificar la poliza individual o colectiva en registro
     */
    static func verifyPolicyRegister(policy: String, certificate: String? ) -> Observable<VerifyPolicyResponse> {
        guard ReachabilityManager.shared.isOnline else {
            return Observable.error(NetworkingError.noInternet)
        }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.validatePolicyRegister(policy: policy, certificate: certificate))
                .filterSuccessStatusCodes()
                .map(ApiResponse<VerifyPolicyResponse>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Metodo utilizado para obtener los beneficios de un hospital
     - parameter providerId: identifica el id del provedor.
     */
    static func getBenefitsHospital(providerId: String) -> Observable<[BenefitService]> {
        guard ReachabilityManager.shared.isOnline else {
            return Observable.error(NetworkingError.noInternet)
        }
        
        return Observable.create { observable in
            let provider = APIProvider<ApiService>()
            
            let request = provider.rx.request(.getBenefitsHospital(providerId: providerId))
                .filterSuccessStatusCodes()
                .map(ApiResponse<ApiListResponse<BenefitService>>.self)
            
            let disposable = request.subscribe { event in
                switch event {
                case .success(let result):
                    observable.onNext(result.body.list)
                    observable.onCompleted()
                case .error(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
}
