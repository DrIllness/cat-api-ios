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
        TabView {
            Tab("Breeds", systemImage: "cat.fill") {
                NavigationStack {
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                AsyncImage(url: URL(string: item.url)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                            } label: {
                                AsyncImage(url: URL(string: item.url)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                     
                                } placeholder: {
                                    ProgressView()
                                }
                                Text(item.name)
                            }
                        }
                    }
                    .navigationTitle("Breeds")
                }.task {
                    await fetchAndSaveItems()
                }
            }
            Tab("Kek", systemImage: "cat.fill") {
                Text("Tab 2")
            }
            Tab("Kek", systemImage: "cat.fill") {
                Text("Tab 3")
            }
        }

    }
    
    private func fetchAndSaveItems() async {
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds?limit=15")
        else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let rawCats: [CatBreedRaw] = try JSONDecoder().decode([CatBreedRaw].self, from: data)
            print("cats amount: \(rawCats.count)")
            var entities = Array() as [Cat]
            
            for rawCat in rawCats {
           
                guard let imageUrl = URL(string: "https://api.thecatapi.com/v1/images/search?breed_ids=\(rawCat.id)")
                else { continue }
                
                let (data, _) = try await URLSession.shared.data(from: imageUrl)
                let rawImages: [BreedImageRaw] = try JSONDecoder().decode([BreedImageRaw].self, from: data)
                
                guard let img = rawImages.first?.url else { continue }
                let newItem = Cat(id: rawCat.id, name: rawCat.name, url: img)
                entities.append(newItem)
            }
            
            do {
                try modelContext.transaction {
                    for entity in entities {
                        modelContext.insert(entity)
                    }
                }
                try modelContext.save()
            } catch {
                print("failed to save into db")
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

struct BreedImageRaw: Decodable {
    let url: String
}

#Preview {
    ContentView()
        .modelContainer(for: Cat.self, inMemory: true)
}
