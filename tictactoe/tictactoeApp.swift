//
//  tictactoeApp.swift
//  tictactoe
//
//  Created by Devin Michael Atkin on 2025-08-12.
//

import SwiftUI

@main
struct tictactoeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
