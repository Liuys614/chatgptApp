//
//  HistoryChatsView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/4/11.
//

import SwiftUI



struct HistoryChatsView: View {
    @ObservedObject var vm:ChatViewModel
    @State var showDeleteAlert:Bool = false
    var closeMenu: () -> Void
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading){
                ForEach( vm.conversation.dials, id: \.id){ dial in
                    HStack{
                        Button {
                            Task{
                                await vm.loadToCurrentChat(uid: dial.id)
                                closeMenu()
                            }
                        }label: {
                            Text(dial.title)
                                .lineLimit(1)
                                .foregroundColor(Color.primary)
                        }
                        
                        Spacer()
//                        TODO: Edit Title feature
//                        Button(action:{}){
//                            Image(systemName: "square.and.pencil")
//                        }
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(Color(.systemTeal))
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(title: Text("Confirm Deletion"),
                                  message: Text("Are you sure you want to delete this chat?"),
                                  primaryButton: .destructive(Text("Delete")) {
                                Task{
                                    await vm.deleteDialogue(dial)
                                }
                            }, secondaryButton: .cancel())
                        }
                    }
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 5))
                    Divider()
                }
            }
        }
        .task {
            await vm.syncConversation()
        }
    }
}

struct HistoryChatsView_Previews: PreviewProvider {
    @State static var menuOpen = false
    static var previews: some View {
        HistoryChatsView(vm: ChatViewModel(vmHisChats: CoreDataManager.instance, apiManager: OpenAIAPIManager()), closeMenu: {})
    }
}
