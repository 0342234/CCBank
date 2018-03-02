//
//  CryptoCurrenciesDataManger.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 22.12.2017.
//  Copyright © 2017 no-organiztaion-name. All rights reserved.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    var data = [CurrenciesAPIModel]()
    
    let urlString = "https://api.coinmarketcap.com/v1/ticker/?limit=100"
    
    private init() { }
    
    func fetchData(completion: @escaping ([CurrenciesAPIModel]) -> Void) {
        guard let url = URL(string: urlString) else { print("Error ocured when uwrapping url"); return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { print("DATA = NIL"); return }
            do {
                let decodedData = try JSONDecoder().decode([CurrenciesAPIModel].self, from: unwrappedData)
                self.data = decodedData
                completion(decodedData)
            }
            catch  {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
