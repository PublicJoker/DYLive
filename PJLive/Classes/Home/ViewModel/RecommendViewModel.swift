//
//  RecommendViewModel.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/17.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit
import Result

class RecommendViewModel : BaseViewModel {
    
    // MARK: 懒加载属性
    lazy var cycleModels : [CycleModel] = [CycleModel]()
//    lazy var bigDataGroup = [VideoGroupModel]()
//    private lazy var prettyDataGroup : AnchorGroupModel = AnchorGroupModel()
}


// MARK: 发送网络请求
extension RecommendViewModel {
    
    // 请求推荐数据
    func requestData(listId:String?, finishCallback: @escaping () -> ()) {
        var parameters = [String: Any]()
        
        if listId == nil {
            parameters = getDefaulParam(type: .recommend)
        } else {
            parameters = getDefaulParam(type: .categoryList)
            parameters["list_id"] = listId!//分类列表id
        }

        NetWorkTools.requestData(type: .post, URLString: currentServer.serverDomain, parameters: parameters) { (result) in
            
            //1.1. 将 result 转成字典类型
            guard let resultDic = result as? [String : NSObject] else {
                finishCallback()
                return
            }
            
            //1.2. 根据 data 该 key，获取数组
            guard let dataArray = resultDic["data"] as? [[String : NSObject]] else {
                finishCallback()
                return
            }
            
            //1.3.2 获取推荐视频数据
            for dict in dataArray {
                self.anchorGroups.append(VideoGroupModel.init(dict: dict))
            }
            
            //1.4 离开组
            finishCallback()
        }
    }
    
    // 请求无限轮播的数据
    // http://capi.douyucdn.cn/api/v1/slide/6?version=2.300
    func requestCycleData(finishCallback : @escaping () -> ()) {
        
        NetWorkTools.requestData(type: .post, URLString: "http://cy.yinyinapp.cn/ios-config.json", parameters: nil) { (result) in
            
            guard let dataDic = result["data"] as? [String: NSObject] else { return }
           
            let config = ConfigModel(dict: dataDic)
            
            // 更新app全局配置
            kAppdelegate?.appConfig = config
            self.cycleModels.append(contentsOf: config.banner)
            
            finishCallback()
            
        }
    }
}
