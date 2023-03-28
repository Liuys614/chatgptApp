//
//  chatgptViewMoudle.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/28.
//

import Foundation

struct conversation{
    var role:String
    var content:String
    var done:Bool = false
}

class chatViewModel:ObservableObject{
    private var api:client
    @Published var cons:[conversation]
    init(){
        api = client()
        cons = [conversation]()
        cons.append(conversation(role: "user", content: "hi"))
        cons.append(conversation(role: "assistant", content: "hello"))
    }
    
    @MainActor
    func addCon(_ role:String, _ text:String){
        cons.append(conversation(role: role, content: text))
    }
    
    @MainActor
    func sent(_ newText:String){
        api.callBack = addCon
        cons.append(conversation(role: api.role, content: newText))
        var hisConvs:[(String,String)] = [(String,String)]()
        for con in cons{
            hisConvs.append((con.role, con.content))
        }
        api.sentMessage(hisConvs)
        //cons.append(conversation(role: "assistant", content: t[0]))
    }
}
