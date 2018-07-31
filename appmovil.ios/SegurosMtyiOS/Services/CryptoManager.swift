//
//  CryptoManager.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 05/12/17.
//  Copyright © 2017 Erwin Jonnatan Perez Téllez. All rights reserved.
//

import Foundation
import SwiftyRSA
import CryptoSwift

/** 
 Clase que se encarga de encriptar y desencriptar los datos que se utilizan para la aplicación
 */

class CryptoManager {
    /** 
     Método para decodificar un string a Dara con base64
     */
    static func base64Decoded(stringToDecode: String) -> Data? {
        if let data = Data(base64Encoded: stringToDecode) {
            return data
        }
        return nil
    }
    
    /** 
     Método para cifrar con RSA cualquier string
     - Parameters:
     publicKey: llave publica para cifrar
     value: string a encriptar
     - Return:
     String: retorna el string ya cifrado
     */
    static func rsaString(publicKey: String, value: String) -> String? {
        do {
            let publicKeyRSA = try PublicKey(base64Encoded: publicKey)
            
            let clear = try ClearMessage(string: value, using: .utf8)
            let encrypted = try clear.encrypted(with: publicKeyRSA, padding: .PKCS1)
            return encrypted.base64String
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    static func generateTOTP(for string: String, timestamp: UInt64) -> String? {
        guard let data = string.data(using: .utf8) else { return nil }
        let secret = data.sha256().toHexString()
        
        debugPrint("🔒generateTOTP input:      \(string)")
        debugPrint("🔒generateTOTP timestamp:  \(timestamp)")
        debugPrint("🔒generateTOTP sha256:     \(secret)")
        
        let time = timestamp / 100000
        let code = generateTOTP(for: secret, timestamp: time, digits: 8, crypto: .sha512)
        
        debugPrint("🔒generateTOTP result:     \(code ?? "")")
        return code
    }
    
    private static func generateTOTP(for key: String, timestamp: UInt64, digits: Int, crypto: HMAC.Variant) -> String? {
        //Completes the counter to match a 16 char lenght if needed
        var time = "\(timestamp)"
        if time.count < 16 {
            let prefixedZeros = String(repeatElement("0", count: (16 - time.count)))
            time = prefixedZeros + time
        }
        
        //Gets the byte array for both, the key and message
        guard let msg = stringToBytes(time) else { return nil }
        guard let k = stringToBytes(key) else { return nil }
        
        //Performs a HMAC with the cypher selected
        let hash = try! HMAC(key: k, variant: crypto).authenticate(msg)
        
        //Get last 4 bits of hash as offset
        let offset = Int((hash.last ?? 0x00) & 0x0f)
        
        //Get 4 bytes from the hash from [offset] to [offset + 3]
        let truncatedHMAC = Array(hash[offset...offset + 3])
        
        //Convert byte array of the truncated hash to data
        let data =  Data(bytes: truncatedHMAC)
        
        //Convert data to UInt32
        var number = UInt32(strtoul(data.toHexString(), nil, 16))
        
        //Remove most significant bit
        number &= 0x7fffffff
        
        //Modulo number by 10^(digits)
        number = number % UInt32(pow(10, Float(digits)))
        
        //Convert int to string
        let strNum = String(number)
        if strNum.count == digits {
            return strNum
        } else {
            //Add zeros to start of string if not present
            let prefixedZeros = String(repeatElement("0", count: (digits - strNum.count)))
            return (prefixedZeros + strNum)
        }
    }
    
    static func stringToBytes(_ string: String) -> [UInt8]? {
        let length = string.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = string.startIndex
        for _ in 0..<length/2 {
            let nextIndex = string.index(index, offsetBy: 2)
            if let b = UInt8(string[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
}
