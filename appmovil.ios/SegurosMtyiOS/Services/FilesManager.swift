//
//  FilesManager.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 10/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

/** 
 Clase que se encarga del manejo de archivos de la app
 */

class FilesManager {
    /** 
     Método para crear un directorio dentro de la carpeta de Documents en el dispositivo
     */
    static func createDirectoryInsideDocuments(name: String) -> Bool {
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = tDocumentDirectory.appendingPathComponent(name)
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                    debugPrint("Document directory is \(filePath)")
                    return true
                    
                } catch {
                    return false
                }
            } else {
                debugPrint("Document directory is \(filePath)")
                return true
            }
        } else  {
            return false
        }
    }
    
    /** 
     Método para guardar o reemplazar una imagen dentro de la carpeta documentos en el dispositivo
     */
    static func saveImageInDirectoryInsideDocuments(directory: String, name: String, image: UIImage) -> Bool {
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
             let filePath = tDocumentDirectory.appendingPathComponent("\(directory)/\(name)")
            
            if !fileManager.fileExists(atPath: filePath.path) {
                let imageData: Data = UIImagePNGRepresentation(image.fixedOrientation())!
                if fileManager.createFile(atPath: filePath.relativePath, contents: imageData, attributes: nil) {
                    return true
                } else {
                    return false
                }
            } else {
                do {
                    try fileManager.removeItem(at: filePath)
                    let imageData: Data = UIImagePNGRepresentation(image.fixedOrientation())!
                    if fileManager.createFile(atPath: filePath.relativePath, contents: imageData, attributes: nil) {
                        return true
                    } else {
                        return false
                    }
                } catch {
                    return false
                }
            }
        } else  {
            return false
        }
    }
    
    /** 
     Método para guardar o reemplazar una imagen dentro de un carpeta en el dispositivo alojado en Documents
     */
    static func saveImageInDocuments(name: String, image: UIImage) -> Bool {
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = tDocumentDirectory.appendingPathComponent(name)
            
            if !fileManager.fileExists(atPath: filePath.path) {
                let imageData: Data = UIImagePNGRepresentation(image.fixedOrientation())!
                if fileManager.createFile(atPath: filePath.relativePath, contents: imageData, attributes: nil) {
                    return true
                } else {
                    return false
                }
            } else {
                do {
                    try fileManager.removeItem(at: filePath)
                    let imageData: Data = UIImagePNGRepresentation(image.fixedOrientation())!
                    if fileManager.createFile(atPath: filePath.relativePath, contents: imageData, attributes: nil) {
                        return true
                    } else {
                        return false
                    }
                } catch {
                    return false
                }
            }
        } else  {
            return false
        }
    }
    
    /** 
     Método para obtener una imagen dentro de un carpeta en el dispositivo alojado en Documents
     */
    static func getImageInDirectoryInsideDocuments(directory: String, name: String) -> UIImage? {
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = tDocumentDirectory.appendingPathComponent("\(directory)/\(name)")
            
            if fileManager.fileExists(atPath: filePath.path) {
                return UIImage(contentsOfFile: filePath.relativePath)
            } else {
                return nil
            }
        } else  {
            return nil
        }
    }
    
    /** 
     Método para obtener una imagen dentro de la carpeta documentos en el dispositivo
     */
    static func getImageInDocuments(name: String) -> UIImage? {
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = tDocumentDirectory.appendingPathComponent(name)
            
            if fileManager.fileExists(atPath: filePath.path) {
                return UIImage(contentsOfFile: filePath.relativePath)
            } else {
                return nil
            }
        } else  {
            return nil
        }
    }
}
