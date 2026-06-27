//
//  Item.swift
//  CatApi
//
//  Created by Eugen Dryl on 20.06.2026.
//

import Foundation
import SwiftData

@Model
final class Cat {
    @Attribute(.unique) var id: String
    var name: String
    var url: String
    
    init(id: String, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
}
