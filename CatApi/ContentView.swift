//
//  ContentView.swift
//  CatApi
//
//  Created by Eugen Dryl on 20.06.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Cat]

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text(item.name)
                    } label: {
                        Text(item.name)
                    }
                }
            }
            .navigationTitle("Cats")
            .toolbar {
                Button("fetch") {
                    Task {
                        await fetchAndSaveItems()
                    }
                }
            }
        }
    }
    
    private func fetchAndSaveItems() async {
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds?limit=10") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let rawCats: [CatBreedRaw] = try JSONDecoder().decode([CatBreedRaw].self, from: data)
            print("cats amount: \(rawCats.count)")
            for rawCat in rawCats {
                let newItem = Cat(name: rawCat.name)
                modelContext.insert(newItem)
            }
        } catch {
            print("failed to pull cats")
        }
    }
}

struct CatBreedRaw: Decodable {
    let id: String
    let name: String
}

#Preview {
    ContentView()
        .modelContainer(for: Cat.self, inMemory: true)
}
