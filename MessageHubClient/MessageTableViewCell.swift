//
//  MessageTableViewCell.swift
//  MessageHubClient
//
//  Created by Donnie Wang on 2/13/15.
//  Copyright (c) 2015 Donnie Wang. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
