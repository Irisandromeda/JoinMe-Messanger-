//
//  MessangerUser.swift
//  JoinMe
//
//  Created by Irisandromeda on 26.09.2022.
//

import UIKit
import FirebaseFirestore

struct MessangerUser: Hashable, Decodable {
    var id: String
    var email: String
    var avatarURL: String
    var username: String
    var description: String
    var gender: String
    
    init(id: String, email: String, avatarURL: String, username: String, description: String, gender: String) {
        self.id = id
        self.email = email
        self.avatarURL = avatarURL
        self.username = username
        self.description = description
        self.gender = gender
    }

    var dictionary: [String: Any] {
        var key = ["id": id]
        key["email"] = email
        key["userImageURL"] = avatarURL
        key["username"] = username
        key["description"] = description
        key["gender"] = gender

        return key
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let id = data["id"] as? String,
        let email = data["email"] as? String,
        let avatarURL = data["userImageURL"] as? String,
        let username = data["username"] as? String,
        let description = data["description"] as? String,
        let gender = data["gender"] as? String else { return nil }

        self.id = id
        self.email = email
        self.avatarURL = avatarURL
        self.username = username
        self.description = description
        self.gender = gender
    }
    
    init?(queryDocument: QueryDocumentSnapshot) {
        let data = queryDocument.data()
        guard let id = data["id"] as? String,
        let email = data["data"] as? String,
        let avatarURL = data["userImageURL"] as? String,
        let username = data["username"] as? String,
        let description = data["description"] as? String,
        let gender = data["gender"] as? String else { return nil }

        self.id = id
        self.email = email
        self.avatarURL = avatarURL
        self.username = username
        self.description = description
        self.gender = gender
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MessangerUser, rhs: MessangerUser) -> Bool {
        return lhs.id == rhs.id
    }
    
        // MARK: For Search
    
    func filtered(text: String?) -> Bool {
        guard let text = text else { return true }
        if text.isEmpty { return true }
        let lowercase = text.lowercased()
        return username.lowercased().contains(lowercase)
    }
}
