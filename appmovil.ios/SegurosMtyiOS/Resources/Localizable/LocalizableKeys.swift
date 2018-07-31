//
//  LocalizableKeys.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/5/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

struct LocalizableKeys {
    struct General {
        struct AlertOptions {
            static let accept = "general.alertOptions.accept".localized
            static let configuration = "general.alertOptions.configuration".localized
            static let cancel = "general.alertOptions.cancel".localized
            static let resetPassword = "general.alertOptions.resetPassword".localized
            static let generatePassword = "general.alertOptions.generatePassword".localized
            static let activateAccount = "general.alertOptions.activateAccount".localized
            static let login = "general.alertOptions.login".localized
            static let logout = "general.alertOptions.logout".localized
            static let reintentar = "general.alertOptions.reintentar".localized
            static let error = "general.alertOptions.error".localized
        }
        static let noInternet = "general.noInternet".localized
        static let serviceError = "general.serviceError".localized
        static let expiredSession = "general.expiredSession".localized
        static let noLocationServices = "general.noLocationServices".localized
        static let openSettingsContacts = "general.openSettingsContacts".localized
        static let openSettingsCameraAndGaleryPhotos = "general.openSettingsCameraAndGaleryPhotos".localized
        static let version = "general.version".localized
        static let noInformation = "general.noInformation".localized
    }
    
    struct Login {
        static let welcomeUsername = "login.welcomeUsername".localized
        static let invalidNumber = "login.invalidNumber".localized
        static let emptyNumber = "login.emptyNumber".localized
        static let invalidPassword = "login.invalidPassword".localized
        static let emptyPassword = "login.emptyPassword".localized
        static let invalidLoginPassword = "login.invalidLoginPassword".localized
        static let needsResetPassword = "login.needsResetPassword".localized
        static let alreadyLoggedIn = "login.alreadyLoggedIn".localized
        static let deviceAssociatingError = "login.deviceAssociationError".localized
        static let deactivatedAccount = "login.deactivatedAccount".localized
        static let inactiveAccount = "login.inactiveAccount".localized
        static let bannedAccount = "login.bannedAccount".localized
        static let expiredSession = "login.expiredSession".localized
    }
    
    struct RecoverPassword {
        static let invalidPhoneNumber = "recoverPassword.invalidPhoneNumber".localized
        static let sentSMS = "recoverPassword.sentSMS".localized
        static let invalidCode = "recoverPassword.invalidCode".localized
        static let emptyCode = "recoverPassword.emptyCode".localized
        static let descriptionSMS = "recoverPassword.sendSMS".localized
    }
    
    struct VerifyCode {
        static let success = "verifyCode.success".localized
        static let invalidPhoneNumberOrCode = "verifyCode.invalidPhoneNumberOrCode".localized
        static let errorWithData = "verifyCode.errorWithData".localized
    }
    
    struct RenewPassword {
        static let success = "renewPassword.assignedPassword".localized
        static let notSamePasswords = "renewPassword.notSamePassword".localized
    }
    
    struct Directory {
        struct Map {
            static let noLocations = "directory.map.noLocations".localized
            static let noInternet = "directory.map.noInternet".localized
            static let noSearchResults = "directory.map.noSearchResults".localized
            static let noFavoritesResults = "directory.map.noFavoritesResults".localized
            static let genericError = "directory.map.genericError".localized
            static let benefitsError = "directory.benefits.error".localized
            static let noNavigationAppsError = "directory.map.noNavigationAppsError".localized
        }
        struct List {
            static let noLocations = "directory.list.noLocations".localized
            static let noInternet = "directory.list.noInternet".localized
            static let noSearchResults = "directory.list.noSearchResults".localized
            static let noFavoritesResults = "directory.list.noFavoritesResults".localized
            static let genericError = "directory.list.genericError".localized
        }
    }
    
    struct Loader {
        static let getStates = "loader.getFiltersStates".localized
        static let getSpecialities = "loader.getFiltersSpecialities".localized
        static let getLocations = "loader.getLocations".localized
        static let checkCode = "loader.checkCode".localized
        static let renewPassword = "loader.renewPassword".localized
        static let login = "loader.login".localized
        static let logout = "loader.logout".localized
        static let editProfile = "loader.editProfile".localized
        static let addEmergencyContact = "loader.addEmergencyContact".localized
        static let editEmergencyContact = "loader.editEmergencyContact".localized
        static let deleteEmergencyContact = "loader.deleteEmergencyContact".localized
        static let requestTechnicalAssistance = "loader.requestTechnicalAssistance".localized
        static let changePassword = "loader.changePassword".localized
        static let detailLocation = "loader.detailLocation".localized
        static let addManualEmergencyContact = "loader.addManualEmergencyContact".localized
        static let getInfoPolicy = "loader.getInfoPolicy".localized
        static let registerUser = "loader.registerUser".localized
        static let setLocationFavorite = "loader.setLocationFavorite".localized
        static let setPrincipalPolicy = "loader.setPrincipalPolicy".localized
        static let addPolicy = "loader.addPolicy".localized
        static let searchInsured = "loader.searchInsured".localized
    }
    
    struct Profile {
        static let noPolicies = "profile.noPolicies".localized

        struct EditProfile {
            static let successEdit = "profile.editProfile.successEdit".localized
            static let emailValid = "profile.editProfile.emailValid".localized
            static let nameValid = "profile.editProfile.nameValid".localized
            static let phoneValid = "profile.editProfile.phoneValid".localized
            static let errorEmailEmpty = "profile.editProfile.error.emailEmpty".localized
            static let errorPhoneEmpty = "profile.editProfile.error.phoneEmpty".localized
            static let errorEmailInvalid = "profile.editProfile.error.emailInvalid".localized
            static let errorNameInvalid = "profile.editProfile.error.nameInvalid".localized
            static let errorPhoneInvalid = "profile.editProfile.error.phoneInvalid".localized
            static let errorNoInternet = "profile.editProfile.error.noInternet".localized
            static let errorGeneric = "profile.editProfile.error.generic".localized
            static let errorSessionExpired = "profile.editProfile.error.sessionExpired".localized
        }
        
        struct EditPassword {
            static let errorTitle = "profile.editPassword.error.generic.errorTitle".localized
            static let genericError = "profile.editPassword.error.generic".localized
            static let errorEmptyPassword = "profile.editPassword.error.emptyPassword".localized
            static let errorPassword = "profile.editPassword.error.passwordError".localized
            static let errorNoPassword = "profile.editPassword.error.noPasswordError".localized
            static let successfullEditPassword = "profile.editPassword.error.successfulEditPassword".localized
        }
        
        struct MyInsurancePolicies {
            static let collectiveForm = "profile.myInsurancePolicies.collectiveForm".localized
            static let individualForm = "profile.myInsurancePolicies.individualForm".localized
            static let expiredPolicy = "profile.myInsurancePolicies.expiredPolicy".localized
            static let activePolicy = "profile.myInsurancePolicies.activePolicy".localized
            static let deductibleLabel = "profile.myInsurancePolicies.deductibleLabel".localized
            static let coassuranceLabel = "profile.myInsurancePolicies.coassuranceLabel".localized
            static let validityLabel = "profile.myInsurancePolicies.validityLabel".localized
            static let alfaMedicalCardLabel = "profile.myInsurancePolicies.alfaMedicalCardLabel".localized
            static let alfaMedicalInternationalCardLabel = "profile.myInsurancePolicies.alfaMedicalInternationalCardLabel".localized
            static let deductibleMoneySymbol = "profile.myInsurancePolicies.deductibleMoneySymbol".localized
        }
        
        struct PolicyDetail {
            static let deducible = "profile.policyDetail.deducible".localized
            static let nationalDeductible = "profile.policyDetail.nationalDeductible".localized
            static let internationalDeductible = "profile.policyDetail.internationalDeductible".localized
            static let coassurance = "profile.policyDetail.coassurance".localized
            static let nationalCoassurance = "profile.policyDetail.nationalCoassurance".localized
            static let internationalCoassurance = "profile.policyDetail.internationalCoassurance".localized
            static let topCoassurance = "profile.policyDetail.topCoassurance".localized
            static let coassuranceSum = "profile.policyDetail.coassuranceSum".localized
            static let currency =  "profile.policyDetail.currency".localized
            static let startDate = "profile.policyDetail.startDate".localized
            static let endDate = "profile.policyDetail.endDate".localized
            static let policyType = "profile.policyDetail.policyType".localized
            static let paymentFrecuency = "profile.policyDetail.paymentFrecuency".localized
            static let nextPayment = "profile.policyDetail.nextPayment".localized
            static let policyAntiquity = "profile.policyDetail.policyAntiquity".localized
            static let viewWallet = "profile.policyDetail.viewWallet".localized
            static let setAsPrincipal = "profile.policyDetail.setAsPrincipal".localized
            static let coveragesWebPage = "profile.policyDetail.coverages.webPage".localized
            
            static let shortStay = "profile.policyDetail.shortStay".localized
            static let hospitalization = "profile.policyDetail.hospitalization".localized
            static let medicalConsultation = "profile.policyDetail.medicalConsultation".localized
            static let outsideHospitalServices = "profile.policyDetail.outsideHospitalServices".localized
            static let coassuranced = "profile.policyDetail.coassuranced".localized
            static let showCertificate = "profile.policyDetail.collective.showCertificate".localized
            static let notGetInsured = "profile.policyDetail.error.notgetInsured".localized
            
        }
        
        
        struct AddPolicy {
            static let screenTitle = "profile.addPolicy.screenTitle".localized
            struct Error {
                static let emptyNewPolicy = "profile.addPolicy.error.emptyNewPolicy".localized
                static let emptyCertificate = "profile.addPolicy.error.emptyCertificate".localized
                static let notEnoughLenghtNewPolicy = "profile.addPolicy.error.notEnoughLenght".localized
                static let policyAlreadyCreated = "profile.addPolicy.error.policyAlreadyCreated".localized
                static let policyCodeError = "profile.addPolicy.error.policyCodeError".localized
                static let notValidPolicy = "profile.addPolicy.error.notValidPolicy".localized
            }
    
            struct Success {
                static let addingPolicy = "profile.addPolicy.success.addingaddingPolicy".localized
            }
        }
        
        struct About {
            
            static let aboutTitle = "profile.about.aboutTitle".localized
            static let supportEmail = "profile.about.supportEmail".localized
            
            struct Error {
                
                static let errorSendingEMailTitle = "profile.about.errorSendingEMailTitle".localized
                static let errorDescriptionSendingEMail = "profile.about.errorDescriptionSendingEMail".localized
                
            }
            
        }
        
        struct VerifyPolicy {
            
            struct Error {
                
                static let colectiveRequiresCertificateError = "profile.verifyPolicy.error.colectiveRequiresCertificateError".localized
                static let invalidPolicyError = "profile.verifyPolicy.error.invalidPolicyError".localized
                static let genericError = "profile.verifyPolicy.error.genericError".localized
                
            }
            
        }
        
        static let noAdvisor = "profile.noAdvisor".localized
        static let emptyPolicies = "profile.emptyPolicies".localized
        static let logout = "profile.logout".localized
    }
    
    struct EmergencyContacts {
        static let addSuccess = "emergencyContacts.addSuccess".localized
        static let editSuccess = "emergencyContacts.editSuccess".localized
        static let deleteSuccess = "emergencyContacts.deleteSuccess".localized
        static let addFailed = "emergencyContacts.addFailed".localized
        static let editFailed = "emergencyContacts.editFailed".localized
        static let deleteFailed = "emergencyContacts.deleteFailed".localized
        static let actionSheetDeleteTitle = "emergencyContacts.actionSheet.deleteTitle".localized
        static let errorNameEmpty = "emergencyContacts.error.nameEmpty".localized
        static let errorPhoneEmpty = "emergencyContacts.error.phoneEmpty".localized
        static let invalidPhoneNumber = "emergencyContacts.error.invalidPhone".localized
        static let notGetContactsFromDevice = "emergencyContacts.error.notGetContactsFromDevice".localized
        static let noDataContact = "emergencyContacts.error.noDataContact".localized
        static let noNameContact = "emergencyContacts.error.noNameContact".localized
        static let noPhoneContact = "emergencyContacts.error.noPhoneContact".localized
        static let noEmailContact = "emergencyContacts.error.noEmailContact".localized
    }
    
    struct Emergency {
        static let callok = "emergency.callOk".localized
        static let alertok = "emergency.alertOk".localized
    }
    
    struct Resources {
        static let noAuthorizedCameraAndPhotos = "resources.noAuthorizedCameraAndPhotos".localized
    }
    
    struct Register {
        static let name = "register.name".localized
        static let firtsName = "register.firtsName".localized
        static let mail = "register.mail".localized
        static let phone = "register.phone".localized
        static let invalidData = "register.invalidData".localized
        static let loaderPolicy = "register.policyLoader".localized
        static let invalidPolicy = "register.invalidPolicy".localized
        static let invalidPolicyColective = "register.invalidPolicyColective".localized
        static let invalidPhone = "register.invalidPhone".localized
        static let serviceError = "register.serviceError".localized
        static let registerSuccess = "register.Success".localized
        static let registerWritePolicy = "register.WritePolicy".localized
        static let invalidIndividualPolicy = "register.invalidIndividualPolicy".localized
        static let invalidCertificate = "register.invalidCertificate".localized
        static let invalidMail = "register.invalidMail".localized
    }
}
