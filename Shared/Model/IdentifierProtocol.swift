//
//  IdentifierProtocol.swift
//  MessageApp
//
//  Created by jinho on 2021/03/13.
//

import Foundation

protocol IdentifierProtocol { }

extension IdentifierProtocol {
    var identifier: String {
        return Self.identifier
    }
    
    static var identifier: String {
        return String(describing: Self.self)
    }
}
