//
//  User.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 12/16/21.
//

import Foundation

struct User {
    let uid, email, firstName, lastName: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.firstName = data["firstName"] as? String ?? ""
        self.lastName = data["lastName"] as? String ?? ""
    }
}
