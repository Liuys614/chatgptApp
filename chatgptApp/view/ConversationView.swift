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
                LazyVStack(spacing: 0){
                    ForEach(vm.cons){ con in
                        MessageView(picture: con.role, message: con.content)
                            .background(con.role == "assistant" ? Color(.systemGray6) : Color(.systemBackground))
                            .id(con.id)
                    }
                    Text(vm.errorMessage)
                        .foregroundColor(Color.red)
                        .font(.callout)
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
