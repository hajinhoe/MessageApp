//
//  ContentView.swift
//  Shared
//
//  Created by jinho on 2020/12/14.
//

import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    @Published var needsInitialization: Bool
    @Published var userNameInputString: String = ""
    
    init() {
        needsInitialization = !UserSettings.shared.isInitialized
    }
    
    func save() {
        UserSettings.shared.initialize(name: userNameInputString)
        needsInitialization = false
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            ChatRoomView()
                .disabled(viewModel.needsInitialization)
            if viewModel.needsInitialization {
                ZStack {
                    VStack() {
                        Spacer()
                        HStack {
                            Spacer()
                        }
                        Spacer()
                    }
                    .background(Color.gray)
                    .opacity(0.3)
                    VStack {
                        Text("Please set user name")
                        TextField("User name", text: $viewModel.userNameInputString)
                        Button("Save", action: viewModel.save)
                    }
                    .background(Color.white)
                    .cornerRadius(3)
                    .border(Color.black, width: 1)
                    .frame(width: 200)
                }

            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct MessageBoxBackgroundColorKey: EnvironmentKey {
    static var defaultValue: Color = .blue
}

extension EnvironmentValues {
    var messageBoxBackgroundColor: Color {
        get { self[MessageBoxBackgroundColorKey.self] }
        set { self[MessageBoxBackgroundColorKey.self] = newValue }
    }
}

struct MessageBoxBackgroundColorModifier: ViewModifier {
    let color: Color

    init(_ color: Color) {
        self.color = color
    }

    func body(content: Content) -> some View {
        content
            .environment(\.messageBoxBackgroundColor, color)
    }
}

extension View {
    func messageBoxBackgroundColor(_ color: Color) -> some View {
        return self.modifier(MessageBoxBackgroundColorModifier(color))
    }
}

struct MessageBoxView<ContentView: View>: View {
    @Environment(\.messageBoxBackgroundColor) var messageBoxBackgroundColor
    let contentView: ContentView

    @inlinable public init(@ViewBuilder contentView: @escaping () -> ContentView) {
        self.contentView = contentView()
    }


    var body: some View {
        HStack(spacing: 0) {
            VStack {
                contentView
            }
            .frame(minWidth: 10)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(messageBoxBackgroundColor)
            .cornerRadius(10)

// To do - 메시지 풍선에 꼬리 붙이기.
//            Path { path in
//                //path.move(to: CGPoint(x: 0, y: 40))
//                path.move(to: CGPoint(x: 0, y: 10))
//                //path.addLine(to: CGPoint(x: 0, y: 30))
//                path.addQuadCurve(to: CGPoint(x: 10, y: 0), control: CGPoint(x: 5, y: 0))
//                path.addQuadCurve(to: CGPoint(x: 0, y: 0), control: CGPoint(x: 5, y: 0))
//
//                path.addLine(to: CGPoint(x: -2, y: 0))
//                //path.addQuadCurve(to: CGPoint(x: 100, y: 30), control: CGPoint(x: 50, y: 50))
//
//                //path.addLine(to: CGPoint(x: 20, y: 30))
//            }
//            .fill(Color.green)
//                .alignmentGuide(.center, computeValue: { dimension in
//                    return 100
//                })
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
