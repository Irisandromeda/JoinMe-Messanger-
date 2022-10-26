//
//  ChatNavigation.swift
//  JoinMe
//
//  Created by Irisandromeda on 22.10.2022.
//

import Foundation

protocol ChatNavigation: AnyObject {
    func removeWaitingChat(chat: MessangerChat)
    func addToActiveChat(chat: MessangerChat)
}
