//
//  FavoriteCurrencies+CoreDataProperties.swift
//  
//
//  Created by Yaroslav Bosenko on 24.01.2018.
//
//

import Foundation
import CoreData


extension FavoriteCurrencies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCurrencies> {
        return NSFetchRequest<FavoriteCurrencies>(entityName: "FavoriteCurrencies")
    }

    @NSManaged public var currencies: String

}
