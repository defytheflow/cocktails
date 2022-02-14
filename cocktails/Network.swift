//
//  Network.swift
//  cocktails
//
//  Created by Artyom Danilov on 11.02.2022.
//

import SwiftUI

class Network: ObservableObject {
  @Published var cocktail: Cocktail? = nil

  func fetchCocktail() {
    guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/random.php") else { fatalError("Missing URL") }
    let urlRequest = URLRequest(url: url)

    let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      if let error = error {
        print("Request error:", error)
        return
      }

      guard let response = response as? HTTPURLResponse else { return }

      if response.statusCode == 200 {
        guard let data = data else { return }
        DispatchQueue.main.async {
          do {
            let decoder = JSONDecoder()
            let cocktailData = try decoder.decode(CocktailData.self, from: data)
            self.cocktail = cocktailData.drinks[0]
            print("Fetched cocktail", self.cocktail)
          } catch let error {
            print("Error decoding:", error)
          }
        }
      }
    }

    dataTask.resume()
  }
}

struct CocktailData: Decodable {
  let drinks: [Cocktail]
}

struct Cocktail: Decodable {
  let idDrink: String
  let strDrink: String
  let strCategory: String
  let strAlcoholic: String
  let strGlass: String
  let strInstructions: String
  let strDrinkThumb: String

  let strIngredient1: String?
  let strIngredient2: String?
  let strIngredient3: String?
  let strIngredient4: String?
  let strIngredient5: String?
  let strIngredient6: String?
  let strIngredient7: String?
  let strIngredient8: String?
  let strIngredient9: String?
  let strIngredient10: String?
  let strIngredient11: String?
  let strIngredient12: String?
  let strIngredient13: String?
  let strIngredient14: String?
  let strIngredient15: String?

  let strMeasure1: String?
  let strMeasure2: String?
  let strMeasure3: String?
  let strMeasure4: String?
  let strMeasure5: String?
  let strMeasure6: String?
  let strMeasure7: String?
  let strMeasure8: String?
  let strMeasure9: String?
  let strMeasure10: String?
  let strMeasure11: String?
  let strMeasure12: String?
  let strMeasure13: String?
  let strMeasure14: String?
  let strMeasure15: String?

  func getIngredients() -> [Ingredient] {
    // This is pure masterpiece.
    var ingredients: [Ingredient] = []

    if let n = strIngredient1,  let m =  strMeasure1 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient2,  let m =  strMeasure2 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient3,  let m =  strMeasure3 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient4,  let m =  strMeasure4 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient5,  let m =  strMeasure5 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient6,  let m =  strMeasure6 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient7,  let m =  strMeasure7 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient8,  let m =  strMeasure8 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient9,  let m =  strMeasure9 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient10, let m = strMeasure10 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient11, let m = strMeasure11 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient12, let m = strMeasure12 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient13, let m = strMeasure13 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient14, let m = strMeasure14 { ingredients.append(Ingredient(name: n, measure: m)) }
    if let n = strIngredient15, let m = strMeasure15 { ingredients.append(Ingredient(name: n, measure: m)) }

    return ingredients
  }
}

struct Ingredient: Identifiable {
  let name: String
  let measure: String
  let id = UUID()
  
  func getImageURL() -> String {
    return "https://www.thecocktaildb.com/images/ingredients/\(name)-Small.png".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  }
}
