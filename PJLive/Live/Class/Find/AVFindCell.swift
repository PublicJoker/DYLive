//
//  AVFindCell.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/29.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit

class AVFindCell: UICollectionViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var currentLab: UILabel!
    @IBOutlet weak var totalLab: UILabel!
    
    var info : FindListModel?{
        didSet{
            guard let item = info else { return }
            self.imageV.kf.setImage(with: URL.init(string: item.special_logo));
            self.titleLab.text = item.special_name;
            self.totalLab.text = ""
            self.currentLab.text = ""
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
