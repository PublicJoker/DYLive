//
//  ProfileBtnsCell.swift
//  PJLive
//
//  Created by Mr_Han on 2019/4/25.
//  Copyright © 2019 Mr_Han. All rights reserved.

//

import UIKit

class ProfileBtnsCell: UICollectionViewCell {
    
    // MARK: 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = kTextLightGrayColor.cgColor
        layer.shadowColor = UIColor.darkGray.cgColor
        
    }

}
