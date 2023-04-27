//
//  chatgptAppApp.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/7.
//

import SwiftUI

@main
struct ChatgptAppApp: App {
    @StateObject var vm = ChatViewModel(vmHisChats: CoreDataManager.instance, apiManager: OpenAIAPIManager())
    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm)
        }
    }
}
