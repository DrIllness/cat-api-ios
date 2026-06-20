//
//  CatApiApp.swift
//  CatApi
//
//  Created by Eugen Dryl on 20.06.2026.
//

import SwiftUI
import SwiftData

@main
struct CatApiApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Cat.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
