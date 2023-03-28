//
//  MenuView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct MenuItem: Hashable {
    var icon: String
    var title: String
}

struct MenuView: View {
    @Binding var isVisible: Bool
    var menuItems = [MenuItem(icon: "person", title: "User icon"),
                     MenuItem(icon: "key.horizontal.fill", title: "User API Token")]
  
    var body: some View {
        HStack {
            VStack {
                Text("Setting")
                    .font(Font.title2)
                List(menuItems, id: \.self) { item in
                    Button(action: {}) {
                        HStack {
                            Image(systemName: item.icon)
                                .frame(width: 30, height: 30, alignment: .leading)
                            Text(item.title)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(.systemGray6))
                }
                .listStyle(PlainListStyle())
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
