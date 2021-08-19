//
//  HomeTabModel.swift
//  PJLive
//
//  Created by PublicJoker on 2021/8/17.
//  Copyright © 2021 PublicJoker. All rights reserved.
//

import UIKit
import HandyJSON

class HomeTabModel: NSObject {
    /// 标签id
    @objc var list_id : String = ""
    /// 标签名
    @objc var list_name : String = ""
    /// 父标签id
    @objc var list_pid : String = ""
    
    /// 自定义构造函数
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}

class VideoGroupModel: BaseGameModel {
    @objc var type = ""
    @objc var title = ""
    @objc var videos_size = 0
    @objc var arrangementSize = 0
    
    /// 定义视频的模型对象数组
    @objc lazy var video_list : [VideoModel] = [VideoModel]()
    
    // 注意：属性前需要添加 @objc，否者转换模型失败
    /// 该组中对应的房间信息
    @objc var videos : [[String : NSObject]]? {
        // 方法二：属性监听器，监听属性的改变
        didSet {
            guard let videos = videos else { return }
            for dict in videos {
                video_list.append(VideoModel.init(dict: dict))
            }
        }
        
    }
}

class VideoModel: NSObject, HandyJSON {
    required override init() { }
    
    @objc var vod_name = ""
    @objc var vod_pic_slide = ""
    @objc var vod_continu = ""
    @objc var vod_pic = ""
    @objc var vod_gold = ""
    @objc var vod_id = ""
    @objc var vod_total = ""
    @objc var vod_actor = ""
    @objc var vod_douban_score = ""
    
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
