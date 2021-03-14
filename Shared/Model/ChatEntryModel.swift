//
//  ChatEntryModel.swift
//  MessageApp
//
//  Created by jinho on 2021/03/11.
//

import Foundation

class ChatEntryModel {
    enum `Type` {
        case chat
        case display
    }
    
    private(set) var chatContentModel: ChatContentModelProtocol? = nil
    private(set) var displayContentModel: DisplayContentModelProtocol? = nil
        
    var type: Type? {
        if chatContentModel != nil {
            return .chat
        }
        
        if displayContentModel != nil {
            return .display
        }
        
        return nil
    }
    
    init(chatContent: ChatContentModelProtocol) {
        self.chatContentModel = chatContent
    }
    
    init(displayContent: DisplayContentModelProtocol) {
        self.displayContentModel = displayContent
    }
}
