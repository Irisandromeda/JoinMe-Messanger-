//
//  MessangerChat.swift
//  JoinMe
//
//  Created by Irisandromeda on 26.09.2022.
//

import UIKit
import FirebaseFirestore

struct MessangerChat: Hashable, Decodable {
    var friendUsername: String
    var friendImageURL: String
    var lastMessage: String
    var friendId: String
    
    init(friendUsername: String, friendImageURL: String, lastMessage: String, friendId: String) {
        self.friendUsername = friendUsername
        self.friendImageURL = friendImageURL
        self.lastMessage = lastMessage
        self.friendId = friendId
    }
    
    var dictionary: [String: Any] {
        var key = ["friendUsername": friendUsername]
        key["friendImageURL"] = friendImageURL
        key["lastMessage"] = lastMessage
        key["friendId"] = friendId
        
        return key
    }
    
    init?(queryDocument: QueryDocumentSnapshot) {
        let data = queryDocument.data()
        guard let friendUsername = data["friendUsername"] as? String,
        let friendImageURL = data["friendImageURL"] as? String,
        let lastMessage = data["lastMessage"] as? String,
        let friendId = data["friendId"] as? String else { return nil }
        
        self.friendUsername = friendUsername
        self.friendImageURL = friendImageURL
        self.lastMessage = lastMessage 
        self.friendId = friendId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }

    static func == (lhs: MessangerChat, rhs: MessangerChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
