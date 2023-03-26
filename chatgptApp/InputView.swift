//
//  InputView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/25.
//

import SwiftUI

struct InputView: View {
    @State var text:String = ""
    var body: some View {
        HStack{
            TextField("Please input your text.", text: $text, axis: Axis.vertical)
                .lineLimit(10)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 5))
            Button(action: {}){
                Image(systemName: "paperplane")
                    .fontWeight(Font.Weight.semibold)
            }
            .foregroundColor(.teal)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 20))
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
