//
//  Validators.swift
//  JoinMe
//
//  Created by Irisandromeda on 05.10.2022.
//

import Foundation

class Validators {
    
    static func isFilled(username: String?, description: String?, gender: String?) -> Bool {
        guard let description = description,
        let gender = gender,
        let username = username,
        description != "",
        gender != "",
            username != "" else {
                return false
        }
        return true
    }
    
}
