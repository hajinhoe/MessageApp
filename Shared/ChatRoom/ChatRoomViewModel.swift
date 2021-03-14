//
//  ChatRoomViewModel.swift
//  MessageApp
//
//  Created by jinho on 2021/03/13.
//

import Foundation
import Combine
import Starscream

class ViewModel: ObservableObject {
    @Published var contents: [ChatEntryModel] = []
    @Published var keyboardHeight: CGFloat = 0
    var socket: WebSocket?
    
    var isHandshaked = false

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        var request = URLRequest(url: URL(string: "http://localhost:8080/myHandler")!)
        request.timeoutInterval = 5
        let socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
        self.socket = socket
        
        socket.write(string: "hello")
    }

    func receiveMessage() {

    }

    func sendMessage(message: TextChatModel) {
        

        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        let jsonData = try? jsonEncoder.encode(message)
        

        if let jsonData = jsonData {
            socket?.write(data: jsonData)
        }
        
        if contents.isEmpty {
            let chatEntryModel = ChatEntryModel(displayContent: DateLabelModel(date: message.date))
            contents.append(chatEntryModel)
        }

        if let lastMessage = contents.last, let chatContent = lastMessage.chatContentModel
           {
            let lastDate = Calendar.current.dateComponents([.day, .month, .year], from: chatContent.date)
            let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: chatContent.date)

            if lastDate != currentDate {
                let chatEntryModel = ChatEntryModel(displayContent: DateLabelModel(date: message.date))
                contents.append(chatEntryModel)
            }
        }

        let chatEntryModel = ChatEntryModel(chatContent: message)
        contents.append(chatEntryModel)
    }

    func messageContentDisplayData(at index: Int) -> ViewControlModelProtocol {
        
        var isContinuous = false
        var align: MessageViewControlModel.Align = .left

        if contents.count > index && index - 1 >= 0, let last = contents[index - 1].chatContentModel as? TextChatModel, let now = contents[index].chatContentModel as? TextChatModel {
            if last.name == now.name {
                isContinuous = true
            }
        }
        
        if let chatModel = contents[index].chatContentModel as? TextChatModel,
           chatModel.name == UserSettings.shared.name {
            align = .right
        }
        
        let data = MessageViewControlModel(isContinuous: isContinuous, align: align)

        return data
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
        }
    }
}

extension ViewModel: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        
        switch event {
        case .connected(let headers):
            let handshakeRequest = HandshakeRequest(name: UserSettings.shared.name)
            let jsonEncoder = JSONEncoder()
            
            if let jsonData = try? jsonEncoder.encode(handshakeRequest) {
                client.write(data: jsonData)
            }
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            if !isHandshaked {
                let jsonDecoder = JSONDecoder()
                
                if let respond = try? jsonDecoder.decode(HandshakeRespond.self, from: data) {
                    print(respond)
                }
                
                isHandshaked = true
                
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            
            guard let message = try? jsonDecoder.decode(TextChatModel.self, from: data) else {
                print("실패")
                return
                
            }
            
            if contents.isEmpty {
                let chatEntryModel = ChatEntryModel(displayContent: DateLabelModel(date: message.date))
                contents.append(chatEntryModel)
            }

            if let lastMessage = contents.last, let chatContent = lastMessage.chatContentModel
               {
                let lastDate = Calendar.current.dateComponents([.day, .month, .year], from: chatContent.date)
                let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: chatContent.date)

                if lastDate != currentDate {
                    let chatEntryModel = ChatEntryModel(displayContent: DateLabelModel(date: message.date))
                    contents.append(chatEntryModel)
                }
            }

            let chatEntryModel = ChatEntryModel(chatContent: message)
            contents.append(chatEntryModel)
                    case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            break
        case .error(let error):
            break
        }
    }
}
