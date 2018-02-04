//
//  CustomTableViewCell.swift
//  jsonSer
//
//  Created by Yaroslav Bosenko on 08.12.2017.
//  Copyright © 2017 Yaroslav Bosenko. All rights reserved.
//

import UIKit

class CurrenciesListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var hourChanges: UILabel!
    @IBOutlet weak var dayChanges: UILabel!
    @IBOutlet weak var lastPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        accessoryType =  .none
    }
    
    func cellInitialization(currencyName: String, updateSeconds: String, updateMinutes: String, lastPrice: String, hourChanges: String, dayChanges: String) {
        self.lastPrice.text = lastPrice + "$"
        self.currencyName.text = currencyName
        self.lastUpdate.text = "Last update: \(updateMinutes)m. \(updateSeconds)s. ago"
        
        if hourChanges == "Undefined" {
            self.hourChanges.textColor = UIColor.brown
            self.hourChanges.text = "Undefined"
        } else {
            if hourChanges.contains("-") {
                self.hourChanges.textColor = UIColor(red: 191/255, green: 0, blue: 0, alpha: 1)
                self.hourChanges.text = "Hour: ↓\(hourChanges)%"
            } else {
                self.hourChanges.textColor = UIColor(red: 40/255, green: 141/255, blue: 0, alpha: 1)
                self.hourChanges.text = "Hour: ↑\(hourChanges)%"
            }
        }
        if dayChanges == "Undefined" {
            self.dayChanges.textColor = UIColor.brown
            self.dayChanges.text = "Undefined"
        } else {
            if dayChanges.contains("-") {
                self.dayChanges.textColor = UIColor(red: 191/255, green: 0, blue: 0, alpha: 1)
                self.dayChanges.text = "Daily: ↓\(dayChanges)%"
            } else {
                self.dayChanges.textColor = UIColor(red: 40/255, green: 141/255, blue: 0, alpha: 1)
                self.dayChanges.text = "Daily: ↑\(dayChanges)%"
            }
        }
    }
}
