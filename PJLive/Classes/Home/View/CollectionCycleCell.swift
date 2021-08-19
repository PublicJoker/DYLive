//
//  CollectionCycleCell.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/19.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit
import Kingfisher

class CollectionCycleCell: UICollectionViewCell {
    
    // 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    

    // 定义模型属性
    var cycleModel : CycleModel? {
        didSet {
            titleLabel.text = cycleModel?.vod_name
            let iconURL = URL(string: cycleModel?.vod_pic_slide ?? "")!
            let resource = ImageResource(downloadURL: iconURL)
            iconImageView.kf.setImage(with: resource, placeholder: UIImage(named: "Img_default"))
        }
    }
}
