//
//  IAFormField.swift
//  SegurosMtyiOS
//
//  Created by Rafael Jimeno Osornio on 12/6/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

enum FieldType: Int {
    case text = 0
    case picker
}

@objc protocol FormFieldDelegate {
    @objc optional func formFieldDidFinishEditing(formField: IAFormField)
    @objc optional func formFieldDidChange(formField: IAFormField)
}

class IAFormField: UIView {
    
    var delegate: FormFieldDelegate?
    var fieldType: FieldType = .text
    
    private var txtField: UITextField?
    private var lblName: UILabel?
    private var imgView: UIImageView?
    private var addedText = false
    private var line: UIView?
    private var pickerView: IAPickerView?
    
    var placeHolder: String = "" {
        willSet {
            self.lblName?.text = newValue
        }
    }
    
    var text: String? {
        get {
            return txtField?.text
        }
        set {
            txtField?.text = newValue
            textAdded()
        }
    }
    
    var isEnable: Bool = true {
        willSet {
            txtField?.isEnabled = newValue
        }
    }
    
    var pickerArrowImage: UIImage? {
        didSet {
            imgView?.image = pickerArrowImage
        }
    }
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        config()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateFrames()
    }
    
    //MARK: Public
    func looseFirstResponder() {
        txtField?.resignFirstResponder()
    }
    
    func makeUnactive() {
        txtField?.textColor = UIColor.darkGray
        
        UIView.animate(withDuration: 0.2) {
            self.lblName?.frame = CGRect(x: 0, y: self.txtField!.frame.origin.y + 10, width: self.frame.size.width, height: 20)
            self.lblName?.font = UIFont.systemFont(ofSize: 17)
            
        }
    }
    
    //MARK: Private
    @objc fileprivate func makeActive() {
        line?.backgroundColor = UIColor.black
        txtField?.textColor = UIColor.darkGray
        lblName?.textColor = UIColor(white: 0.45, alpha: 1)
        
        UIView.animate(withDuration: 0.4) {
            self.lblName?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 20)
            self.lblName?.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    private func textAdded() {
        addedText = true
        UIView.animate(withDuration: 0.4) {
            self.lblName?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 20)
            self.lblName?.font = UIFont.systemFont(ofSize: 13)
        }
    }
    
    func updateFrames() {
        txtField?.frame = CGRect(x: 0, y: frame.size.height - 40, width: frame.size.width, height: 40)
        lblName?.frame = CGRect(x: 0, y: frame.size.height - 30, width: frame.size.width, height: 20)
        line?.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1)
        
        if addedText {
            textAdded()
            addedText = false
        }
    }
    
    private func config() {
        backgroundColor = UIColor.clear
        clipsToBounds = true
        
        txtField = UITextField(frame: CGRect(x: 0, y: frame.size.height - 40, width: frame.size.width, height: 40))
        txtField?.borderStyle = .none
        txtField?.delegate = self
        txtField?.tintColor = UIColor.lightGray
        txtField?.font = UIFont.systemFont(ofSize: 16)
        addSubview(txtField!)
        
        lblName = UILabel(frame: CGRect(x: 0, y: frame.size.height - 30, width: frame.size.width, height: 20))
        lblName?.textColor = UIColor.darkGray
        lblName?.font = UIFont.systemFont(ofSize: 16)
        addSubview(lblName!)
        
        line = UIView(frame: CGRect(x: 0, y: frame.size.height - 3, width: frame.size.width, height: 1))
        line?.backgroundColor = UIColor.black
        addSubview(line!)
        
        imgView = UIImageView(frame: CGRect(x: frame.width - 30, y: (frame.height - 10) / 2, width: 10, height: 10))
        addSubview(imgView!)
        
    }
    
    private func showPicker(type: PickerType) {
        pickerView = IAPickerView()
        pickerView?.pickerType = type
        pickerView?.dateFormat = "dd / MM / yyyy"
        
        pickerView?.showDateWith(completion: { (date, dateString) in
            if let fieldDate = dateString {
                self.txtField?.text = fieldDate
                self.text = fieldDate
            }
        })
    }
}

//MARK: Field
extension IAFormField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        makeActive()
        
        if fieldType == .picker {
            return false
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text!.count == 0 {
            makeUnactive()
            
        } else {
            line?.backgroundColor = UIColor(white: 0.8, alpha: 1)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        self.text = str
        delegate?.formFieldDidChange?(formField: self)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.formFieldDidFinishEditing?(formField: self)
    }
}
