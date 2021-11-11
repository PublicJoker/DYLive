//
//  FindViewModel.swift
//  PJLive
//
//  Created by Tony on 2021/10/14.
//  Copyright © 2021 PublicJoker. All rights reserved.
//

import UIKit
import SwiftyJSON

/// 发现列表页model
@objcMembers class FindListModel: NSObject {
    /// 分类id
    @objc var albumId = 0
    /// 分类图
    @objc var albumImageUrl = ""
    /// 分类名称
    @objc var albumTitle = ""
    /// 分类描述
    @objc var albumDes = ""
    
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

class FindViewModel : BaseViewModel {
    
    // MARK: 懒加载属性
    lazy var listModels : [FindListModel] = [FindListModel]()
}

// MARK: 发送网络请求
extension FindViewModel {
    
    // 请求推荐数据
    func requestData(finishCallback: @escaping () -> ()) {
//        var parameters = [String: Any]()
//        parameters = getDefaulParam(type: .findHot)

        let fileUrl = Bundle.main.url(forResource: "find_list", withExtension: ".json")!
        let jsonArr = try! JSON(data: Data(contentsOf: fileUrl)).arrayObject!
//        NetWorkTools.requestData(type: .post, URLString: currentServer.serverDomain, parameters: parameters) { (result) in
//            LogUtil.debug(result)
            
//            //1.1. 将 result 转成字典类型
//            guard let resultDic = result as? [String : NSObject] else {
//                finishCallback()
//                return
//            }
//
//            //1.2. 根据 data 该 key，获取数组
//            guard let dataArray = resultDic["data"] as? [[String : NSObject]] else {
//                finishCallback()
//                return
//            }
            
            //1.3.2 获取推荐视频数据
            for dict in jsonArr {
                self.listModels.append(FindListModel.init(dict: dict as! [String : NSObject]))
            }
            
            //1.4 离开组
            finishCallback()
//        }
    }
    
    // 请求分类数据
    func requestCategoryData(listId: Int, finishCallback: @escaping () -> ()) {
        let fileUrl = Bundle.main.url(forResource: "\(listId)", withExtension: ".json")!
        let jsonArr = try! JSON(data: Data(contentsOf: fileUrl)).arrayObject!
        
        //获取分类视频数据
        let listItem = FindListModel()
        listItem.videos = jsonArr as? [[String : NSObject]]
        self.listModels.append(listItem)
        
        //1.4 离开组
        finishCallback()
        
//        var parameters = [String: Any]()
//        parameters = getDefaulParam(type: .findCategory)
//        parameters["id"] = listId//分类列表id
//
//        NetWorkTools.requestData(type: .post, URLString: currentServer.serverDomain, parameters: parameters) { (result) in
//            LogUtil.debug(result)
//
//            //1.1. 将 result 转成字典类型
//            guard let resultDic = result as? [String : NSObject] else {
//                finishCallback()
//                return
//            }
//
//            //1.2. 根据 data 该 key，获取数组
//            guard let dataDic = resultDic["data"] as? [String : NSObject] else {
//                finishCallback()
//                return
//            }
//
//            //1.3.2 获取分类视频数据
//            self.listModels.append(FindListModel.init(dict: dataDic))
//            //1.4 离开组
//            finishCallback()
//        }
    }
}
