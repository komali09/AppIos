//
//  IAPickerView.swift
//  SegurosMtyiOS
//
//  Created by Rafael Jimeno Osornio on 12/6/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

typealias TextPickerCompletion = (_ itemSelected: String?, _ index: Int) -> ()
typealias DatePickerCompletion = (_ dateSelected: Date?, _ stringDate: String?) -> ()

enum PickerType: Int {
    case text = 0
    case date
}

class IAPickerView: UIView {
    
    var pickerType: PickerType = .text
    var dateFormat: String?
    var minDate: Date?
    var maxDate: Date?
    
    private var textCompletion: TextPickerCompletion?
    private var dateCompletion: DatePickerCompletion?
    private var datePicker: UIDatePicker?
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Private
    private func addButtons() {
        let btnCancel = UIButton(type: .custom)
        btnCancel.frame = CGRect(x: 20, y: 0, width: 100, height: 44)
        btnCancel.setTitle("Cancelar", for: .normal)
        btnCancel.setTitleColor(UIColor.darkGray, for: .normal)
        btnCancel.addTarget(self, action: #selector(IAPickerView.cancelPressed), for: .touchUpInside)
        addSubview(btnCancel)
        
        let btnOk = UIButton(type: .custom)
        btnOk.frame = CGRect(x: UIScreen.main.bounds.width - 117, y: 0, width: 100, height: 44)
        btnOk.setTitle("Aceptar", for: .normal)
        btnOk.setTitleColor(UIColor.darkGray, for: .normal)
        btnOk.addTarget(self, action: #selector(IAPickerView.okPressed), for: .touchUpInside)
        addSubview(btnOk)
    }
    
    @objc private func cancelPressed() {
        if pickerType == .text {
            textCompletion!(nil, 0)
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                var nFrame = self.frame
                nFrame.origin.y = UIScreen.main.bounds.height
                self.frame = nFrame
            }) { (finished) in
                self.dateCompletion!(nil, nil)
            }
        }
    }
    
    @objc private func okPressed() {
        if pickerType == .text {
            
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                var nFrame = self.frame
                nFrame.origin.y = UIScreen.main.bounds.height
                self.frame = nFrame
            }) { (finished) in
                self.dateCompletion!(self.datePicker!.date, self.datePicker!.date.localDate(format: self.dateFormat ?? "dd/MM/yyyy"))
            }
        }
    }
    
    private func show() {
        backgroundColor = UIColor.clear
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = bounds
        insertSubview(blurView, at: 0)
        
        let window = UIApplication.shared.delegate!.window!
        window?.addSubview(self)
        
        UIView.animate(withDuration: 0.4) {
            var nFrame = self.frame
            nFrame.origin.y = -200
            self.frame = nFrame
        }
    }
    
    //MARK: Public
    //Call this function to use date picker
    func showDateWith(completion: @escaping DatePickerCompletion) {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        self.frame = CGRect(x: 0, y: height, width: width, height: height)
        self.dateCompletion = completion
        self.addButtons()
        
        if pickerType == .date {
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: 44, width: DeviceDetector.ScreenSize.SCREEN_WIDTH, height: 156))
            datePicker?.minimumDate = minDate
            datePicker?.backgroundColor = UIColor.clear
            datePicker?.maximumDate = maxDate
            datePicker?.datePickerMode = .date
            
        }
        
        show()
    }
    
    //Call this function to use text picker
    func showWith(items: [String], completion: @escaping TextPickerCompletion) {
        
    }
}
