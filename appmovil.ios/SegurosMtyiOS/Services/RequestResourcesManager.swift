//
//  RequestResourcesManager.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 17/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import RxSwift
import AVFoundation
import Photos
import Contacts

/** 
 Clase que se encarga del solicitar acceso a recursos o información del dispositivo
 */

class RequestResourcesManager {
    
    /** 
     Método para pedir acceso a la camara del dispostivo
     */
    static func isAuthorizedToUseCamera() -> Observable<Bool> {
        return Observable.create { observable in
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    observable.onNext(true)
                } else {
                    observable.onNext(false)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /** 
     Método para pedir acceso a las fotos de carrete del dispositivo
     */
    static func isAuthorizedToAccessPhotos() -> Observable<Bool> {
        return Observable.create { observable in
            
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        observable.onNext(true)
                    } else {
                       observable.onNext(false)
                    }
                })
            } else if photos == .authorized {
                observable.onNext(true)
            } else if photos == .denied {
                observable.onNext(false)
            }
            
            return Disposables.create()
        }
    }
    
    /** 
     Método para pedir acceso a los contactos del dispositivo
     */
    static func isAuthorizedToAccessContacts() -> Observable<Bool> {
        return Observable.create { observable in
            
           let contactStore = CNContactStore()
            
            contactStore.requestAccess(for: .contacts, completionHandler: { (status, error) in
                if status {
                    observable.onNext(true)
                } else {
                    if UserDefaultsManager.shared.isFirstAccessContacts {
                        UserDefaultsManager.shared.isFirstAccessContacts = false
                        observable.onNext(false)
                    } else {
                        observable.onError(error!)
                    }
                }
            })
            
            return Disposables.create()
        }
    }
    
}
