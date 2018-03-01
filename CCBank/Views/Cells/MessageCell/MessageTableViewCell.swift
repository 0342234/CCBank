//
//  MessageTableViewCell.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 1/31/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageSender: UILabel!
    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCell(message: String, time: String, sender: String) {
        viewLayout.layer.cornerRadius = 60
        messageText.text = message
        dateText.text = time
        messageText.layer.cornerRadius = 30
        messageSender.text = sender
    }
}
