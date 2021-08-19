//
//  VodDetail.swift
//  PJLive
//
//  Created by PublicJoker on 2021/8/19.
//  Copyright © 2021 PublicJoker. All rights reserved.
//

import UIKit
import HandyJSON
    
class VodDetail: HandyJSON {
    var type = ""
    var player_vod = Player_vod()

    required init() {}
}

class Player_vod: HandyJSON {
    var updateTime :TimeInterval = 0;

    var vod_total = ""
    var vod_id = ""
    var vod_pic = ""
    var vod_url = ""
    var vod_douban_id = ""
    var vod_cid = ""
    var vod_title = ""
    var vod_continu = ""
    var vod_play = [Vod_play]()
    var vod_name = ""
    var vod_douban_score = ""
    var vod_actor = ""
    var vod_content = ""
    var vod_gold = ""

    var playItem: PlayItemInfo = PlayItemInfo.init();
    
    required init() {}
}

class Players: HandyJSON {
    var name  : String = ""
    var itemId  : String = ""//每一部的id
    var url : String = "";//播放地址做主键 就怕地址会变化
    
    var title = ""
    var snifferType: Int = 0

    required init() {}
}

class Vod_play: HandyJSON {
    var player_name_zh = ""
    var player_jiexi = ""
    var player_order: Int = 0
    var player_info = ""
    var isDown: Bool = false
    var players = [Players]()
    var title = ""

    required init() {}
}

class PlayItemInfo : Players{
    var currentTime : TimeInterval = 0;
    var totalTime   : TimeInterval = 1;
    var living      : Bool = false;
    var needSeek    : Bool?{
        get{
            let time : TimeInterval = self.totalTime > 60*60 ? 120 : 30
            let seek = self.currentTime > 5 && self.currentTime < (self.totalTime - time) && !self.living ? true : false;
            return seek;
        }
    }
}
