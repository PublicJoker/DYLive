//
//  CollectionHeaderView.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/16.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    
    // MARK: 控件属性
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    // MARK: 定义模型属性
    var group : VideoGroupModel? {
        
        didSet {
            
            titleLabel.text = group?.title            
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}


// MARK: 从 xib 中快速创建类方法
extension CollectionHeaderView {
    
    class func collectionHeaderView() -> CollectionHeaderView {
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil, options: nil)?.first as! CollectionHeaderView
    }
    
}
