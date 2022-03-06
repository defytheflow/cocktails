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
                    NavigationLink(destination: IngredientView(cocktail: cocktail, metaWidth: frame.size.width, metaHeight: frame.size.height)) {
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
              }.background(Color.ui.background)
              .clipShape(RoundedRectangle(cornerRadius: 20.0))
                
               
                
            }
          }
            if let cocktail = network.cocktail {
                Button(action: { store.favorites.append(cocktail.idDrink) }) {
                    Text(store.favorites.contains(cocktail.idDrink) ? "💔" : "❤️")
                }
                .padding(15)
                .background(Color.ui.primary)
                .clipShape(Circle())
                .font(.system(size: 30))
                .shadow(radius: 1)
                .position(x: frame.size.width - 55, y: frame.size.height / 2.1 )
                
                NavigationLink(destination: FavoritesView(favorites: store.favorites, onDelete: { id in
                  if let index = store.favorites.firstIndex(of: id) {
                    store.favorites.remove(at: index)
                  }
                })) {
                    Text("⭐️").font(.system(size: 30)).padding(15)
                }.background(Color.ui.primary).shadow( radius: 1).clipShape(Circle()).position(x: frame.size.width - 50, y: frame.size.height * 0.05)
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

struct IngredientView: View {
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
  var cocktail: Cocktail
  var metaWidth: CGFloat
  var metaHeight: CGFloat
    
    var body: some View {
        ZStack {
            VStack {
      Heading(children: cocktail.strDrink)
                RoundedRectangle(cornerRadius: 100)
                  .frame(width: 350, height: 5)
                  .foregroundColor(Color.ui.primary).padding(.bottom, 10)
                Text(cocktail.strInstructions).font(.system(size: 22)).padding(.horizontal, 7)
                //Text(offset.description)
                //Text(lastOffset.description)
                //Text(gestureOffset.description)
                Spacer()
            }
            VStack {
                Capsule().foregroundColor(Color.black).frame(width: 100, height: 7).padding(10)
                ScrollView {
                    ForEach(cocktail.getIngredients()) { i in
                      VStack {
                        HStack {
                          AsyncImage(url: URL(string: i.getImageURL())) { image in
                            image.resizable()
                          } placeholder: {
                            ProgressView()
                          }
                          .frame(width: 75, height: 75).padding(.leading, 15)
                          Spacer()
                            Text("\(i.name) - \(i.measure)").font(.system(size: 22)).padding(.trailing, 25)
                        }
                        // Looks like its better without it
                          
                        //RoundedRectangle(cornerRadius: 100)
                        //  .frame(width: 300, height: 2)
                        //  .foregroundColor(Color.ui.text)
                        //  .padding(.bottom, 10)
                      }.padding(.top, 20)
                    }
                // Height parameter should change with the offset
                // You should be able to scroll all ingredients indep of height
                }.frame(width: metaWidth)
                // Drag starting position needs to be adjusted based on the height of the instructions block
                // Limit the min height by maxHeight - 200
                // Going back and returning should leave the drag on the same location
            }.background(Color.ui.primary).clipShape(RoundedRectangle(cornerRadius: 20.0)).offset(y: metaHeight - 200).offset(y: offset).gesture(DragGesture().updating($gestureOffset, body: {
                value, out, _ in
                out = value.translation.height
            }).onChanged({
                value in
                // Ensures smooth drag
                DispatchQueue.main.async {
                offset = gestureOffset + lastOffset
                }
            }).onEnded({
                value in
                lastOffset = offset
            }))
        // Removes white space used for the title
        // Using Heading ensured style consistency
        }.navigationBarTitle(Text(""), displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(Network())
  }
}
