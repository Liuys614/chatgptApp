//
//  ContentView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/7.
//

import SwiftUI

struct ContentView: View {
    @State var isMenuOpen:Bool = false
    @State private var menuOffset = UIScreen.main.bounds.width * -0.8
    @State private var menuCloseOffset = UIScreen.main.bounds.width * -0.8
    @State private var menuOpenOffset = CGFloat.zero
    @State private var menuDragging = false
    @StateObject var vm = chatViewModel()
    func openMenu() -> Void {
        self.menuOffset = self.menuOpenOffset
        isMenuOpen = true
    }
    var body: some View {
        ZStack(alignment: .leading){
            VStack(spacing: 0){
                TitleView(OpenMenu: openMenu)
                Divider()
                    .frame(height: 0.2)
                    .overlay(Color(.systemGray2))
                ConversationView(vm: self.vm)
                Divider()
                    .frame(height: 0.2)
                    .overlay(Color(.systemGray2))
                InputView(vm: self.vm)
            }
            MenuView(isVisible: $isMenuOpen, vm: self.vm)
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .offset(x: self.menuOffset)
                .animation(Animation.easeInOut, value: self.menuOffset)
        }
        .gesture(DragGesture(minimumDistance: 5)
            .onChanged{ value in
                if (!isMenuOpen && value.startLocation.x > UIScreen.main.bounds.width*0.2){
                    return
                }
                self.menuDragging = true
                if (isMenuOpen){
                    self.menuOffset = min(self.menuOpenOffset, self.menuOpenOffset + value.translation.width)
                }else{
                    self.menuOffset = min(self.menuOpenOffset, self.menuCloseOffset + value.translation.width)
                }
            }
            .onEnded { value in
                if (self.menuDragging){
                    if (value.location.x > value.startLocation.x) {
                        self.menuOffset = self.menuOpenOffset
                        self.isMenuOpen = true
                    } else {
                        self.menuOffset = self.menuCloseOffset
                        self.isMenuOpen = false
                    }
                    self.menuDragging = false
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
