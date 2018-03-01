//
//  CurrenciesModel.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 10.01.2018.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation

struct CurrenciesAPIModel: Decodable {
    let id: String
    let name: String
    let symbol: String
    let price_usd: String
    let rank: String
    let percent_change_1h: String?
    let percent_change_24h: String?
    let percent_change_7d: String?
    let market_cap_usd: String
    let available_supply: String?
    let total_supply: String?
    let last_updated: String
    let max_supply: String?
}
