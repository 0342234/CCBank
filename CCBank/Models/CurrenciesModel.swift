//
//  CurrenciesModel.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 10.01.2018.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation

struct CurrenciesModel: Decodable {
    let name: String
    let symbol: String
    let price_usd: String
    let last_updated: String
    let rank: String
    let percent_change_1h: String?
    let percent_change_24h: String?
    let available_supply: String?
}
