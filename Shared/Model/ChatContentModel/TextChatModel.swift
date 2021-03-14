//
//  TextChatModel.swift
//  MessageApp
//
//  Created by jinho on 2021/03/11.
//

import Foundation

struct TextChatModel: ChatContentModelProtocol {
    let text: String
    let name: String
    let date: Date
}

extension TextChatModel {
    var dateString: String {
        let date = Calendar.current.dateComponents([.hour, .minute, .day, .month], from: self.date)

        if let hour = date.hour, let minute = date.minute {
            if "\(minute)".count < 2 {
                return "\(hour):0\(minute)"
            }
            return "\(hour):\(minute)"
        }

        return "unavailable"
    }
}
