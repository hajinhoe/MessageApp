//
//  ContentRouteView.swift
//  MessageApp
//
//  Created by jinho on 2021/03/11.
//

import SwiftUI

struct ContentRouteView: View {
    let entry: ChatEntryModel
    let viewControlModel: ViewControlModelProtocol?
    
    var body: some View {
        if let model = entry.chatContentModel,
           let type = ContentRouteViewRegistry.shared.get(identifier: model.identifier) {
            type.init(entry: entry, viewControlModel: viewControlModel).typeErasuredView
        } else if let model = entry.displayContentModel,
                  let type = ContentRouteViewRegistry.shared.get(identifier: model.identifier) {
            type.init(entry: entry, viewControlModel: viewControlModel).typeErasuredView
        } else {
            EmptyView()
        }
    }
}

class ContentRouteViewRegistry {
    static let shared = ContentRouteViewRegistry()
    
    var chatEntryViewDictionary: [String : ChatEntryViewProtocol.Type] = [:]
    
    init() {
        setup()
    }
    
    private func setup() {
        // chat content
        register(identifier: TextChatModel.identifier, view: MessageView.self)
        
        // displayContent
        register(identifier: DateLabelModel.identifier, view: DateLabelView.self)
    }
    
    private func register(identifier: String, view: ChatEntryViewProtocol.Type) {
        chatEntryViewDictionary[identifier] = view
    }
    
    func get(identifier: String) -> ChatEntryViewProtocol.Type? {
        return chatEntryViewDictionary[identifier]
    }
}
