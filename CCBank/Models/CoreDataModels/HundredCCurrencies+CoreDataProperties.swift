//
//  HundredCCurrencies+CoreDataProperties.swift
//  
//
//  Created by Yaroslav Bosenko on 24.01.2018.
//
//

import Foundation
import CoreData


extension HundredCCurrencies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HundredCCurrencies> {
        return NSFetchRequest<HundredCCurrencies>(entityName: "HundredCCurrencies")
    }

    @NSManaged public var capitalization: String?
    @NSManaged public var dailyPercentChanges: String?
    @NSManaged public var hourPercentChanges: String?
    @NSManaged public var name: String
    @NSManaged public var rank: String
    @NSManaged public var usdValue: String
    @NSManaged public var grouped: GroupedCurrencies

}
