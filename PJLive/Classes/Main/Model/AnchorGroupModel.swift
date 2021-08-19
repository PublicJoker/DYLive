//
//  AnchorGroupModel.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/17.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

class AnchorGroupModel: BaseGameModel {
    
    // 注意：属性前需要添加 @objc，否者转换模型失败
    /// 该组中对应的房间信息
    @objc var room_list : [[String : NSObject]]? {
        // 方法二：属性监听器，监听属性的改变
        didSet {
            guard let room_list = room_list else { return }
            for dict in room_list {
                anchors.append(AnchorModel.init(dict: dict))
            }
        }
        
    }
    /// 组显示的图标
    @objc var icon_name : String = "home_header_normal"
    /// 定义主播的模型对象数组
    @objc lazy var anchors : [AnchorModel] = [AnchorModel]()
    
    /* 方法一：
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "room_list" {
            if let dataArray = value as? [[String : NSObject]] {
                for dict in dataArray {
                    anchors.append(AnchorModel(dict: dict))
                }
            }
        }
        
    }
    */

}
