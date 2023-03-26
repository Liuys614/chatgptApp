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
            Spacer()
            Button(action:{
            }){
                Image(systemName: "plus")
            }
            .padding()
            .foregroundColor(Color.teal)
            .fontWeight(.semibold)
        }
    }
}

struct titleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(OpenMenu: {})
    }
}
