//
//  MenuView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct MenuItem : Hashable{
    var icon: String = ""
    var title: String = ""
}

struct MenuView: View {
    @Binding var isVisible: Bool
    @State var showAPITokenView: Bool = false
    @State var showAvatorSettingView: Bool = false
    @ObservedObject var vm:ChatViewModel
    var body: some View {
        HStack {
            VStack {
                Text("History chats")
                    .font(Font.title2)
                Divider()
                HistoryChatsView(vm: self.vm)
                    .frame( height: UIScreen.main.bounds.height/3)
                Text("Setting")
                    .font(Font.title2)
                Divider()
                MenuItemView(iconName: "person", title: "User icon", isVisiable: $showAvatorSettingView)
                Divider()
                MenuItemView(iconName: "key.horizontal.fill", title: "User API Token", isVisiable: $showAPITokenView)
                Spacer()
            }
            .sheet(isPresented: $showAPITokenView){
                UserAPITokenView(vm: vm)
            }
        }
        .background(Color(.systemGray6))
    }
        
}

struct MenuView_Previews: PreviewProvider {
    @State static var isMenuOpen:Bool = true
    @StateObject static var vm = ChatViewModel(vmHisChats: CoreDataManager.instance, apiManager: OpenAIAPIManager())
    static var previews: some View {
        MenuView(isVisible: $isMenuOpen, vm: vm)
    }
}
