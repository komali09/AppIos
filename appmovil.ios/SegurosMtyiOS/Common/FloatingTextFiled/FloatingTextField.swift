//
//  FloatingTextField.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 11/30/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

/**
 Estado de validacion actual del textfield
 */
enum TextFieldValidationState: Equatable {
    case valid(message:String)
    case invalid(message:String)
    case notValidated
}

func ==(lhs: TextFieldValidationState, rhs: TextFieldValidationState) -> Bool {
    switch (lhs, rhs) {
    case ( .valid(_), .valid(_)):
        return true
    case (.invalid(_), .invalid(_)):
        return true
    case (.notValidated, .notValidated):
        return true
    default:
        return false
    }
}


protocol FloatingTextFieldDelegate:class {
    func textFieldDidEndEditing(_ floatingTextField: FloatingTextField)
    func textFieldDidBeginEditing(_ floatingTextField: FloatingTextField)
    func textFieldShouldReturn(_ textField: FloatingTextField)
}

class FloatingTextField: IAUIView {
    @IBOutlet weak var inputText: NoActionTextField!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet private weak var footerText: UILabel!
    @IBOutlet private weak var showSecureTextButton: UIButton!
    @IBOutlet private weak var validationImage: UIImageView!
    @IBOutlet private weak var tooltipButton: UIButton!
    @IBOutlet private weak var tooltipView: UIView!
    @IBOutlet private weak var tooltipLabel: UILabel!
    
    @IBOutlet weak var bottomTextButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextConstraint: NSLayoutConstraint!
    
    /**
     tamaño máximo del input
     */
    @IBInspectable var maxLenght: Int = 0
    /**
     determina si habrá un contador que quitará de foco el control al terminar de escribir
     */
    @IBInspectable var ildeTimerEnabled: Bool = false
    /**
     Texto que se mostrara en el textfield
     */
    @IBInspectable var text: String {
        get {
            return self.inputText.text ?? ""
        }
        set {
            let color = self.inputText.textColor
            self.inputText.text = newValue
            self.setInputTextColor(color!)
            UIView.animate(withDuration: 0.3) {
                if newValue.count > 0 {
                    self.titleText.alpha = 1
                    self.titleText.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
                } else {
                    self.titleText.alpha = 0
                    self.titleText.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 5)
                }
            }
        }
    }
    /**
     Texto que se mostrara cuando no hay input en el text field
     */
    @IBInspectable var placeholder: String = "" {
        didSet{
            self.inputText.placeholder = self.placeholder
            self.titleText.text = self.placeholder
        }
    }
    /**
     Color del que se mostrara cuando no hay input en el text field
     */
    @IBInspectable var placeholderColor: UIColor = UIColor.smSlateGrey {
        didSet {
            self.inputText.attributedPlaceholder = NSAttributedString(string:self.inputText.placeholder ?? "", attributes:[NSAttributedStringKey.foregroundColor: self.placeholderColor])
        }
    }
    /**
     Tipo de teclado que se mostrará al usuario (utilizar valor equivalente a UIKeyboardType)
     */
    @IBInspectable var keyboardType: Int = 0 {
        didSet{
            if let type = UIKeyboardType(rawValue: keyboardType) {
                self.inputText.keyboardType = type
                
                if type.rawValue == 4 || type.rawValue == 7 { //Agregar toolbar a teclados númericos y alfanumericos
                    self.inputText.addDoneCancelToolbar()
                }
            }
        }
    }
    /**
     Mensaje ubicado en la parte inferior del input
     */
    @IBInspectable var footerMessage: String = "" {
        didSet{
            self.footerText.text = self.footerMessage
        }
    }
    /**
     Identifica si el input debera ser ocultado por seguridad
     */
    @IBInspectable var isSecureTextEntry: Bool = false {
        didSet{
            self.inputText.isSecureTextEntry = self.isSecureTextEntry
        }
    }
    /**
     Identifica si el botón de ayuda será mostrado o no
     */
    @IBInspectable var isTooltipHidden: Bool = true
    
    /**
     Texto que se muestra en el botón de ayuda
     */
    @IBInspectable var tooltipText: String = "" {
        didSet{
            self.tooltipLabel.text = self.tooltipText
        }
    }
    
    var isValidating:Bool = false {
        didSet {
            if isValidating {
                self.inputText.isEnabled = false
                self.validationImage.image = UIImage(named: "loaderBlue")
                self.validationImage.alpha = 1
                let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimation.fromValue = 0.0
                rotateAnimation.toValue = CGFloat(Float.pi * 2)
                rotateAnimation.duration = 1.0
                rotateAnimation.repeatCount = HUGE
                self.validationImage.layer.add(rotateAnimation, forKey: nil)
                
            } else {
                self.inputText.isEnabled = true
                self.validationImage.image = nil
                self.validationImage.alpha = 0
                self.validationImage.layer.removeAllAnimations()
                self.validationImage.transform = CGAffineTransform.identity.rotated(by: 0)
                
            }
        }
    }
    
    fileprivate var textFieldValidationState:TextFieldValidationState = .notValidated
    fileprivate var ildeTimer:Timer?
    /**
     delegado del recibidor
     */
    weak var delegate:FloatingTextFieldDelegate?
    
    // MARK: - inits
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleText.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 5)
    }
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        self.titleText.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 5)
    }
    
    @IBAction fileprivate func textChanged(_ sender: UITextField) {
        UIView.animate(withDuration: 0.3) {
            if let text = sender.text, text.count > 0 {
                if self.ildeTimerEnabled, text.count == self.maxLenght {
                    self.startTimer()
                } else {
                    self.stopTimer()
                }
                self.titleText.alpha = 1
                self.titleText.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
            } else {
                self.titleText.alpha = 0
                self.titleText.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 5)
                self.stopTimer()
            }
        }
        self.validate { .notValidated }
    }
    
    @IBAction fileprivate func toggleSecureInput(_ sender: UIButton) {
        let isSecureTextEntry = !self.inputText.isSecureTextEntry
        self.inputText.isSecureTextEntry = isSecureTextEntry
        self.showSecureTextButton.setTitle(isSecureTextEntry ? "Mostrar" : "Ocultar", for: .normal)
    }
    
    func validate(_ validationBlock:() -> TextFieldValidationState) {
        self.isValidating = false
        self.textFieldValidationState = validationBlock()
        self.hideTooltip()
        
        bottomTextConstraint.priority = self.isTooltipHidden ? .defaultHigh : .defaultLow
        bottomTextButtonConstraint.priority = self.isTooltipHidden ? .defaultLow : .defaultHigh
        
        switch self.textFieldValidationState {
        case .valid(let message):
            if self.isSecureTextEntry {
                self.validationImage.image = nil
            } else {
                self.validationImage.image = UIImage(named: "checkmark")
            }
            UIView.animate(withDuration: 0.3) {
                self.validationImage.alpha = 1
                self.separator.backgroundColor = UIColor.smBlue
            }
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.footerText.text = message
                self.footerText.textColor = UIColor.smSoftGrey
            }, completion: nil)
            
            self.tooltipButton.isHidden = true
            self.setInputTextColor(UIColor.smBlue)
            
        case .invalid(let message):
            UIView.animate(withDuration: 0.3) {
                self.validationImage.alpha = 0
                self.separator.backgroundColor = UIColor.smPinkish
            }
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.footerText.text = message
                self.footerText.textColor = UIColor.smPinkish
            }, completion: nil)
            
            self.tooltipButton.isHidden = self.isTooltipHidden
            self.setInputTextColor(UIColor.smPinkish)
            
        case .notValidated:
            UIView.animate(withDuration: 0.1) {
                self.validationImage.alpha = 0
                self.separator.backgroundColor = UIColor.smBlue
            }
            UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
                self.footerText.text = ""
                self.footerText.textColor = UIColor.smBlue
            }, completion: nil)
            
            self.tooltipButton.isHidden = true
            self.setInputTextColor(UIColor.smBlue)
        }
    }
    
    private func setInputTextColor(_ color:UIColor) {
        let attributedText = NSMutableAttributedString(attributedString: inputText.attributedText!)
        attributedText.setAttributes([NSAttributedStringKey.foregroundColor : color], range: NSMakeRange(0, attributedText.length))
        inputText.attributedText = attributedText
    }
    
    @IBAction private func tooltipPressed(_ sender: UIButton) {
        self.tooltipView.alpha = 1.0
        self.tooltipView.isHidden = !self.tooltipView.isHidden
    }
    
    func hideTooltip() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tooltipView.alpha = 0.0
        }) { (completed) in
            self.tooltipView.isHidden = true
        }
    }
    
    func focus() {
        self.inputText.becomeFirstResponder()
    }
}

extension FloatingTextField {
    fileprivate func startTimer(){
        self.ildeTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { [weak self] timer in
            self?.inputText.resignFirstResponder()
        })
    }
    
    fileprivate func stopTimer(){
        self.ildeTimer?.invalidate()
    }
}

extension FloatingTextField : UITextFieldDelegate {
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.textFieldValidationState == .notValidated {
            UIView.transition(with: self.inputText, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.inputText.textColor = UIColor.smBlue
            }, completion: nil)
            
            UIView.animate(withDuration: 0.3) {
                self.separator.backgroundColor = UIColor.smBlue
            }
        }
        
        self.showSecureTextButton.isHidden = !self.isSecureTextEntry
        self.tooltipView.isHidden = true
        self.delegate?.textFieldDidBeginEditing(self)
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        self.tooltipView.isHidden = true
        self.delegate?.textFieldDidEndEditing(self)
        self.stopTimer()
    }
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, self.maxLenght > 0
            else { return true }
        
        let newText = text + string
        return !(newText.count - range.length > self.maxLenght)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.delegate?.textFieldShouldReturn(self)
        return true
    }
}

extension FloatingTextField {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        if touch?.view != self.tooltipView {
            self.hideTooltip()
        }
    }
}
