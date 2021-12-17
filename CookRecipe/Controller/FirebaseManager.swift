//
//  FirebaseManager.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 12/16/21.
//

import Foundation

import Firebase


class FirebaseManager: NSObject {
    
    let auth: Auth
    let firestore: Firestore
    let storage: Storage
    
    // singleton object
    static let sharedInstance = FirebaseManager()
    
    // init to construct FirebaseManager
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
        
        super.init()
    }
}
