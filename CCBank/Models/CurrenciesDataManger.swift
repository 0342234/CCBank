//
//  CryptoCurrenciesDataManger.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 22.12.2017.
//  Copyright © 2017 no-organiztaion-name. All rights reserved.
//

import Foundation
import CoreData

final class DataManager {
    static let shared = DataManager()
    
    var data = [CurrenciesModel]()
    var favoriteData: [CurrenciesModel] = [CurrenciesModel]()
    var notFavoriteCurrentData: [CurrenciesModel] = [CurrenciesModel]()
    let urlString = "https://api.coinmarketcap.com/v1/ticker/?limit=100"
    
    private init() {
        
    }
    
    func fetchCurrencyUrl(withSorting: Bool, completion: @escaping () -> Void) {
        guard let url = URL(string: urlString) else { print("Error ocured when uwrapping url"); return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { print("Error getting data"); return }
            do {
                let decodedData = try JSONDecoder().decode([CurrenciesModel].self, from: unwrappedData)
                self.data = decodedData
                if withSorting != true {
                    return
                } else {
                    self.notFavoriteCurrentData = decodedData
                    self.sortDataSource( completion: { completion() } )
                }
            }
            catch  {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    func sortDataSource(completion: @escaping () -> Void) {
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
