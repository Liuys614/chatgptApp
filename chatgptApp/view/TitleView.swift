//
//  titleView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct TitleView: View {
    var OpenMenu: () -> Void
    var body: some View {
        HStack{
            Button(action:{
                OpenMenu()
            }){
                Image(systemName: "list.bullet"/*"equal.square"*/)
            }
            .padding()
            .foregroundColor(Color.teal)
            .fontWeight(.semibold)
            Spacer()
            Text("Chat GPT")
                .font(Font.headline)
            Spacer()
            Button(action:{
            }){
                Image(systemName: "plus")
            }
            .padding()
            .foregroundColor(Color.teal)
            .fontWeight(.semibold)
        }
        .background(Color(.systemGray6))
    }
}

struct titleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(OpenMenu: {})
    }
}
