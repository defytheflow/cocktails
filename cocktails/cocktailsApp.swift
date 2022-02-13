//
//  cocktailsApp.swift
//  cocktails
//
//  Created by Artyom Danilov on 11.02.2022.
//

import SwiftUI

extension Color {
  static let ui = Color.UI()
  
  struct UI {
    let primary = Color("color.primary")
    let background = Color("color.background")
  }
}

@main
struct cocktailsApp: App {
    var network = Network()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
        }
    }
}
