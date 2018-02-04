//
//  HistoryTableViewCell.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 10.01.2018.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addingDateLabel: UILabel!
    @IBOutlet weak var addingTimeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func cellInitialization(addingTime: String, addinngDate: String) {
        addingTimeLabel.text = addingTime
        addingDateLabel.text = addinngDate
    }
}
