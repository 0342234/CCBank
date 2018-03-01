//
//  WidthCalculationExtension.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 2/28/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit

extension String {
    func SizeOf_String( font: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttribute)
        return size
    }
}
