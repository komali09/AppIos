//
//  UIImageExtension.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/19/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func QRImage(from string: String, size:CGSize) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")
            guard let qrcodeImage = filter.outputImage else {return nil}
            let scaleX = size.width / qrcodeImage.extent.size.width
            let scaleY = size.height / qrcodeImage.extent.size.height
            let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            return   UIImage(ciImage: transformedImage)
        }
        return nil
    }
    
    static func barCode(from string:String, size:CGSize) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CICode128BarcodeGenerator"){
            filter.setValue(data, forKey: "inputMessage")
            guard let qrcodeImage = filter.outputImage else {return nil}
            let scaleX = size.width / qrcodeImage.extent.size.width
            let scaleY = size.height / qrcodeImage.extent.size.height
            let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            return UIImage(ciImage: transformedImage)
        }
        return nil
    }
    
    
    static func Pdf417(from string: String, size:CGSize) -> UIImage?  {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIPDF417BarcodeGenerator"){
            filter.setValue(data, forKey: "inputMessage")
            guard let qrcodeImage = filter.outputImage else {return nil}
            let scaleX = size.width / qrcodeImage.extent.size.width
            let scaleY = size.height / qrcodeImage.extent.size.height
            let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            return UIImage(ciImage: transformedImage)
        }
        return nil
    }

    func fixedOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        return UIImage(cgImage: ctx.makeImage()!)
    }
}
