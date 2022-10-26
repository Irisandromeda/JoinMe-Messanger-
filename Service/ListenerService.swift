//
//  ListenerService.swift
//  JoinMe
//
//  Created by Irisandromeda on 14.10.2022.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {

    static let shared = ListenerService()

    private let db = Firestore.firestore()

    private var usersReference: CollectionReference {
        return db.collection("users")
    }

    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }

    func usersOverWatch(users: [MessangerUser], completion: @escaping (Result<[MessangerUser], Error>) -> Void) -> ListenerRegistration? {
        var users = users
        let usersListener = usersReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { difference in
                guard let user = MessangerUser(document: difference.document) else { return }
                switch difference.type {
                case .added:
                    guard !users.contains(user) else { return }
                    guard user.id != self.currentUserId else { return }
                    users.append(user)
                case .modified:
                    guard let index = users.firstIndex(of: user) else { return }
                    users[index] = user
                case .removed:
                    guard let index = users.firstIndex(of: user) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }
    
    func waitingChatsOverWatch(chats: [MessangerChat], completion: @escaping (Result<[MessangerChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatReference = db.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
        
        let chatsListener = chatReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { difference in
                guard let chat = MessangerChat(queryDocument: difference.document) else { return }
                switch difference.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    guard chat.friendId != self.currentUserId else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    }
    
    func activeChatsOverWatch(chats: [MessangerChat], completion: @escaping (Result<[MessangerChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatReference = db.collection(["users", currentUserId, "activeChats"].joined(separator: "/"))
        
        let chatsListener = chatReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { difference in
                guard let chat = MessangerChat(queryDocument: difference.document) else { return }
                switch difference.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    guard chat.friendId != self.currentUserId else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    }
    
    func messagesOverWatch(chat: MessangerChat, completion: @escaping (Result<MessangerMessage, Error>) -> Void) -> ListenerRegistration? {
        let reference = usersReference.document(currentUserId).collection("activeChats").document(chat.friendId).collection("messages")
        let messageListener = reference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { difference in
                guard let message = MessangerMessage(queryDocument: difference.document) else { return }
                switch difference.type {
                case .added:
                    completion(.success(message))
                case .modified:
                    break // Редактирование сообщений
                case .removed:
                    break // Удаление сообщений
                }
            }
        }
        return messageListener
    }

}
 
