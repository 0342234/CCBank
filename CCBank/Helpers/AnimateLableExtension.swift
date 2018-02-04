//
//  AnimateLableExtension.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 17.01.2018.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}
