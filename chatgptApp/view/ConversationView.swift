//
//  ConversationView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var vm:ChatViewModel
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack(spacing: 0){
                    ForEach(vm.curDialogue.utters, id: \.id){ utter in
                        MessageView(picture: utter.role, message: utter.content)
                            .background(utter.role == "assistant" ? Color(.systemGray6) : Color(.systemBackground))
                            .id(utter.id)
                    }
                    Text(vm.errorMessage)
                        .foregroundColor(Color.red)
                        .font(.callout)
                }
            }
            .onChange(of: vm.curDialogue.utters.last?.content) { _ in
                scrollProxy.scrollTo(vm.curDialogue.utters.last?.id, anchor: .bottomTrailing)
            }
        }
    }
}
struct ConversationView_Previews: PreviewProvider {
    @StateObject static var vm = ChatViewModel(vmHisChats: CoreDataManager.instance, apiManager: OpenAIAPIManager())
    static var previews: some View {
        ConversationView(vm: vm)
    }
}
