//
//  UserErrors.swift
//  JoinMe
//
//  Created by Irisandromeda on 05.10.2022.
//

import Foundation

enum UserErrors {
    case notFilled
    case photoNotExist
}

extension UserErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .notFilled:
            return NSLocalizedString("Something was wrong", comment: "Fill in all the fields")
        case .photoNotExist:
            return NSLocalizedString("Something was wrong", comment: "User hasn't selected a photo")
        }
    }
}
