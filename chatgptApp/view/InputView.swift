//
//  InputView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct InputView: View {
    @State private var text:String = ""
    @ObservedObject var vm:chatViewModel
    func onSubmit(){
        vm.sent(text)
        text = ""
    }
    var body: some View {
        HStack{
            TextField("Please input your text.", text: $text, axis: Axis.vertical)
                .lineLimit(10)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 5))
                .onSubmit {
                    onSubmit()
                }
            Button(action: {
                onSubmit()
            }){
                Image(systemName: "paperplane")
                    .fontWeight(Font.Weight.semibold)
            }
            .foregroundColor(.teal)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 20))
        }
    }
}

struct InputView_Previews: PreviewProvider {
    @StateObject static var vm:chatViewModel = chatViewModel()
    static var previews: some View {
        InputView(vm: self.vm)
    }
}
