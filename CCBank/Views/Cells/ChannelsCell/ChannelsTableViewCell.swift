//
//  ChannelsTableViewCell.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 1/30/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit

class ChannelsTableViewCell: UITableViewCell {

    @IBOutlet weak var threadTitle: UILabel!
    @IBOutlet weak var numberOfUsers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(threadTitle: String, numberOfUsers: Int) {
        self.threadTitle.text = threadTitle
        self.numberOfUsers.text = " Users: \(String(describing: numberOfUsers)) "
    }
    
}
