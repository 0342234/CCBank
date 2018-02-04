 //
 //  CellForHistoryMenu.swift
 //  CCBank
 //
 //  Created by Yaroslav Bosenko on 02.01.2018.
 //  Copyright © 2018 no-organiztaion-name. All rights reserved.
 //
 
 import UIKit
 
 class SelectedHistoryCell: UITableViewCell {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var savedPrice: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var differenceInPercent: UILabel!
    @IBOutlet weak var savedCapitalization: UILabel!
    @IBOutlet weak var currentCapitalization: UILabel!
    @IBOutlet weak var capitalizationPercentChanges: UILabel!
    @IBOutlet weak var arrow: UILabel!
    
    var isExpanded: Bool = false
    {
        didSet
        {
            if !isExpanded {
                self.heightConstraint.constant = 0.0
                self.arrow.fadeTransition(0.5)
                self.arrow.text = "⇣"
            } else {
                self.heightConstraint.constant = 112.0
                self.arrow.fadeTransition(0.5)
                self.arrow.text = "⇡"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
    }
    
    func setupCell(name: String, savedPrice: String, currentPrice: String, priceChanges:  String, savedCapitalization: String, currentCapitalization: String, capitalizationChanges: String) {
        self.nameLabel.text = name
        self.savedPrice.text = savedPrice + "$"
        self.currentPrice.text = currentPrice + "$"
        self.differenceInPercent.text = priceChanges + "%"
        self.currentCapitalization.text = currentCapitalization
        self.savedCapitalization.text = savedCapitalization
        self.capitalizationPercentChanges.text = capitalizationChanges
        
        if capitalizationChanges.contains("-") {
            self.capitalizationPercentChanges.textColor = UIColor(red: 191/255, green: 0, blue: 0, alpha: 1)
            self.capitalizationPercentChanges.text = "↓\(capitalizationChanges)%"
        } else {
            if capitalizationChanges == "0.00000" {
                    self.capitalizationPercentChanges.text = "≈"
                self.capitalizationPercentChanges.textColor = UIColor(red: 0/255, green: 84/255, blue: 147/255, alpha: 1) } else {
                
            self.capitalizationPercentChanges.textColor = UIColor(red: 40/255, green: 141/255, blue: 0, alpha: 1)
            self.capitalizationPercentChanges.text = "↑\(capitalizationChanges)%"
        }
    }
        
        if priceChanges.contains("-") {
            self.differenceInPercent.textColor = UIColor(red: 191/255, green: 0, blue: 0, alpha: 1)
            self.differenceInPercent.text = "↓\(priceChanges)%"
        } else {
                self.differenceInPercent.textColor = UIColor(red: 40/255, green: 141/255, blue: 0, alpha: 1)
                self.differenceInPercent.text = "↑\(priceChanges)%"
            }
        }
 }
 
