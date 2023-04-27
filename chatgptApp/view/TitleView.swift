//
//  titleView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct TitleView: View {
    var OpenMenu: () -> Void
    @ObservedObject var vm:ChatViewModel
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
            Text(vm.curDialogue.title)
                .font(Font.headline)
            Spacer()
            Button(action:{
                Task{
                    // TODO: lock UI after message saved
                    await vm.clearErrorMessage()
                    await vm.saveAndClearCurrentDialogue()
                }
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
        TitleView(OpenMenu: {}, vm: ChatViewModel(vmHisChats: CoreDataManager.instance, apiManager: OpenAIAPIManager()))
    }
}
