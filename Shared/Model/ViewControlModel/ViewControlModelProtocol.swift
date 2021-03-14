//
//  ViewControlModelProtocol.swift
//  MessageApp
//
//  Created by jinho on 2021/03/13.
//

import Foundation

protocol ViewControlModelProtocol { }

struct MessageViewControlModel: ViewControlModelProtocol {
    public enum Align {
        case right
        case left
    }
    
    let isContinuous: Bool
    let align: Align
}
