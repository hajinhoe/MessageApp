//
//  InputView.swift
//  MessageApp
//
//  Created by jinho on 2021/03/14.
//

import SwiftUI

struct InputView: View {
    @Binding var inputMessage: String
    @Binding var needToScrollBottom: Bool
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            shadowView
            inputView
        }
    }
    var inputView: some View {
        VStack {
            HStack {
                Image(systemName: "photo.fill")
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .padding(.leading, 10)
                HStack(alignment: .bottom) {
                    TextEditor(text: $inputMessage)
                        .frame(maxHeight: 160)
                        .padding(1) // 패딩 값을 안 주면 스크롤 뷰 사이즈가 이상한 버그가 있음.
                        .fixedSize(horizontal: false, vertical: true)
                    sendButtonView
                }
                .background(Color.white)
                
                .cornerRadius(16)
                .padding(.trailing, 10)
            }
        }
        .padding(.vertical, 8)
        .background(Color.gray)
    }

    var sendButtonView: some View {
        Button(action: {
            withAnimation(.interactiveSpring()) {
                viewModel.sendMessage(message: TextChatModel(text: inputMessage, name: UserSettings.shared.name, date: Date()))
            }
            inputMessage.removeAll()
            needToScrollBottom = true
        }) {
            Image(systemName: "paperplane.fill")
                .resizable()
                .frame(width: 14, height: 14)
                .padding(7)
                .background(Color.blue)
                .cornerRadius(14)
                .foregroundColor(.white)
                .padding(6)
        }
    }

    var shadowView: some View {
        Rectangle()
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(.gray)
            .shadow(radius: 5)
    }

}

//struct InputView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputView()
//    }
//}
