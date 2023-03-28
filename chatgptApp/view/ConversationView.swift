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
        List{
            ForEach(0 ..< vm.cons.count, id: \.self){ idx in
                MessageView(id: idx, picture: vm.cons[idx].role, message: vm.cons[idx].content)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(idx % 2 == 0 ? Color(.systemGray6) : Color(.systemGray5))
            }
        }.listStyle(PlainListStyle())
    }
}
struct ConversationView_Previews: PreviewProvider {
    @StateObject static var vm = chatViewModel()
    static var previews: some View {
        ConversationView(vm: vm)
    }
}
