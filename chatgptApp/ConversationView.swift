//
//  ConversationView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct ConversationView: View {
    let messages:[MessageView] = [
        MessageView(id:0, picture: "user-avatar", message: "Have you ever gobbledop a flibberdyjibbit while blubbering a snarflepoof?"),
        MessageView(id:1, picture: "chatgpt-icon", message: "Integer accumsan nulla nec libero elementum eleifend. Ut vitae semper metus. Sed maximus, odio vel hendrerit commodo, sapien metus gravida massa, at elementum metus dolor eget nisi. Proin pharetra lacus et nunc venenatis maximus. Donec quis faucibus nulla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Ut eu sem sed purus elementum molestie. Curabitur non enim libero. Aenean vel nisi turpis. Quisque bibendum leo sit amet vestibulum pulvinar."),
        MessageView(id:2, picture: "user-avatar", message: "Do you believe that zippidybops will eventually skoodlebop most flibbertigibbets in the gobbledygook?"),
        MessageView(id:3, picture: "chatgpt-icon", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus in nunc turpis. Maecenas quis elit ultricies, euismod elit ac, imperdiet ipsum. Nam et purus a augue lobortis gravida non non ipsum. Sed non efficitur libero. Nulla eget felis sed mauris congue luctus at at lectus. Sed suscipit dui ut neque euismod, nec vestibulum libero semper. ")
    ]
    var body: some View {
        List{
            ForEach(messages){ message in
                message
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(message.id % 2 == 0 ? Color(.systemGray6) : Color(.systemGray5))
            }
        }.listStyle(PlainListStyle())
    }
}
struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}
