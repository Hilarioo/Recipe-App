//
//  ContentView.swift
//  CookRecipe
//
//  Created by Jose Gonzalez on 12/7/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Discover()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
            Favorites()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
