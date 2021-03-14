//
//  MessageView.swift
//  MessageApp
//
//  Created by jinho on 2021/03/11.
//

import SwiftUI

extension MessageView {
    var typeErasuredView: AnyView {
        return AnyView(self)
    }
    
    var castedModel: TextChatModel? {
        return entry.chatContentModel as? TextChatModel
    }
    var castedViewControlModel: MessageViewControlModel {
        return (viewControlModel as? MessageViewControlModel) ?? Self.defaultViewControlModel
    }
    
    static var defaultViewControlModel = MessageViewControlModel(isContinuous: false, align: .left)
}

struct MessageView: View, ChatEntryViewProtocol {
    var entry: ChatEntryModel
    var viewControlModel: ViewControlModelProtocol?

    var body: some View {
        switch castedViewControlModel.align {
        case .left:
            leftAlignView()
        case .right:
            rightAlignView()
        }
    }
    
    func leftAlignView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                if !castedViewControlModel.isContinuous {
                    nameText(castedModel?.name ?? "")
                }
                HStack(alignment: .bottom) {
                    MessageBoxView {
                        Text(castedModel?.text ?? "")
                    }
                        .messageBoxBackgroundColor(Color.blue)
                    dateText(castedModel?.dateString ?? "")
                }
            }
            Spacer()
        }
    }
    
    func rightAlignView() -> some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                if !castedViewControlModel.isContinuous {
                    nameText(castedModel?.name ?? "")
                }
                HStack(alignment: .bottom) {
                    dateText(castedModel?.dateString ?? "")
                    MessageBoxView {
                        Text(castedModel?.text ?? "")
                    }
                        .messageBoxBackgroundColor(Color.green)
                }
            }
        }
    }
}

extension MessageView {
    func nameText(_ text: String) -> some View {
        VStack {
            Text(text)
                .font(.system(size: 16))
            Spacer()
                .frame(height: 2)
        }
    }
    
    func dateText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12))
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageView(entry: ChatEntryModel(chatContent: TextChatModel(text: "Hello",
                                                                         name: "John",
                                                                         date: Date())),
                        viewControlModel: MessageViewControlModel(isContinuous: false,
                                                                  align: .left))
            MessageView(entry: ChatEntryModel(chatContent: TextChatModel(text: "Hello",
                                                                         name: "John",
                                                                         date: Date())),
                        viewControlModel: MessageViewControlModel(isContinuous: false,
                                                                  align: .right))
        }
    }
}
