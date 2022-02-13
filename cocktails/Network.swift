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
    var drinks: [Cocktail]
}

struct Cocktail: Decodable {
    var idDrink: String
    var strDrink: String
    var strCategory: String
    var strAlcoholic: String
    var strGlass: String
    var strInstructions: String
    var strDrinkThumb: String
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
}
