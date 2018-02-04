//
//  GroupedCurrencies+CoreDataProperties.swift
//  
//
//  Created by Yaroslav Bosenko on 24.01.2018.
//
//

import Foundation
import CoreData


extension GroupedCurrencies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupedCurrencies> {
        return NSFetchRequest<GroupedCurrencies>(entityName: "GroupedCurrencies")
    }

    @NSManaged public var addingDate: NSDate
    @NSManaged public var hundredCurrencies: NSSet?

}

// MARK: Generated accessors for hundredCurrencies
extension GroupedCurrencies {

    @objc(addHundredCurrenciesObject:)
    @NSManaged public func addToHundredCurrencies(_ value: HundredCCurrencies)

    @objc(removeHundredCurrenciesObject:)
    @NSManaged public func removeFromHundredCurrencies(_ value: HundredCCurrencies)

    @objc(addHundredCurrencies:)
    @NSManaged public func addToHundredCurrencies(_ values: NSSet)

    @objc(removeHundredCurrencies:)
    @NSManaged public func removeFromHundredCurrencies(_ values: NSSet)

}
