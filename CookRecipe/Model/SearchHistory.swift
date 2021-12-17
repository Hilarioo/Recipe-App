//
//  SearchHistory.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 12/16/21.
//

import Foundation

struct SearchHistory: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
}
