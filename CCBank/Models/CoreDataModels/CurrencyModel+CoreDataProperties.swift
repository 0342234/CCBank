//
//  CurrencyModel+CoreDataProperties.swift
//  
//
//  Created by Yaroslav Bosenko on 08.03.2018.
//
//

import Foundation
import CoreData


extension CurrencyModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyModel> {
        return NSFetchRequest<CurrencyModel>(entityName: "CurrencyModel")
    }

    @NSManaged public var available_supply: Double
    @NSManaged public var id: String?
    @NSManaged public var last_updated: Int64
    @NSManaged public var market_cap_usd: Double
    @NSManaged public var max_supply: Double
    @NSManaged public var name: String?
    @NSManaged public var price_usd: Double
    @NSManaged public var rank: Int64
    @NSManaged public var symbol: String?
    @NSManaged public var total_supply: Double
    @NSManaged public var grouped: GroupedCurrencies?

}
