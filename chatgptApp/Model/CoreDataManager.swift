//
//  coreDataManager.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/4/11.
//

import Foundation
import CoreData

class CoreDataManager:HistoricChatsDataManager{
    // MARK: Public functions and properties
    
    static let instance = CoreDataManager() // singleton
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    var dialogues:[DialogueEntity] = []
    
    // return dialogues' info only (leave utterance empty )
    func fetchConversationInfo() -> Conversation {
        sync()
        var conv = Conversation()
        for diaEnt in dialogues{
            let dia = Dialogue(id: diaEnt.uid!, title: diaEnt.title!, utters: [Utterance]())
            conv.dials.append(dia)
        }
        return conv
    }
    
    func fetchDialog(uid:UUID) -> Dialogue?{
        guard let dialogEntity = getDialogEntity(by: uid),
              let allUttr = dialogEntity.utterances?.allObjects as? [UtteranceEntity] else {return nil}
        var uttr = [Utterance]()
        allUttr.forEach{ ue in
            guard let uid = ue.uid,
                  let role = ue.role,
                  let content = ue.content else{ return }
            uttr.append(Utterance(id: uid, order: Int(ue.order) , role: role, content: content, done: true))
        }
        uttr.sort(by: {$0.order < $1.order})
        guard let uid = dialogEntity.uid,
              let title = dialogEntity.title else {return nil}
        return Dialogue(id: uid, title: title, utters: uttr)
    }
    
    func updateTitle(dial:Dialogue)->(){
        guard let dialogEntity = getDialogEntity(by: dial.id) else {return}
        dialogEntity.title = dial.title
        savensync()
    }
    
    func updateDialogue(dial:Dialogue) {
        let dialogEntity = getDialogEntity(by: dial.id)
        // remove old dialog
        if let dialogEntity{
            removeDialogAndUtters(dialEntry: dialogEntity)
        }
        addDialog(dial: dial)
        savensync()
    }
    
    func removeDialogue(dial:Dialogue)->(){
        guard let dialogEntity = getDialogEntity(by: dial.id) else{return}
        removeDialogAndUtters(dialEntry: dialogEntity)
        savensync()
    }
    
    // MARK: Private functions and properties
    private init(){
        container = NSPersistentContainer(name: "HistoryChatsContainer")
        container.loadPersistentStores { description , error in
            guard let error else{return}
            print("[CoreData error] Error while loading. \(error.localizedDescription)")
        }
        context = container.viewContext
    }
    
    private func addDialog(dial: Dialogue) {
        let newDialog = DialogueEntity(context: context)
        newDialog.title = dial.title
        newDialog.uid = dial.id
        addUtters(dialEntry: newDialog, utters: dial.utters)
        savensync()
    }
     
    private func addUtters(dialEntry: DialogueEntity, utters: [Utterance]){
        utters.forEach { utt in
            let newUtt = UtteranceEntity(context: context)
            newUtt.role = utt.role
            newUtt.content = utt.content
            newUtt.dialogue =  dialEntry
            newUtt.uid = utt.id
            newUtt.order = Int16(utt.order)
        }
    }
    
    private func getDialogEntity(by dialID: UUID) -> DialogueEntity?{
        var dialogueEntitys = [DialogueEntity]()
        let fetchRequest = DialogueEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", dialID as CVarArg)
        do {
            dialogueEntitys = try context.fetch(fetchRequest)
        }catch{
            return nil
        }
        if dialogueEntitys.isEmpty{
            return nil
        }
        else{
            return dialogueEntitys[0]
        }
    }
   
    private func removeDialogAndUtters(dialEntry:DialogueEntity) -> (){
        guard let uid = dialEntry.uid else{return}
        guard let dialEntity = getDialogEntity(by: uid),
              let allUttr = dialEntity.utterances?.allObjects as? [UtteranceEntity] else {return}
        allUttr.forEach { utterEntity in
            context.delete(utterEntity)
        }
        context.delete(dialEntity)
    }
    
    private func savensync(){ save(); sync()}
    
    private func sync(){
        do {
            dialogues = try context.fetch(DialogueEntity.fetchRequest())
        } catch let error {
            print("[CoreData error] Error while fetching. \(error.localizedDescription)")
        }
    }
     
    private func save(){
        do{
            try context.save()
        }catch let error{
            print("[CoreData error] Error while saving. \(error.localizedDescription)")
        }
    }
}
