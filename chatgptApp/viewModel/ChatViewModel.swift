//
//  chatgptViewMoudle.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/28.
//

import Foundation

struct Conversation{
    var dials:[Dialogue] = [Dialogue]()
}

struct Dialogue{
    var id:UUID = UUID()
    var title:String = "New Chat"
    var titleUpdated: Bool = false
    var utters:[Utterance] = [Utterance]()
}

struct Utterance{
    var id:UUID = UUID()
    var order:Int
    var role:String
    var content:String
    var done:Bool = false
}

class ChatViewModel:ObservableObject{
    //
    // MARK: public functions and properties
    //
    
    @MainActor @Published var conversation:Conversation = Conversation()
    @MainActor @Published var curDialogue:Dialogue = Dialogue()
    @MainActor @Published var isUpdateing:Bool = false
    @MainActor @Published var errorMessage:String = ""
    
    init(vmHisChats:CoreDataManager, apiManager:OpenAIAPIManager){
        self.api = apiManager
        self.mgr = vmHisChats
    }
    
    func addConvStream(_ delta:String) async->Void{
        await MainActor.run {
            self.curDialogue.utters[self.curDialogue.utters.count-1].content.append(delta)
        }
    }
    
    func updateTitle(_ title:String) async->(){
        await MainActor.run{
            curDialogue.title = title
        }
    }
    
    func loadToCurrentChat(uid: UUID) async{
        guard let loadedDialog = mgr.fetchDialog(uid: uid) else { return }
        await MainActor.run{
            curDialogue = loadedDialog
        }
    }
   
    func syncConversation() async{
        await MainActor.run{
            conversation = mgr.fetchConversationInfo()
        }
    }
    
    func saveAndClearCurrentDialogue() async{
        await MainActor.run{
            mgr.updateDialogue(dial: curDialogue)
            curDialogue = Dialogue()
        }
        await syncConversation()
    }
    
    func clearErrorMessage()async{
        await MainActor.run {
            errorMessage = ""
            guard self.curDialogue.utters.last != nil else { return }
            if self.curDialogue.utters.last?.role == "assistant",
               self.curDialogue.utters.last?.done == false{
                self.curDialogue.utters.removeLast()
            }
        }
    }
    
    func saveAPIToken(_ key:String){
        api.setAPIKey(key)
    }
    
    func sentStream(_ newText:String) async{
        await toggleUpdating(true)
        api.sentStreamCompleteHandler = addConvStream
        api.errorHandler = updateErrorMessage
        api.getTitleCompleteHandler = updateTitle
        await addUttr(api.role, newText)
        await addUttr("assistant", "")
        await api.sentMessageStream(curDialogue.utters.map{($0.role, $0.content)})
        if await curDialogue.titleUpdated == false{
            await api.getTitle(curDialogue.utters.map{($0.role, $0.content)})
        }
        await MainActor.run {
            curDialogue.titleUpdated = true
        }
        await markLastConDone()
        await toggleUpdating(false)
    }
 
    func deleteDialogue(_ dialog: Dialogue) async{
        mgr.removeDialogue(dial: dialog)
        await syncConversation()
    }
    
    //
    // MARK: Private functions and properties
    //
    
    private var api:OpenAIAPIManager
    private var mgr: HistoricChatsDataManager
    
    private func addNewDialogue () async{
        await mgr.updateDialogue(dial: curDialogue)
        await MainActor.run{
            curDialogue = Dialogue()
        }
        await syncConversation()
    }
    
    private func addUttr(_ role:String, _ text:String)async->Void{
        await MainActor.run {
            self.curDialogue.utters.append(Utterance(order: curDialogue.utters.count + 1, role: role, content: text))
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
    
    private func markLastConDone()async->Void{
        await MainActor.run {
            var curDialogueCopy = self.curDialogue
            let idx = self.curDialogue.utters.count-1
            curDialogueCopy.utters[idx].done = true
            self.curDialogue = curDialogueCopy
        }
    }
}
