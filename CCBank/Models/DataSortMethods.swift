//
//  DataSortMethods.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 3/1/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation
import CoreData

struct DataSort {
    static func sortDataSource(data: [CurrenciesAPIModel], completion: @escaping (([CurrenciesAPIModel], [CurrenciesAPIModel] )) -> Void) {
        
        var favoriteData: [CurrenciesAPIModel] = [CurrenciesAPIModel]()
        var notFavoriteData: [CurrenciesAPIModel] = data
        var favoriteCurrencies: [String] = []
        
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
            return
        }
        
        for favoriteCurrency in favoriteCurrencies {
            for (index, object) in notFavoriteData.enumerated() where object.name == favoriteCurrency {
                let removedObject = notFavoriteData.remove(at: index)
                favoriteData.append(removedObject)
            }
        }
        completion((favoriteData, notFavoriteData))

    }
}
