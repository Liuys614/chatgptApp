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
    @StateObject var vm = chatViewModel()
    var body: some View {
        HStack {
            VStack {
                Text("Setting")
                    .font(Font.title2)
                Divider()
                MenuItemView(iconName: "person", title: "User icon", isVisiable: $showAvatorSettingView)
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
    static var previews: some View {
        MenuView(isVisible: $isMenuOpen)
    }
}
