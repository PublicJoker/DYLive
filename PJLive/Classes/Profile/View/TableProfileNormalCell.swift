//
//  TableProfileNormalCell.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/25.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

class TableProfileNormalCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
