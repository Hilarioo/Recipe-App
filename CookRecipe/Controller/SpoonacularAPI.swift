//
//  SpoonacularAPI.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 12/16/21.
//

import Foundation

import UIKit

class SpoonacularAPI: ObservableObject {
    static let apiKey = "a67a5241c34f45429f75c2d8a1858a67"
    static let host = "api.spoonacular.com"
    static let scheme = "https"
    @Published var recipes: [RecipeModel] = []
    
    var randomRecipeURL: URL {
        var components = URLComponents()
        components.host = SpoonacularAPI.host
        components.path = "/recipes/random"
        components.scheme = SpoonacularAPI.scheme
        
        components.queryItems = [URLQueryItem]()
        components.queryItems?.append(URLQueryItem(name: "apiKey", value: SpoonacularAPI.apiKey))
        components.queryItems?.append(URLQueryItem(name: "number", value: "10"))
        
        return components.url!
    }
    
    func getRandomRecipe() {
        let task = URLSession.shared.dataTask(with: randomRecipeURL) { (data, _, error) in
            
            guard let data = data, error == nil else {
                print("Error: fetching data")
                return
            }
            
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [AnyHashable: Any]
                if let recipeArray = responseObject?["recipes"] as? [[String: Any]] {
                    let recipes = self.createRecipes(recipeArray: recipeArray)
                    
                    DispatchQueue.main.async {
                        self.recipes = recipes
                    }
                    
//                    var title : String?
//                    var imageURL : String?
//                    var timeRequired : Int?
//                    var sourceURL : String?
//                    var ingredients : [String]?
//                    var instructions : [String]?
//                    var servings: Int?
//                    var summary: String?
//                    var cuisines: [String]?
                    
                    print(recipes[0].ingredients!)


                }
                
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
            
    }
    
    
    func downloadRecipeImage(imageURL: String, completion: @escaping (UIImage?, Bool) -> Void) {
        if let url = URL(string: imageURL) {
            DispatchQueue.global(qos: .userInitiated).async {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else {
                        completion(nil, false)
                        return
                    }
                    DispatchQueue.main.async{
                        completion(UIImage(data: data), true)
                    }
                }
                task.resume()
            }
        }
    }
    
    private func createRecipes(recipeArray: [[String: Any]]) -> [RecipeModel] {
        var recipes = [RecipeModel]()
        for recipeInfo in recipeArray {
            let recipe = configureRecipe(recipeInfo: recipeInfo)
            recipes.append(recipe)
        }
        return recipes
    }
    
    private func configureRecipe(recipeInfo: [String: Any]) -> RecipeModel{
        var recipe = RecipeModel()
        
        if let title = recipeInfo["title"] as? String {
            recipe.title = title
        }
        
        if let servings = recipeInfo["servings"] as? Int {
            recipe.servings = servings
        }
        
        if let imageURL = recipeInfo["image"] as? String {
            recipe.imageURL = imageURL
        }
        
        if let sourceURL = recipeInfo["sourceUrl"] as? String {
            recipe.sourceURL = sourceURL
        }

        if let ingredientArray = recipeInfo["extendedIngredients"] as? [[String: Any]] {
            if ingredientArray.count == 0 {
                recipe.ingredients = []
            } else {
                var ingredients = [String]()
                for ingredient in ingredientArray {
                    if let ingredient = ingredient["originalString"] as? String {
                        ingredients.append(ingredient)
                    }
                }
                recipe.ingredients = ingredients
            }
        } else {
            recipe.ingredients = []
        }
        
        if let timeRequired = recipeInfo["readyInMinutes"] as? Int {
            recipe.timeRequired = timeRequired
        }
        
//        var summary: String
//        var cuisines: [String]
        
        if let summary = recipeInfo["summary"] as? String {
            recipe.summary = summary
        }
        
        if let cuisines = recipeInfo["cuisines"] as? [String] {
            if cuisines.count == 0 {
                recipe.instructions = []
            } else {
                recipe.cuisines = cuisines
            }
        }
        
        if let instructions = recipeInfo["analyzedInstructions"] as? [[String : Any]]  {
            if instructions.count == 0 {
                recipe.instructions = []
            } else {
                var instructionsArray = [String]()
                for instructionSteps in instructions {
                    if let instructionSteps = instructionSteps["steps"] as? [[String : Any]] {
                        for step in instructionSteps {
                            if let instructionStep = step["step"] as? String {
                                instructionsArray.append(instructionStep)
                            }
                        }
                    }
                }
                recipe.instructions = instructionsArray
            }
        } else {
            recipe.instructions = []
        }
        return recipe
    }
    
    func getUserSearchHistory(id: Int, completion: @escaping (RecipeModel?, Bool, Error?) -> Void){
        var url: URL {
            var components = URLComponents()
            components.host = SpoonacularAPI.host
            components.path = "/recipes/\(id)/information"
            components.scheme = SpoonacularAPI.scheme
            
            components.queryItems = [URLQueryItem]()
            components.queryItems?.append(URLQueryItem(name: "apiKey", value: SpoonacularAPI.apiKey))
            
            return components.url!
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil, false, error)
                return
            }
            guard let data = data else {
                completion(nil, false, error)
                return
            }
            do {
                if let responseObject = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] {
                    let recipe = self.configureRecipe(recipeInfo: responseObject)
                    completion(recipe, true, nil)
                }
            } catch {
                completion(nil, false, error)
            }
            
        }
        task.resume()
    }
    
    
    func autoCompleteRecipeSearch(query: String, completion: @escaping ([SearchAutoComplete], Error?) -> Void) -> URLSessionTask {
        var searchURL: URL {
            var components = URLComponents()
            components.host = SpoonacularAPI.host
            components.path = "/recipes/autocomplete"
            components.scheme = SpoonacularAPI.scheme
            
            components.queryItems = [URLQueryItem]()
            components.queryItems?.append(URLQueryItem(name: "apiKey", value: SpoonacularAPI.apiKey))
            components.queryItems?.append(URLQueryItem(name: "number", value: "8"))
            components.queryItems?.append(URLQueryItem(name: "query", value: query))
            
            return components.url!
        }
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            guard let data = data else {
                completion([], error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode([SearchAutoComplete].self, from: data)
                completion(responseObject, nil)
            } catch {
                completion([], error)
            }
        }
        return task
    }
    
    func search(query: String, completion: @escaping ([SearchHistory], Bool, Error?) -> Void) {
        var searchURL: URL {
            var components = URLComponents()
            components.host = SpoonacularAPI.host
            components.path = "/recipes/complexSearch"
            components.scheme = SpoonacularAPI.scheme
            
            components.queryItems = [URLQueryItem]()
            components.queryItems?.append(URLQueryItem(name: "apiKey", value: SpoonacularAPI.apiKey))
            components.queryItems?.append(URLQueryItem(name: "number", value: "8"))
            components.queryItems?.append(URLQueryItem(name: "query", value: query))
            
            return components.url!
        }
        
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            guard let data = data else {
                completion([], false, error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(responseObject.results, true, nil)
            } catch {
                completion([], false, error)
            }
        }
        task.resume()
    }
    
    
}


