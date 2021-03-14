//
//  ChatEntryViewProtocol.swift
//  MessageApp
//
//  Created by jinho on 2021/03/13.
//

import SwiftUI

protocol ChatEntryViewProtocol {
    var entry: ChatEntryModel { get }
    var viewControlModel: ViewControlModelProtocol? { get }
    
    var typeErasuredView: AnyView { get }
    
    init(entry: ChatEntryModel, viewControlModel: ViewControlModelProtocol?)
}
