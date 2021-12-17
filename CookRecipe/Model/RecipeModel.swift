//
//  RecipeModel.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 12/16/21.
//

import Foundation

struct RecipeModel: Codable, Hashable {
    var title : String?
    var imageURL : String?
    var timeRequired : Int?
    var sourceURL : String?
    var ingredients : [String]?
    var instructions : [String]?
    var servings: Int?
    var summary: String?
    var cuisines: [String]?
}
