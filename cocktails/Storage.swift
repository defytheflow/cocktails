//
//  Storage.swift
//  pocketBar
//
//  Created by Artyom Danilov on 03.03.2022.
//

import Foundation
import SwiftUI

class Storage: ObservableObject {
  @Published var favorites: [String] = []
  
  private static func fileURL() throws -> URL {
    try FileManager.default.url(for: .documentDirectory,
                                in: .userDomainMask,
                                appropriateFor: nil,
                                create: false)
      .appendingPathComponent("cocktails.data")
  }
  
  static func load(completion: @escaping (Result<[String], Error>) -> Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let fileURL = try fileURL()
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
          DispatchQueue.main.async {
            completion(.success([]))
          }
          return
        }
        let favorites = try? JSONSerialization.jsonObject(with: file.availableData, options: []) as? [String]
        DispatchQueue.main.async {
          completion(.success(favorites!))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
  
  static func save(favorites: [String], completion: @escaping (Result<Int, Error>) -> Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let data = try JSONEncoder().encode(favorites)
        let outfile = try fileURL()
        try data.write(to: outfile)
        DispatchQueue.main.async {
          completion(.success(favorites.count))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
}

