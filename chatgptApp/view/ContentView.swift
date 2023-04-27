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
    @ObservedObject var vm:ChatViewModel
    init(vm:ChatViewModel) {
        self.vm = vm
    }
    var body: some View {
        ZStack(alignment: .leading){
            VStack(spacing: 0){
                TitleView(OpenMenu: openMenu, vm: self.vm)
                Divider()
                    .frame(height: 0.2)
                    .overlay(Color(.systemGray2))
                ConversationView(vm: self.vm)
                Divider()
                    .frame(height: 0.2)
                    .overlay(Color(.systemGray2))
                InputView(vm: self.vm)
            }
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Color.gray)
                .opacity(0.5 * abs(self.menuOffset-self.menuCloseOffset)/abs(self.menuCloseOffset))
            MenuView(closeMenu: closeMenu, vm: self.vm)
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .offset(x: self.menuOffset)
                .animation(Animation.easeInOut, value: self.menuOffset)
        }
        .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.immediately)
        .gesture(DragGesture(minimumDistance: 5)
            .onChanged(updateMenuPosition)
            .onEnded(gentureCompletionHandler)
        )
    }
}

extension ContentView{
    func updateMenuPosition(_ value:DragGesture.Value){
        guard isMenuOpen || value.startLocation.x <= UIScreen.main.bounds.width*0.2 else { return }
        
        self.menuDragging = true
        if (isMenuOpen){
            self.menuOffset = min(self.menuOpenOffset, self.menuOpenOffset + value.translation.width)
        }else{
            self.menuOffset = min(self.menuOpenOffset, self.menuCloseOffset + value.translation.width)
        }
    }
    
    func gentureCompletionHandler(_ value:DragGesture.Value){
        if (self.menuDragging){
            if (value.location.x > value.startLocation.x) {
                openMenu()
            } else {
                closeMenu()
            }
            self.menuDragging = false
        }
    }
    
    func openMenu() -> Void {
        self.menuOffset = self.menuOpenOffset
        self.isMenuOpen = true
    }
    
    func closeMenu() -> Void {
        self.menuOffset = self.menuCloseOffset
        self.isMenuOpen = false
    }
}

struct ContentView_Previews: PreviewProvider {
    @ObservedObject static var vm = ChatViewModel(vmHisChats: CoreDataManager.instance, apiManager: OpenAIAPIManager())
    static var previews: some View {
        ContentView(vm: self.vm)
    }
}
