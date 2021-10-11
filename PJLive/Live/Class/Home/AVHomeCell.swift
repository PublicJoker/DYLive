//
//  AVHomeCell.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/26.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit
import Kingfisher

class AVHomeCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!

    @IBOutlet weak var hitLab: UILabel!
    @IBOutlet weak var categorybtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    var model : Player_vod?{
        didSet{
            guard let item = model else { return }
            self.titleLab.text = item.vod_name
//            self.categorybtn.setTitle("评分" + item.vod_douban_score, for: .normal)
            self.categorybtn.setTitle("", for: .normal)
            self.imageV.kf.setImage(with: URL.init(string: item.vod_pic),placeholder: placeholder)
            self.hitLab.text = item.vod_gold
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imageV.layer.masksToBounds = true
        imageV.layer.cornerRadius = 3
        contentView.layer.cornerRadius = 5
        contentView.layer.borderColor = kBorderColor.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
    }

}
