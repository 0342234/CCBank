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
    @IBOutlet weak var symbol: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        accessoryType =  .none
    }
    
    func cellInitialization(currencyName: String, lastUpdate: String, lastPrice: String, hourChanges: String, dayChanges: String, symbol: String) {
        self.lastPrice.text = lastPrice + "$"
        self.currencyName.text = currencyName
        let timestamp = Double(lastUpdate)
        self.symbol.text = "\"\(symbol)\""
        
        var dateText: String = "HUI"
        if let timestamp = timestamp {
            let timestampTime = Date(timeIntervalSince1970: timestamp)
            let now = Date()
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([Calendar.Component.second] , from: timestampTime, to: now)
            let seconds: Int! = dateComponents.second
            dateText = String(describing: seconds!)
            self.lastUpdate.text = " Updated \(dateText) s. ago"
        }
  
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
