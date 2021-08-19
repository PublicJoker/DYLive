//
//  CollectionGameCell.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/19.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit
import Kingfisher

class CollectionGameCell: UICollectionViewCell {
    
    // MARK: 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: 定义模型属性
    var baseGame : BaseGameModel? {
        didSet {
            
            titleLabel.text = baseGame?.tag_name
            let iconUrl = URL(string: baseGame?.icon_url ?? "")
            iconImageView.kf.setImage(with: iconUrl, placeholder: UIImage(named: "home_more_btn"))
            
        }
    }
    
    
    // MARK: 系统回调
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
