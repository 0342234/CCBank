//
//  CryptoCurrenciesDataManger.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 22.12.2017.
//  Copyright © 2017 no-organiztaion-name. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class DataManager {
    static let shared = DataManager()
    
    var data = [CurrenciesAPIModel]()
    var favoriteData: [CurrenciesAPIModel] = [CurrenciesAPIModel]()
    var notFavoriteCurrentData: [CurrenciesAPIModel] = [CurrenciesAPIModel]()
    let urlString = "https://api.coinmarketcap.com/v1/ticker/?limit=100"
    
    private init() { }
    
    func fetchData(withSorting: Bool, completion: @escaping () -> Void) {
        guard let url = URL(string: urlString) else { print("Error ocured when uwrapping url"); return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else {
                if var rootController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = rootController.presentedViewController {
                        rootController = presentedViewController
                    }
                    
                    // topController should now be your topmost view controller
                }
                print("Error getting data")
                
                return
            }
            do {
                let decodedData = try JSONDecoder().decode([CurrenciesAPIModel].self, from: unwrappedData)
                self.data = decodedData
                if withSorting {
                    self.notFavoriteCurrentData = decodedData
                    self.sortDataSource(completion: { completion() } )
                } else {
                    return
                }
            }
            catch  {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func sortDataSource(completion: @escaping () -> Void) {
        var favoriteCurrencies: [String] = []
        favoriteData = []
        let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteCurrencies")
        let moc = PersistenceService.context
        do {
            let results = try moc.fetch(fetchedRequest)
            for result in results as! [FavoriteCurrencies] {
                favoriteCurrencies.append(result.currencies )
            }
        } catch  {
            print(error)
        }
        
        if favoriteCurrencies.isEmpty {
            favoriteData = []
            completion()
            return
        }
        
        for favoriteCurrency in favoriteCurrencies {
            for (index, object) in notFavoriteCurrentData.enumerated() where object.name == favoriteCurrency {
                let removedObject = notFavoriteCurrentData.remove(at: index)
                favoriteData.append(removedObject)
                completion()
            }
        }
    }
}
