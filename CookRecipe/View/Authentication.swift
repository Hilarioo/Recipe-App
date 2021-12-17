//
//  Auth.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 11/25/21.
//

import SwiftUI


struct Authentication: View {
    
    let authenticated: () -> ()
    
    @State private var returningUser = true //begin at "signin" picker
    @State private var authStatusMessage = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""

    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    // chef image
                    Image("auth")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    // toggle picker with style SegmentedPickerStyle
                    Picker(selection: $returningUser, label: Text("Auth Picker")) {
                        Text("Sign In")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        
                    // new user input fields
                    if (!returningUser) {
                        Group {
                            TextField("First Name", text: $firstName)
                            TextField("Last Name", text: $lastName)
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("Password", text: $password)
                        }
                        .padding(12)
                        .background(Color.white)
                        
                    }
                    else {
                        // returning user input fields
                        Group {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("Password", text: $password)
                        }
                        .padding(12)
                        .background(Color.white)
                    }
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(returningUser ? "Sign In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(Color(#colorLiteral(red: 0.168627451, green: 0.2784313725, blue: 0.5450980392, alpha: 1)))
                        .cornerRadius(10)
                    }
                    
                    // displays auth status to user once they click button
                    Text(self.authStatusMessage)
                        .foregroundColor(.red)
                    
                }
                .padding()
                
            }
            .navigationTitle("Welcome")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // handle submission for logging in
    private func handleAction() {
        if returningUser {
            // creates new account with provided email & password (stored in Firebase)
            signin()
        } else {
            // creates new account with provided email & password (stored in Firebase)
            createAccount()
        }
    }
    
    // signin
    private func signin() {
        FirebaseManager.sharedInstance.auth.signIn(withEmail: self.email, password: self.password) {
            res, err in
            if let err = err {
                self.authStatusMessage = "Failed: \(err.localizedDescription)"
                return
            }
            
            print("Successful login")
            self.authStatusMessage = "Successful Login"
            // if authentication successful, proceed to discover view
            self.authenticated()
            
        }
    }
    
    
    // creates new account
    private func createAccount() {
        FirebaseManager.sharedInstance.auth.createUser(withEmail: self.email, password: self.password) {
            res, err in
            if let err = err {
                print("Failed creatng user. Error:", err)
                // updates err message to user
                self.authStatusMessage = "Failed: \(err.localizedDescription)"
                return
            }
            // store new user name and credentials in a collection
            storeUserInfo(newUserId: res?.user.uid ?? "")
            print("Successfully created user: \(res?.user.uid ?? "")")
        }
    }
    
    // associate user first and last name to their login credentials
    private func storeUserInfo(newUserId: String) {
        
        // obtain current user unique ID
        guard let uid = FirebaseManager.sharedInstance.auth.currentUser?.uid else {
            return }
        
        let userData = ["uid": uid, "email": self.email, "firstName": self.firstName, "lastName": self.lastName]
        
        FirebaseManager.sharedInstance.firestore.collection("users").document(uid).setData(userData) { err in
            if let err = err {
                print(err)
                self.authStatusMessage = "Failed: \(err.localizedDescription)"
                return
            }
        }
        // if authentication successful, proceed to discover view
        self.authenticated()
    }
}


struct Authentication_Preview: PreviewProvider {
    static var previews: some View {
        Authentication(authenticated: {})
    }
}
