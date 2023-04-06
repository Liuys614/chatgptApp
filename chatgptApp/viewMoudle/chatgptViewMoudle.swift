//
//  chatgptViewMoudle.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/28.
//

import Foundation

struct conversation: Identifiable, Equatable, Hashable{
    var id = UUID()
    var role:String
    var content:String
    var done:Bool = false
}

class chatViewModel:ObservableObject{
    @MainActor @Published var cons:[conversation] = [conversation]()
    @MainActor @Published var isUpdateing:Bool = false
    @MainActor @Published var errorMessage:String = ""
    
    init(){
        api = client()
    }
    
    func addConvStream(_ delta:String) async->Void{
        await MainActor.run {
            self.cons[self.cons.count-1].content.append(delta)
        }
    }
    
    private var api:client
    private func addCon(_ role:String, _ text:String)async->Void{
        await MainActor.run {
            self.cons.append(conversation(role: role, content: text))
        }
    }
    
    private func updateErrorMessage(_ text:String)async->Void{
        await MainActor.run {
            self.errorMessage = text
        }
    }
    
    private func toggleUpdating(_ isUpdating:Bool)async->Void{
        await MainActor.run {
            self.isUpdateing = isUpdating
        }
    }
    
    func sentStream(_ newText:String) async{
        await toggleUpdating(true)
        api.sentStreamCompleteHandler = addConvStream
        api.errorHandler = updateErrorMessage
        await addCon(api.role, newText)
        await addCon("assistant", "")
        await api.sentMessageStream(cons.map{($0.role, $0.content)})
        await toggleUpdating(false)
    }
}
