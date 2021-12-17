//
//  Recipe.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 12/7/21.
//

import SwiftUI

//fetch URLImage
struct URLImageRecipe: View {
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        else {
            Image("missing-picture")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 25))
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

struct Recipe: View {
    
    let title: String
    let image: String
    let timeRequired: Int
    let sourceURL: String
    let ingredients: [String]
    let instructions: [String]
    let servings: Int
    let summary: String
//    let cuisines: [String]
//
    var body: some View {
        ScrollView {
            VStack {
                
                // recipe image
                URLImageRecipe(urlString: image)
                    
                
                Spacer()
                
                // recipe name & heart
                HStack {
                    Text(title)
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.init(top: 0, leading: 35, bottom: 0, trailing: 0))
                    
                    Image("favorite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 35)
                        .padding(.trailing, 35)
                }
                .padding(.top, 35)
                
                Text("Cuisine")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.init(top: 0, leading: 35, bottom: 20, trailing: 0))
                
                // recap
                Text("Recipe Highlights")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.init(top: 15, leading: 35, bottom: 20, trailing: 0))
                
                
                HStack {
                    
                    Spacer()
                    
                    // calories
                    VStack {
                        Text("\(timeRequired)")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 24))
                        Text("MINUTES")
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0.3411764706, green: 0.7490196078, blue: 0.4549019608, alpha: 1)))
                    
                    Spacer()
                    
                    // carbs
                    VStack {
                        Text("\(servings)")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 24))
                        Text("SERVINGS")
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0.3411764706, green: 0.7490196078, blue: 0.4549019608, alpha: 1)))
                    
                    
                    Spacer()
                }
                
                
                // summary collapsible
//                Collapsible(
//                    label: {Text("Summary").font(.system(size: 18)).fontWeight(.semibold)},
//                    content: {
//                        VStack {
//                            Text("\(summary)")
//                        }
//                        .frame(
//                              minWidth: 0,
//                              maxWidth: .infinity,
//                              minHeight: 0,
//                              maxHeight: .infinity,
//                              alignment: .topLeading
//                            )
//                        .padding()
//                        .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)))
//
//                    })
//                    .padding(.init(top: 45, leading: 35, bottom: 25, trailing: 35   ))
//
                
                // summary collapsible
                Collapsible(
                    label: {Text("Ingredients").font(.system(size: 18)).fontWeight(.semibold)},
                    content: {
                        VStack {
                            ForEach(ingredients, id: \.self) { ingredient in
                                Text("\(ingredient)").padding(.bottom, 10)
                            }
                        }
                        .frame(
                              minWidth: 0,
                              maxWidth: .infinity,
                              minHeight: 0,
                              maxHeight: .infinity,
                              alignment: .topLeading
                            )
                        .padding()
                        .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)))
                        
                    })
                    .padding(.init(top: 45, leading: 35, bottom: 25, trailing: 35   ))
                
                
                
                
                // instructions collapsible
                Collapsible(
                    label: {Text("Instructions").font(.system(size: 18)).fontWeight(.semibold)},
                    content: {
                        VStack {
                            ForEach(instructions, id: \.self) { instruction in
                                Text("\(instruction)").padding(.bottom, 10)
                            }
                        }
                        .frame(
                              minWidth: 0,
                              maxWidth: .infinity,
                              minHeight: 0,
                              maxHeight: .infinity,
                              alignment: .topLeading
                            )
                        .padding()
                        .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)))
                        
                    })
                    .padding(.init(top: 0, leading: 35, bottom: 25, trailing: 35   ))
                
            }
            
        }
            
    }
}






struct Recipe_Previews: PreviewProvider {
    static var previews: some View {
//        sourceURL: "", ingredients: [""], instructions: [""], serving: 0, summary: "", cuisines: [""])
        Recipe(title: "Recipe Name", image: "", timeRequired: 0, sourceURL: "", ingredients: [""], instructions: [""], servings: 0, summary: "")
    }
}
