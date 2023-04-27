//
//  UserAPITokenView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/4/7.
//

import SwiftUI

struct UserAPITokenView: View {
    @ObservedObject var vm:ChatViewModel
    @State var apiToken = ""
    @Environment(\.dismiss) var dissmiss
    var body: some View {
        ZStack(alignment: Alignment.center){
            HStack{
                VStack{
                    HStack{
                        Spacer()
                        Button(action: {dissmiss()}){
                            Image(systemName: "xmark")
                                .font(Font.title3)
                                .foregroundColor(Color(.systemTeal))
                        }
                    }
                    Text("OpenAI API Key")
                        .font(Font.title2)
                        .padding(5)
                    TextField("Paste your key here", text: $apiToken)
                        .lineLimit(1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(TextAlignment.center)
                        .padding(5)
                    Button("Enter", action: {
                        vm.saveAPIToken(apiToken)
                        dissmiss()
                    })
                        .buttonStyle(.borderedProminent)
                        .tint(Color(.systemTeal))
                        .padding(5)
                    Link("Where do I find my Secret API Key?", destination: URL(string: "https://platform.openai.com/account/api-keys")!)
                        .font(.caption)
                        .padding(5)
                }
            }
            .frame(width: UIScreen.main.bounds.width*0.8)
        }
    }
}

struct UserAPITokenView_Previews: PreviewProvider {
    @StateObject static var vm:ChatViewModel = ChatViewModel(vmHisChats: CoreDataManager.instance, apiManager: OpenAIAPIManager())
    static var previews: some View {
        UserAPITokenView(vm: vm)
    }
}
