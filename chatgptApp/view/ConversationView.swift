//
//  ConversationView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var vm:chatViewModel
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack{
                    ForEach(vm.cons){ con in
                        MessageView(picture: con.role, message: con.content)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(con.role == "assistant" ? Color(.systemGray6) : Color(.systemGray5))
                            .id(con.id)
                    }
                }
            }
            .onChange(of: vm.cons.last?.content) { _ in
                scrollProxy.scrollTo(vm.cons.last?.id, anchor: .bottomTrailing)
            }
        }
    }
}
struct ConversationView_Previews: PreviewProvider {
    @StateObject static var vm = chatViewModel()
    static var previews: some View {
        ConversationView(vm: vm)
    }
}
