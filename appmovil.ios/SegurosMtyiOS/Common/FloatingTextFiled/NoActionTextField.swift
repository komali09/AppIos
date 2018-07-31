//
//  NoActionTextField.swift
//  SegurosMtyiOS
//
//  Created by Israel Gutiérrez Castillo on 29/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

class NoActionTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        } else
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return false
        } else
        if action == #selector(UIResponderStandardEditActions.select(_:)) {
            return false
        } else
        if action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
            return false
        } else
        if action == #selector(UIResponderStandardEditActions.cut(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
        
    }
    
}
