//
//  LoadingBtnView.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/4/7.
//

import SwiftUI

struct loadingCircleView: View{
    @State var scale: CGFloat = 1.1
    @State var delay: Double = 0
    var body: some View{
        Circle()
            .foregroundColor(.teal)
            .scaleEffect(scale)
            .animation(.easeInOut(duration: 0.8).repeatForever().delay(delay), value: scale)
            .onAppear(){
                scale = 0.8
            }
    }
}

struct LoadingBtnView: View {
    var body: some View {
        HStack{
            loadingCircleView()
            loadingCircleView(delay: 0.3)
            loadingCircleView(delay: 0.6)
        }
        .frame(height: 8)
    }
}

struct LoadingBtnView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingBtnView()
    }
}
