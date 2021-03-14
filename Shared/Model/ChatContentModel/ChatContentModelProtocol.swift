//
//  ChatContentModelProtocol.swift
//  MessageApp
//
//  Created by jinho on 2021/03/11.
//

import Foundation

protocol ChatContentModelProtocol: IdentifierProtocol, Encodable, Decodable {
    var date: Date { get }
}
