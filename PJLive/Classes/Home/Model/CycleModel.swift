//
//  CycleModel.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/19.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

class CycleModel: NSObject {
    /// 专辑id
    @objc var vod_id : Int = 0
    /// 标题
    @objc var vod_name : String = ""
    /// 图片
    @objc var vod_pic_slide : String = ""
    
    /// 自定义构造函数
    init(dict : [String : NSObject]) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }

}

class ConfigModel: NSObject {
    /// 更新提示
    @objc var vod_name: String = ""
    /// 更新内容
    @objc var content: String = ""
    /// 版本号
    @objc var version: String = ""
    /// 热门搜索排行榜
    @objc var hotUrl: String = ""
    /// 下载地址
    @objc var url: String = ""
    /// 是否强制升级
    @objc var force: Bool = false
    /// 0显示开屏广告，1显示新插屏广告
    @objc var splashAd: Int = 0
    /// 官方网站
    @objc var webUrl: String = ""
    ///
    @objc var key: String = ""
    /// 联系邮箱
    @objc var mail: String = ""
    /// 首页轮播
    @objc var banner: [CycleModel] = []
    
    /// 自定义构造函数
    init(dict: [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "banner" {
            if let dataArray = value as? [[String : NSObject]] {
                for dict in dataArray {
                    banner.append(CycleModel(dict: dict))
                }
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }

}
