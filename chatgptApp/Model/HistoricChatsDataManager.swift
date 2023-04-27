//
//  HistoryChatsDataManager.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/4/17.
//

import Foundation

protocol HistoricChatsDataManager{
    func fetchConversationInfo()->Conversation
    func updateTitle(dial:Dialogue)->()
    func updateDialogue(dial:Dialogue)->()
    func removeDialogue(dial:Dialogue)->()
    func fetchDialog(uid:UUID) -> Dialogue?
}
