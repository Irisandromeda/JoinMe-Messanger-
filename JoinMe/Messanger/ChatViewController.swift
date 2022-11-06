//
//  ChatViewController.swift
//  JoinMe
//
//  Created by Irisandromeda on 24.10.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

final class ChatViewController: MessagesViewController {
    
    private var messagesListener: ListenerRegistration?
    
    private var messages = [MessangerMessage]()
    
    private let user: MessangerUser
    private let chat: MessangerChat
    
    init(user: MessangerUser, chat: MessangerChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        
        self.title = chat.friendUsername
    }
    
    deinit {
        messagesListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.backgroundColor = .mercury()
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        messagesListener = ListenerService.shared.messagesOverWatch(chat: chat, completion: { result in
            switch result {
            case .success(let message):
                self.appendMessages(message: message)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    private func appendMessages(message: MessangerMessage) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        messagesCollectionView.reloadData()
        
        let lastMessage = messages.firstIndex(of: message) == (messages.count - 1)
        
        let scrollToBottom = lastMessage && messagesCollectionView.bottom
        
        messagesCollectionView.reloadData()
        
        if scrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: user.id, displayName: user.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return 1
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .systemPink
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
    
}

extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 5)
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        return .zero
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MessangerMessage(user: user, content: text)
        FireStoreService.shared.sendMessage(chat: chat, message: message) { result in
            switch result {
            case .success:
                self.messagesCollectionView.scrollToLastItem(animated: true)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
    }
}

    // MARK: Automaticaly scroll to bottom in chat

extension UIScrollView {
    
    var bottom: Bool {
        return contentOffset.y >= verticalOffsetBottom
    }
    
    var verticalOffsetBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
}
