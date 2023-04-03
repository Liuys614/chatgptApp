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
    private var api:client
    @Published var cons:[conversation]
    @Published var isUpdateing:Bool = false
    @MainActor lazy private var addCon:(String, String)->Void = {role, text in
        self.cons.append(conversation(role: role, content: text))
    }
    @MainActor lazy var addConvStream:(String)->Void = {delta in
        self.cons[self.cons.count - 1].content.append(delta)
    }
    
    init(){
        api = client()
        cons = [conversation]()
    }
    
    @MainActor
    func sent(_ newText:String){
        cons.append(conversation(role: api.role, content: newText))
        var hisConvs:[(String,String)] = [(String,String)]()
        for con in cons{
            hisConvs.append((con.role, con.content))
        }
        api.sentMessage(hisConvs)
    }
    
    @MainActor
    func sentStream(_ newText:String) async{
        isUpdateing = true
        api.callBackStream = addConvStream
        cons.append(conversation(role: api.role, content: newText))
        var hisConvs:[(String,String)] = [(String,String)]()
        for con in cons{
            hisConvs.append((con.role, con.content))
        }
        addCon("assistant", "")
        await api.sentMessageStream(hisConvs)
        isUpdateing = false
    }
}
