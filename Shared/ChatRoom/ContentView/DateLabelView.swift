//
//  dateLabelView.swift
//  MessageApp
//
//  Created by jinho on 2021/03/13.
//

import SwiftUI

extension DateLabelView {
    var typeErasuredView: AnyView {
        return AnyView(self)
    }
    
    var castedModel: DateLabelModel? {
        return entry.displayContentModel as? DateLabelModel
    }
}

struct DateLabelView: View, ChatEntryViewProtocol {
    var entry: ChatEntryModel
    var viewControlModel: ViewControlModelProtocol?
    
    var body: some View {
        Text(castedModel?.text ?? "")
            .font(.system(size: 12))
            .foregroundColor(.white)
            .padding(.vertical, 3)
            .padding(.horizontal, 10)
            .background(Color.gray)
            .cornerRadius(10)
    }
}

struct DateLabelView_Previews: PreviewProvider {
    static var previews: some View {
        DateLabelView(entry: ChatEntryModel(displayContent: DateLabelModel(date: Date())),
                      viewControlModel: nil)
    }
}
