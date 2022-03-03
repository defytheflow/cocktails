//
//  ContentView.swift
//  cocktails
//
//  Created by Artyom Danilov on 11.02.2022.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var network: Network
  @StateObject private var store = Storage()
  @Environment(\.scenePhase) private var scenePhase
  
  var body: some View {
    NavigationView {
      GeometryReader{meta in
        let frame = meta.frame(in: .global)
        
        ZStack {
          VStack(spacing: -25) {
            
            if let cocktail = network.cocktail {
              AsyncImage(url: URL(string: cocktail.strDrinkThumb)) { image in
                image.resizable()
              } placeholder: {
                ProgressView()
              }
              .frame(width: frame.size.width, height: frame.size.width)
              
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
                  NavigationLink(destination: IngredientsView(cocktail: cocktail, metaWidth: frame.size.width)) {
                    Text("Show ingredients")
                      .foregroundColor(Color.ui.primary)
                  }
                  NavigationLink(destination: FavoritesView(favorites: store.favorites, onDelete: { id in
                    if let index = store.favorites.firstIndex(of: id) {
                      store.favorites.remove(at: index)
                    }
                  })) {
                    Text("Favorites")
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
              
              Spacer()
              
              VStack {
                Button(action: { store.favorites.append(cocktail.idDrink) }) {
                  Text(store.favorites.contains(cocktail.idDrink) ? "-" : "+")
                }
                .padding(25)
                .foregroundColor(.white)
                .background(Color.ui.primary)
                .clipShape(Circle())
                .font(.system(size: 30))
                .frame(maxWidth: (frame.size.width - 55), alignment: .trailing)
                
                Spacer().frame(height: 50)
              }
            }
          }
        }
        .navigationBarHidden(true).background(Color.ui.background)
      }
    }
    .onAppear {
      network.fetchCocktail()
      Storage.load { result in
        switch result {
        case .failure(let error):
          fatalError(error.localizedDescription)
        case .success(let favorites):
          store.favorites = favorites
        }
      }
    }
    .onChange(of: scenePhase) { phase in
      if phase == .inactive {
        Storage.save(favorites: store.favorites) { result in
          if case .failure(let error) = result {
            fatalError(error.localizedDescription)
          }
        }
      }
    }
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

struct FavoritesView: View {
  var favorites: [String]
  var onDelete: (String) -> Void
  
  var body: some View {
    ScrollView {
      ForEach(favorites, id: \.self) { i in
        HStack {
          Text(i)
          Button(action: { onDelete(i) }) {
            Text("del")
          }
        }
      }
    }
  }
}

struct IngredientsView: View {
  @State private var offset: CGFloat = 0
  
  var cocktail: Cocktail
  var metaWidth: CGFloat
  
  
  var body: some View {
    VStack {
      Heading(children: cocktail.strDrink)
      Text(cocktail.strInstructions)
      VStack {
        Capsule().foregroundColor(Color.white).frame(width: 100, height: 7).padding(.top, 7)
        ScrollView {
          ForEach(cocktail.getIngredients()) { i in
            VStack {
              HStack {
                AsyncImage(url: URL(string: i.getImageURL())) { image in
                  image.resizable()
                } placeholder: {
                  ProgressView()
                }
                .frame(width: 100, height: 100)
                Spacer()
                Text("\(i.name) - \(i.measure)").font(.system(size: 22)).padding(15)
              }.frame(width: metaWidth)
              RoundedRectangle(cornerRadius: 100)
                .frame(width: 350, height: 2)
                .foregroundColor(Color.ui.text)
            }
          }
        }
      }.background(Color.ui.primary).clipShape(RoundedRectangle(cornerRadius: 20.0)).offset(y: offset).gesture(DragGesture().onChanged{
        value in
        let startLocation = value.startLocation
        offset = startLocation.y + value.translation.height
      })
    }.background(Color.ui.background)
  }
}


//struct DrawerView: View {
//    var body: some View {
//        VStack {
//            Capsule().foregroundColor(Color.white).frame(width: 100, height: 7).padding(.top, 7)
//
//        }
//    }
//}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(Network())
  }
}
