//
//  MessageTableViewCell.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 1/31/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
