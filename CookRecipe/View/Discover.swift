//
//  Search.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 12/7/21.
//

import SwiftUI

// styling for search bar
struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .cornerRadius(50)
            .shadow(color: .gray, radius: 2)
    }
}

//fetch URLImage
struct URLImage: View {
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 110)
        }
        else {
            Image("missing-picture")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: 110)
                .onAppear {
                    fetchImage()
                }
        }
    }
    
    private func fetchImage() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, _, _ in
            self.data = data
        }
        task.resume()
    }
}

struct Discover: View {
    
    @State var search = ""
    @State var favorite = true
    @State var settingsActive = false
    @State var showRecipeModal = false
    @ObservedObject private var discoverModel = DiscoverModel()
    @StateObject var spoonacularAPI = SpoonacularAPI()
    
    var body: some View {
            ScrollView {
                VStack {
                    // logo + signout btn
                    HStack {
                        Image("logo")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding()
                        Spacer()
                        Button {
                            settingsActive.toggle()
                        } label: {
                            Image("setting")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                        }
                        
                    }
                    .padding()
                    .actionSheet(isPresented: $settingsActive) {
                        .init(title: Text("Settings"), message: Text("What do you want to do?"),
                              buttons: [
                                .destructive(Text("Sign Out"), action: {
                                    discoverModel.handleSignOut()
                                    
                                }),
                                .cancel()
                              ])
                    }
                    .fullScreenCover(isPresented: $discoverModel.userLoggedOut, onDismiss: nil) {
                        Authentication(authenticated: {
                            self.discoverModel.userLoggedOut = false
                            self.discoverModel.fetchCurrentUser()
                        })
                    } 
                    
                    
                    
                    // search bar
                    HStack {
                        TextField("Search Recipe. . . .", text: $search)
                    }
                    .textFieldStyle(OvalTextFieldStyle())
                    .padding()
                    
                    // cuisine square - scroll right to view all
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<26, id: \.self) { num in
                                Text("Vietnamese")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .frame(width: 122, height: 75)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))).padding(.init(top: 25, leading: 20, bottom: 25, trailing: 0))
                            }
                        }
                    }
                    // trending text
                    Text("Trending")
                        .onAppear {
                            spoonacularAPI.getRandomRecipe()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .font(.system(size: 24, weight: .bold))
                    
                    // show 10 random recipes
                    ForEach(spoonacularAPI.recipes, id: \.self) { recipe in
                        // first cell
                        HStack {
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .shadow(color: .gray, radius: 2)
                                .padding(.bottom, 15)
                                .frame(width: 160, height: 275)
                                .overlay(
                                    VStack {
                                        // recipe image
                                        URLImage(urlString: recipe.imageURL!)
                                        
                                        HStack {
                                            
                                            VStack {
                                                Text(recipe.title!)
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                                    .lineLimit(2)
                                                    .truncationMode(.tail)
                                                    .padding(.leading, 12)
                                                    .padding(.bottom, 15)
                                            
                                                Text("\(recipe.servings!) serving size")
                                                    .font(.system(size: 12))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.leading, 12)
                                                Text("\(recipe.timeRequired!) mins")
                                                    .font(.system(size: 10))
                                                    .foregroundColor(.gray)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.leading, 12)
                                            }
                                            
                                            // right: heart
                                            if (favorite) {
                                                Image("favorite")
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                    .padding(.trailing, 7)
                                            }
                                            else {
                                                Image("non-favorite")
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                    .padding(.trailing, 7)
                                            }
                                            
                                        }
                                        
                                        Spacer()
                                        
                                        // button
                                        Button (action: {
                                            //trigger recipe modal
                                            self.showRecipeModal.toggle()
                                        }, label: {
                                            HStack {
                                                Spacer()
                                                Text("View Recipe")
                                                    .foregroundColor(.white)
                                                    .padding(.vertical, 7)
                                                    .font(.system(size: 14, weight: .semibold))
                                                Spacer()
                                            }
                                            .background(Color(#colorLiteral(red: 0.3294117647, green: 0.7803921569, blue: 0.5098039216, alpha: 1)))
                                            .cornerRadius(50)
                                        })
                                        .padding()
                                        .frame(width: 150, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        
                                        Spacer()
                                    })
                            
                            Spacer()
                            

                        } // end of Hstack cell
                        .fullScreenCover(isPresented: $showRecipeModal, content: {
                            Button(action: {
                                self.showRecipeModal.toggle()
                            }, label: {
                                Text("close")
                            })
                            
                            Recipe(title: recipe.title!, image: recipe.imageURL!, timeRequired: recipe.timeRequired!, sourceURL: recipe.sourceURL!, ingredients: recipe.ingredients!, instructions: recipe.instructions!, servings: recipe.servings!, summary: recipe.summary!)
                            
                        })
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }

}



struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Discover()
    }
}
