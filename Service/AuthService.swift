//
//  AuthService.swift
//  JoinMe
//
//  Created by Irisandromeda on 11.09.2022.
//

import UIKit
import Firebase
import FirebaseAuth

    //MARK: FireBase Auth Service (User Auth)

class AuthService {
    
    static let service = AuthService()
    private let auth = Auth.auth()
    
    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
             
            completion(.success(result.user))
        }
    }
    
    func confirmEmail() {
        auth.currentUser?.sendEmailVerification(completion: { error in
            if error == nil {
                print("Error")
            }
        })
    }
    
}
