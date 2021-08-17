//
//  RecommendViewModel.swift
//  DYLive
//
//  Created by Mr_Han on 2019/4/17.
//  Copyright © 2019 Mr_Han. All rights reserved.
//  CSDN <https://blog.csdn.net/u010960265>
//  GitHub <https://github.com/HanQiGod>
//

import UIKit

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
        
        NetWorkTools.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/slide/6", parameters: ["version":"2.300"]) { (result) in
            
            //1. 获取整体的字典数据
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2. 根据字典的 key 获取 data 数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            //3. 字典转模型对象
            for dict in dataArray {
                self.cycleModels.append(CycleModel(dict: dict))
            }
            
            finishCallback()
            
        }
        
    }
    
    
}
