//
//  ContentView.swift
//  cocktails
//
//  Created by Artyom Danilov on 11.02.2022.
//

import SwiftUI

let THE_WIDTH = CGFloat(390)

struct ContentView: View {
  @EnvironmentObject var network: Network
  
  var body: some View {
    NavigationView {
      ZStack {
        VStack(spacing: -25) {
          if let cocktail = network.cocktail {
            AsyncImage(url: URL(string: cocktail.strDrinkThumb)) { image in
              image.resizable()
            } placeholder: {
              ProgressView()
            }
            .frame(width: THE_WIDTH, height: 390)
            
            VStack {
              Heading(children: cocktail.strDrink)
              
              RoundedRectangle(cornerRadius: 100)
                .frame(width: 350, height: 5)
                .foregroundColor(Color.ui.primary)
              
              Text(cocktail.strCategory)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.horizontal, 5)
                .font(.system(size: 22))
              
              Text(cocktail.strAlcoholic)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.horizontal, 5)
                .font(.system(size: 22))
              
              Spacer()
              
              VStack {
                NavigationLink(destination: IngredientsView(cocktail: cocktail)) {
                  Text("Show ingredients")
                    .foregroundColor(Color.ui.primary)
                }
                Button(action: network.fetchCocktail) {
                  Text("Next cocktail")
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .foregroundColor(Color.ui.background)
                .background(Color.ui.primary)
                .clipShape(Capsule())
              }
              .font(.system(size: 25))
              .padding(.bottom, 20)
            }
            
            .background(Color.ui.background)
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
          }
          Spacer()
        }
        
        VStack {
          Button(action: {}) {
            Text("+")
          }
          .padding(25)
          .foregroundColor(.white)
          .background(Color.ui.primary)
          .clipShape(Circle())
          .font(.system(size: 30))
          .frame(maxWidth: 325, alignment: .trailing)
          
          Spacer().frame(height: 50)
        }
      }
      .navigationBarHidden(true)
    }
    .onAppear(perform: network.fetchCocktail)
  }
}

struct Heading: View {
  var children: String
  var body: some View {
      Text(children)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .padding(.top, 10)
        .padding(.horizontal, 5)
        .font(.system(size: 32))
  }
}


struct IngredientsView: View {
  var cocktail: Cocktail
  
  var body: some View {
    VStack {
      Heading(children: cocktail.strDrink)
      Text(cocktail.strInstructions)
      ScrollView {
        ForEach(cocktail.getIngredients()) {
          AsyncImage(url: URL(string: $0.getImageURL())) { image in
            image.resizable()
          } placeholder: {
            ProgressView()
          }
          .frame(width: 50, height: 50)
          Text("\($0.name) - \($0.measure)")
        }
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(Network())
  }
}

func test() {
  //
}
