//
//  StringExtension.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/5/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func properString() -> String {
        let first = String(prefix(1)).uppercased()
        let other = String(dropFirst()).lowercased()
        return first + other
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func shortDateFormat() -> Date {
        let index = self.index(self.startIndex, offsetBy: 10)
        let dateString = String(self[..<index])
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return Date() }
        return date
    }
    
    func dateTimeFormat() -> Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS zzz"
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
    
    
    func dateFormatPicker() -> Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
    
    func decimalString() -> String {
        var string = self
        if self.contains("$") {
            string = self.replacingOccurrences(of: "$", with: "")
        }
        guard let number = Double(string) else { return self }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value:number)) else { return "\(number)" }
        
        return formattedNumber
    }
    
    func currencyString() -> String {
        var string = self
        if self.contains("$") {
            string = self.replacingOccurrences(of: "$", with: "")
        }
        guard let number = Double(string) else { return self }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value:number)) else { return "$\(number)" }
        
        return "$\(formattedNumber)"
    }
    
    func SMGMString() -> String {
        return "\(self.decimalString()) SMGM"
    }
    
    func percentageString() -> String {
        return "\(self)%"
    }
}
