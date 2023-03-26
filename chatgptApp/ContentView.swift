//
//  ContentView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/7.
//

import SwiftUI

struct ContentView: View {
    @State var isMenuOpen:Bool = true
    @State private var offset = UIScreen.main.bounds.width * -0.8
    @State private var closeOffset = UIScreen.main.bounds.width * -0.8
    @State private var openOffset = CGFloat.zero
    func openMenu() -> Void {
        self.offset = self.openOffset
    }
    var body: some View {
        ZStack(alignment: .leading){
            VStack{
                TitleView(OpenMenu: openMenu)
                ConversationView()
                InputView()
            }
            MenuView(isVisible: $isMenuOpen)
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .offset(x: self.offset)
                .animation(Animation.easeInOut, value: self.offset)
        }
        .gesture(DragGesture(minimumDistance: 5)
            .onChanged{ value in
                if (self.offset < self.openOffset) {
                    self.offset = self.closeOffset + value.translation.width
                }
            }
            .onEnded { value in
                if (value.location.x > value.startLocation.x) {
                    self.offset = self.openOffset
                } else {
                    self.offset = self.closeOffset
                }
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
