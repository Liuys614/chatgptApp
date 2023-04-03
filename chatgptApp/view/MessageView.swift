//
//  MessageView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct MessageView: View{
    var picture: String
    var message:String
    
    var body: some View {
        HStack(alignment: .top){
            Image(picture)
                .resizable()
                .frame(width: 30, height: 30)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 10))
            Text("\(message)")
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 10))
            Spacer()
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var msg:String = "test message"
    static var previews: some View {
        MessageView(picture: "user-avatar", message: msg)
    }
}
