//
//  UIStoryboardExtension.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 04/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit
import Foundation



/**
    enum donde se definen los nombres de todos los segues de la aplicación para una fácil identificación y reutilización
 */

enum SeguesIdentifiers : String {
    case goTotutorialViewController = "goToTutorialViewController"
    case goToWelcomeViewController = "goToWelcomeViewController"
    case goToLoginViewController = "goToLoginViewController"
    case goToRegisterViewController = "goToRegisterViewController"
    case goToMenuViewController = "goToMenuViewController"
    case goToDirectoryViewController = "goToDirectoryViewController"
    case goToPerfilViewController = "goToPerfilViewController"
    case goToEmergencyViewController = "goToEmergencyViewController"
    case goToRecoverPasswordViewController = "goToRecoverPasswordViewController"
    case gotToCheckCode = "gotToCheckCode"
    case presentToDetailEmergencyContact = "presentToDetailEmergencyContact"
    case presentToEmbeddedProfileInformation = "presentToEmbeddedProfileInformation"
}

extension UIStoryboard {
    /**
        función que retorna el UIStoryboard de tutorial
     */
    class func tutorial() -> UIStoryboard {
        return UIStoryboard(name: "Tutorial", bundle: nil)
    }
    
    /**
     función que retorna el UIStoryboard de welcome
     */
    class func welcome() -> UIStoryboard {
        return UIStoryboard(name: "Welcome", bundle: nil)
    }
    
    /**
     función que retorna el UIStoryboard de bienvenida del menú
     */
    class func welcomeMenu() -> UIStoryboard {
        return UIStoryboard(name: "WelcomeMenu", bundle: nil)
    }
    
    /**
     función que retorna el UIStoryboard de login
     */
    class func login() -> UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
    
    /**
     función que retorna el UIStoryboard de register
     */
    class func register() -> UIStoryboard {
        return UIStoryboard(name: "Register", bundle: nil)
    }
    
    /**
     función que retorna el UIStoryboard de menu
     */
    class func menu() -> UIStoryboard {
        return UIStoryboard(name: "Menu", bundle: nil)
    }
    
    /**
     función que retorna el UIStoryboard de directory
     */
    class func directory() -> UIStoryboard {
        return UIStoryboard(name: "Directory", bundle: nil)
    }
    
    /**
     función que retorna el UIStoryboard de perfil
     */
    class func perfil() -> UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: nil)
    }
    
    /**
     función que retorna el UIStoryboard de emergency
     */
    class func emergency() -> UIStoryboard {
        return UIStoryboard(name: "Emergency", bundle: nil)
    }
    
    /**
     función que retorna el UIStoryboard de emergency
     */
    class func recoverPassword() -> UIStoryboard {
        return UIStoryboard(name: "RecoverPassword", bundle: nil)
    }
    
    class func directoryFilter() -> UIStoryboard {
        return UIStoryboard(name: "FiltersViewController", bundle: nil)
    }
    
    class func editProfile() -> UIStoryboard {
        return UIStoryboard(name: "EditProfile", bundle: nil)
    }
    
    class func policyDetail() -> UIStoryboard {
        return UIStoryboard(name: "PolicyDetail", bundle: nil)
    }
    
    class func editPassword() -> UIStoryboard {
        return UIStoryboard(name: "EditPassword", bundle: nil)
    }
    
    class func emergencyContacts() -> UIStoryboard {
        return UIStoryboard(name: "EmergencyContacts", bundle: nil)
    }
    
    class func registerCheck() -> UIStoryboard {
        return UIStoryboard(name: "CheckPolicyRegister", bundle: nil)
    }
    
    /**
     función que coloca al storyboard de tutorial como root
     */
    static func loadTutorial() {
        let iphoneStoryboard = UIStoryboard.tutorial()
        let navViewController = iphoneStoryboard.instantiateInitialViewController() as! TutorialViewController
        
        AppDelegate.sharedInstance().window?.rootViewController = navViewController
        AppDelegate.sharedInstance().window?.makeKeyAndVisible()
        
        UIView.transition(with: AppDelegate.sharedInstance().window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    /**
     función que coloca al storyboard de bienvenida como root
     */
    static func loadWelcome() {
        let iphoneStoryboard = UIStoryboard.welcome()
        let navViewController = iphoneStoryboard.instantiateInitialViewController() as! UINavigationController
        
        AppDelegate.sharedInstance().window?.rootViewController = navViewController
        AppDelegate.sharedInstance().window?.makeKeyAndVisible()
        
        UIView.transition(with: AppDelegate.sharedInstance().window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    /**
     función que coloca al storyboard del menu como root
     */
    static func loadMenu() {
        let iphoneStoryboard = UIStoryboard.menu()
        let navViewController = iphoneStoryboard.instantiateInitialViewController() as! MenuViewController
        
        AppDelegate.sharedInstance().window?.rootViewController = navViewController
        AppDelegate.sharedInstance().window?.makeKeyAndVisible()
        
        UIView.transition(with: AppDelegate.sharedInstance().window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
    }
}
