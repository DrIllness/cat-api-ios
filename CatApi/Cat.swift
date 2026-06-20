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
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
