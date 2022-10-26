//
//  StorageService.swift
//  JoinMe
//
//  Created by Irisandromeda on 12.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService {
    
    static let shared = StorageService()
    
    let storageReference = Storage.storage().reference()
    
    private var avatarReference: StorageReference {
        return storageReference.child("avatars")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func uploadPhoto(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let modifiedPhoto = photo.jpegData(compressionQuality: 1) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarReference.child(currentUserId).putData(modifiedPhoto, metadata: metadata) { metadata , error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            self.avatarReference.child(self.currentUserId).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
        
    }
    
}
