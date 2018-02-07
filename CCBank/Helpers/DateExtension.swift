//
//  DateExtension.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 10.01.2018.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation

extension NSDate {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}

extension Date {
    func currentTimestamp() -> Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }
}
