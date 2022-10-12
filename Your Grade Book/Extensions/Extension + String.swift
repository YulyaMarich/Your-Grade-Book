//
//  Extension + String.swift
//  Your Grade Book
//
//  Created by Julia on 08.10.2022.
//

import Foundation

enum AlertText {
    case emptyTextField
    case wrongFormatOfMark
    case markIsHigherThanMaximum
    case wrongFormatOfCoefficient
    
    var title: String {
        switch self {
        case .emptyTextField:
            return "Text field is empty!"
        case .wrongFormatOfMark:
            return "Incorrect data format!"
        case .markIsHigherThanMaximum:
            return "Your mark is higher than the maximum!"
        case .wrongFormatOfCoefficient:
            return "Incorect coefficient format!"
        }
    }
    
    var message: String {
        switch self {
        case .emptyTextField:
            return "Please enter required data."
        case .wrongFormatOfMark:
            return "Please check your mark for extra characters."
        case .markIsHigherThanMaximum:
            return "Please change your mark or maximum mark."
        case .wrongFormatOfCoefficient:
            return "Please check your coefficient for extra characters."
        }
    }
}

extension String {
    var isNumber: Bool {
            let digitsCharacters = CharacterSet(charactersIn: "0123456789.")
            return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
        }
}
