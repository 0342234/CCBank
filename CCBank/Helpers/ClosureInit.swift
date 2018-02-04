//
//  ClosureInit.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 2/2/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation
import UIKit

protocol ClosureInit {}
extension NSObject: ClosureInit {}
extension ClosureInit where Self : NSObject {
    init(closure: (Self) -> Void) {
        self.init()
        closure(self)
    }
}
