//
//  InputView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct InputView: View {
    @State private var text:String = ""
    @ObservedObject var vm:ChatViewModel
    @FocusState var textfieldFocus: Bool
    func onSubmit() {
        if vm.isUpdateing{ return }
        Task{
            textfieldFocus = false
            await vm.clearErrorMessage()
            let sentText = text
            text = ""
            await vm.sentStream(sentText)
        }
    }
    var body: some View {
        VStack{
            HStack(alignment: .center){
                TextField("Please input your text.", text: $text, axis: Axis.vertical)
                    .lineLimit(10)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onSubmit(onSubmit)
                    .keyboardType(UIKeyboardType.default)
                    .focused($textfieldFocus)
                Button(action:onSubmit){
                    if(vm.isUpdateing){
                        LoadingBtnView()
                    } else{
                        Image(systemName: "paperplane")
                            .fontWeight(Font.Weight.semibold)
                    }
                }
                .frame(width: 30)
                .foregroundColor(Color(.systemTeal))
                .disabled(vm.isUpdateing)
            }
            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
            .background(Color(.systemBackground))
            .cornerRadius(5)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 3)
            .padding()
        }
        .background(Color(.systemGray6))
    }
}


struct InputView_Previews: PreviewProvider {
    @StateObject static var vm:ChatViewModel = ChatViewModel(vmHisChats: CoreDataManager.instance, apiManager: OpenAIAPIManager())
    static var previews: some View {
        InputView(vm: self.vm)
    }
}
