//
//  Extension + UIViewController.swift
//  Your Grade Book
//
//  Created by Julia on 08.10.2022.
//

import UIKit

extension UIViewController {
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okey", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func isWrongFormatOf(text: String) -> Bool {
        if text.isNumber {
            return false
        } else {
            return true
        }
    }
    
    func makeStringInTheFormOfDoubleFrom(text: String) -> String {
        let double = Double(text)
        var doubleString = ""
        
        if text == "" {
            return "1"
        }
        
        if text.count <= 3 {
            doubleString = String(format: "%.1f", double!)
        } else {
            doubleString = String(format: "%.2f", double!)
            if doubleString.last == "0" {
                doubleString.removeLast()
            }
        }
        
        return doubleString
    }
}
