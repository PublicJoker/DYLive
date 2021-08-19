//
//  CollectionBaseCell.swift
//  PJLive
//
//  Created by Mr_Han on 2019/4/18.
//  Copyright © 2019 Mr_Han. All rights reserved.

//

import UIKit
import Kingfisher


class CollectionBaseCell: UICollectionViewCell {
    // MARK: 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: 定义模型属性
    var anchor : VideoModel? {
        didSet {
            //0. 校验模型是否有值
            guard let anchor = anchor else { return }

            //3. 设置图片封面
            guard let iconURL = NSURL(string: anchor.vod_pic) else { return }
            let url = ImageResource(downloadURL: iconURL as URL)
            iconImageView.kf.setImage(with: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = false
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = kTextLightGrayColor.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentView.layer.shadowColor = kTextLightGrayColor.cgColor
    }
}
