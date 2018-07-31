//
//  DataExtension.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 11/29/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    func deserialize<T:Codable>() throws -> T {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: self)
        } catch {
            throw error
        }
    }
    
    func toString() -> String{
        guard let string = String(data: self, encoding: String.Encoding.utf8)
            else { return "" }
        return string
    }

    func toImage() -> UIImage? {
       return UIImage(data: self)
    }
}
