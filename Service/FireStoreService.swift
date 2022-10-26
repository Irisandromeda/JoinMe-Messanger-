//
//  FireStoreService.swift
//  JoinMe
//
//  Created by Irisandromeda on 05.10.2022.
//

import Firebase
import FirebaseCore
import FirebaseFirestore

class FireStoreService {

    static let shared = FireStoreService()

    let db = Firestore.firestore()

    private var userReference: CollectionReference {
        return db.collection("users")
    }
    
    private var waitingChatsReference: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatsReference: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    
    private var currentUser: MessangerUser!

    func saveUserInfo(id: String, email: String, userImage: UIImage?, username: String?, description: String?, gender: String?, completion: @escaping (Result<MessangerUser, Error>) -> Void) {

        guard Validators.isFilled(username: username, description: description, gender: gender) else {
            completion(.failure(UserErrors.notFilled))
            return
        }
        
        guard userImage != UIImage(named: "user_image") else {
            completion(.failure(UserErrors.photoNotExist))
            return
        }

        var messangerUser = MessangerUser(id: id,
                                          email: email,
                                          avatarURL: "url",
                                          username: username!,
                                          description: description!,
                                          gender: gender!)

        StorageService.shared.uploadPhoto(photo: userImage!) { result in
            switch result {
            case .success(let url):
                messangerUser.avatarURL = url.absoluteString
                self.userReference.document(messangerUser.id).setData(messangerUser.dictionary) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(messangerUser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserData(user: User, completion: @escaping (Result<MessangerUser, Error>) -> Void) {
        let documentReference = userReference.document(user.uid)
        documentReference.getDocument { document, error in
            if let document = document {
                guard let user = MessangerUser(document: document) else {
                    completion(.failure(error!))
                    return
                }
                self.currentUser = user
                completion(.success(user))
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func createWaitingChats(message: String, sender: MessangerUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = db.collection(["users", sender.id, "waitingChats"].joined(separator: "/"))
        let messageReference = reference.document(self.currentUser.id).collection("messages")

        let message = MessangerMessage(user: currentUser, content: message)

        let chat = MessangerChat(friendUsername: currentUser.username,
                        friendImageURL: currentUser.avatarURL,
                        lastMessage: message.content,
                        friendId: currentUser.id)

        reference.document(currentUser.id).setData(chat.dictionary) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageReference.addDocument(data: message.dictionary) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    func deleteWaitingChat(chat: MessangerChat, completion: @escaping (Result<Void, Error>) -> Void) {
        waitingChatsReference.document(chat.friendId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(Void()))
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    func deleteMessages(chat: MessangerChat, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = waitingChatsReference.document(chat.friendId).collection("messages")
        
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageReference = reference.document(documentId)
                    messageReference.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWaitingChatMessages(chat: MessangerChat, completion: @escaping (Result<[MessangerMessage], Error>) -> Void) {
        let reference = waitingChatsReference.document(chat.friendId).collection("messages")
        var messages = [MessangerMessage]()
        
        reference.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = MessangerMessage(queryDocument: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    func addToActive(chat: MessangerChat, completion: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { result in
                    switch result {
                    case .success:
                        self.createActiveChats(chat: chat, messages: messages) { result in
                            switch result {
                            case .success:
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createActiveChats(chat: MessangerChat, messages: [MessangerMessage], completion: @escaping (Result<Void, Error>) -> Void) {
        let messagesReference = activeChatsReference.document(chat.friendId).collection("messages")
        activeChatsReference.document(chat.friendId).setData(chat.dictionary) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            for message in messages {
                messagesReference.addDocument(data: message.dictionary) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    func sendMessage(chat: MessangerChat, message: MessangerMessage, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendReference = userReference.document(chat.friendId).collection("activeChats").document(currentUser.id)
        let friendMessageReference = friendReference.collection("messages")
        let selfReference = userReference.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
        
        let selfChat = MessangerChat(friendUsername: currentUser.username,
                                     friendImageURL: currentUser.avatarURL,
                                     lastMessage: message.content,
                                     friendId: currentUser.id)
        friendReference.setData(selfChat.dictionary) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessageReference.addDocument(data: message.dictionary) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                selfReference.addDocument(data: message.dictionary) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
}
