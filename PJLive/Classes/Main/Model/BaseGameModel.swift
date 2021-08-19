//
//  BaseGameModel.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/22.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

class BaseGameModel: NSObject {
    
    // MARK: 定义属性
    /// 组显示的标题
    @objc var tag_name : String = ""
    /// 游戏对应的图标
    @objc var icon_url : String = ""
    
    // MARK: 自定义构造函数
    override init() {
        
    }
    
    init(dict : [String : Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }

}
