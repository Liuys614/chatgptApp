//
//  ContentView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action:{
                postOpenAIRequest()
            }){
                Text("try api")
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
