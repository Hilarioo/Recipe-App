//
//  DiscoverModel.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 12/16/21.
//

import Foundation
import SDWebImageSwiftUI

class DiscoverModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var mainUser: User?
    @Published var userLoggedOut = false
    @Published var api = SpoonacularAPI()
    
    init() {
        
        DispatchQueue.main.async {
            self.userLoggedOut = FirebaseManager.sharedInstance.auth.currentUser?.uid == nil
            // check if user is logged out. if so, prompt auth screen 

        }
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        
        guard let uid = FirebaseManager.sharedInstance.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        
        FirebaseManager.sharedInstance.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
                
            }
            
            self.mainUser = .init(data: data)
            
        }
    }
    
    
    func handleSignOut() {
        userLoggedOut.toggle()
        try? FirebaseManager.sharedInstance.auth.signOut()
    }
    
}
