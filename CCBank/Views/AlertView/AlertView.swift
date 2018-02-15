//
//  AlertView.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 2/6/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var okButton: UIButton!
    
    init(errorName: String, initFrame: CGRect) {
        super.init(frame: initFrame)
        fromNib()
        errorDescriptionLabel.text = errorName
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(removeFromSuper))
        self.addGestureRecognizer(tapGest)
        self.frame = initFrame
        self.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 0.8)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        //buttonSettings
        okButton.layer.borderWidth = 1.2
        okButton.layer.borderColor = UIColor(red: 184/255, green: 250/255, blue: 236/255, alpha: 1).cgColor
        okButton.layer.cornerRadius = okButton.frame.width / 2
        okButton.clipsToBounds = true
        
        //label settings
        errorDescriptionLabel.layer.borderWidth = 1.2
        errorDescriptionLabel.layer.borderColor = UIColor(red: 184/255, green: 250/255, blue: 236/255, alpha: 1).cgColor
        errorDescriptionLabel.layer.cornerRadius = 17
        errorDescriptionLabel.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
 @objc func removeFromSuper () {

        self.removeFromSuperview()
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
