//
//  LaunchScreenController.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 02.01.2018.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class InitialViewController: UIViewController  {
    
    @IBOutlet weak var mainView: UIView!
    
    var gameTimer: Timer!
    var semiCircleLayer = CAShapeLayer()
    
    let radius = 105
    
    let startAngel = CGFloat( -Double.pi / 2)
    var endAngel = CGFloat( -Double.pi / 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        self.view.layer.addSublayer(semiCircleLayer)
    }
    
    @objc func runTimedCode() {
        
        endAngel = endAngel + CGFloat(Double.pi / 180)
        
        let circlePath = UIBezierPath(arcCenter: mainView.center, radius: CGFloat(radius), startAngle: startAngel, endAngle: endAngel, clockwise: true)
        
        semiCircleLayer.path = circlePath.cgPath
        semiCircleLayer.strokeColor = UIColor.init(red: 184/255, green: 250/255, blue: 236/255, alpha: 1).cgColor
        semiCircleLayer.fillColor = UIColor.clear.cgColor
        semiCircleLayer.lineWidth = 4
        semiCircleLayer.strokeStart = 0
        semiCircleLayer.strokeEnd  = 1
        
        if endAngel >= CGFloat(Double.pi * 1.5) {
            gameTimer.invalidate()
            
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if user != nil {
                    self.performSegue(withIdentifier: "ToTabBar", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "ToLoginPage", sender: nil)
                }
                
            }
        }
    }
}


