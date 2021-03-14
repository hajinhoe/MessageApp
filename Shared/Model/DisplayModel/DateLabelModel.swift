//
//  DateLabelModel.swift
//  MessageApp
//
//  Created by jinho on 2021/03/11.
//

import Foundation

struct DateLabelModel: DisplayContentModelProtocol {
    let date: Date
}

extension DateLabelModel {
    var text: String {
        let date = Calendar.current.dateComponents([.month, .day], from: self.date)

        if let month = date.month, let day = date.day {
            return "\(month)월 \(day)일"
        }

        return "unavailable"
    }
}
