//
//  MenuItemView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/4/7.
//

import SwiftUI

struct MenuItemView: View {
    var iconName:String
    var title:String
    @Binding var isVisiable:Bool
    var body: some View {
        Button(action: {
            isVisiable.toggle()
        }) {
            HStack {
                Image(systemName: iconName)
                    .frame(width: 30, height: 30, alignment: .leading)
                Text(title)
                Spacer()
            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
        }
    }
}

struct MenuItemView_Previews: PreviewProvider {
    @State static var isVisiable = false
    static var previews: some View {
        MenuItemView(iconName: "", title: "", isVisiable: $isVisiable)
    }
}
