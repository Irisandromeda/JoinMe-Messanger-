//
//  MessangerMessage.swift
//  JoinMe
//
//  Created by Irisandromeda on 21.10.2022.
//

import UIKit
import FirebaseFirestore
import MessageKit

    //MARK: Message Model

struct MessangerMessage: Hashable, MessageType, Comparable {
    var sender: MessageKit.SenderType
    let content: String
    var sentDate: Date
    let id: String?
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKit.MessageKind {
        return .text(content)
    }
    
    init(user: MessangerUser, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
        id = nil
    }
    
    var dictionary: [String: Any] {
        let key: [String: Any] = [
            "content": content,
            "senderId": sender.senderId,
            "senderUsername": sender.displayName,
            "created": sentDate,
        ]
        
        return key
    }
    
    init?(queryDocument: QueryDocumentSnapshot) {
        let data = queryDocument.data()
        guard let content = data["content"] as? String,
        let senderId = data["senderId"] as? String,
        let senderUsername = data["senderUsername"] as? String,
        let date = data["created"] as? Timestamp else { return nil }
        
        self.content = content
        self.sender = Sender(senderId: senderId, displayName: senderUsername)
        self.sentDate = date.dateValue()
        self.id = queryDocument.documentID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MessangerMessage, rhs: MessangerMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    static func < (lhs: MessangerMessage, rhs: MessangerMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
