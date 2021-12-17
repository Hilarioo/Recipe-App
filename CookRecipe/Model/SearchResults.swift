//
//  SearchResults.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 12/16/21.
//

import Foundation

struct SearchResult: Codable {
    let offset: Int
    let number: Int
    let totalResults: Int
    let results: [SearchHistory]
}
