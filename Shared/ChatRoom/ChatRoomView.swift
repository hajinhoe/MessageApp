//
//  ChatRoomView.swift
//  MessageApp
//
//  Created by jinho on 2021/03/13.
//

import SwiftUI

struct ChatRoomView: View {
    @State var inputMessage = "어디갔어"
    @ObservedObject var viewModel = ViewModel()
    @State var scrollYOffset = CGFloat(0)
    @State var needToScrollBottom = false

    @State var needToShowPhoto = true

    @State var test = false

    @State var safe: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            VStack {
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack {
                            ForEach(0..<viewModel.contents.count, id: \.self) { count in
                                VStack {
                                    routeView(content: viewModel.contents[count], displayData: viewModel.messageContentDisplayData(at: count))
                                        .padding(.horizontal)
                                    Spacer()
                                        .frame(height: 3)
                                }
                                    .id(count)
                            }
                        }
                    }
                    .onTapGesture(count: 1, perform: {
                        UIApplication.shared.endEditing()
                    })
                    .onChange(of: needToScrollBottom, perform: { value in
                        if needToScrollBottom {
                            withAnimation {
                                scrollView.scrollTo(viewModel.contents.count - 1, anchor: .bottom)
                            }
                            needToScrollBottom = false
                        }
                    })
                }
                VStack {
                    #if DEBUG
                    testToolView
                    #endif
                    InputView(inputMessage: $inputMessage, needToScrollBottom: $needToScrollBottom, viewModel: viewModel)
                }
            }
            .onAppear(perform: {
                safe = proxy.safeAreaInsets.bottom
                print(safe)
            })
        }
        .background(
            VStack {
                Spacer()
                Color.gray
                    .frame(height: safe)
            }
                .edgesIgnoringSafeArea(.bottom)
        )
    }

    var testToolView: some View {
        HStack {
            Button(action: {
                    test.toggle()

                    UIApplication.shared.endEditing()
            }) {
                Text("Test")
            }
            Button(action: {
                withAnimation(.interactiveSpring()) {
                    viewModel.sendMessage(message: TextChatModel(text: inputMessage, name: "째깍이", date: Date()))
                }
                inputMessage.removeAll()
                needToScrollBottom = true
            }) {
                Text("Send as B")
            }
        }
    }

    func dateLabelView(dateLabel: DateLabelModel) -> some View {
        Text(dateLabel.text)
            .font(.system(size: 12))
            .foregroundColor(.white)
            .padding(.vertical, 3)
            .padding(.horizontal, 10)
            .background(Color.gray)
            .cornerRadius(10)
    }

    @ViewBuilder func routeView(content: ChatEntryModel, displayData: ViewControlModelProtocol) -> some View {
        ContentRouteView(entry: content, viewControlModel: displayData)
    }
}

struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView()
    }
}
