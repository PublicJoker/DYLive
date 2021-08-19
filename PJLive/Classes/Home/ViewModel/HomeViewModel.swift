//
//  HomeViewModel.swift
//  PJLive
//
//  Created by PublicJoker on 2021/8/17.
//  Copyright © 2021 君凯商联网. All rights reserved.
//

import UIKit

class HomeViewModel: BaseViewModel {
    // MARK: 懒加载属性
    lazy var tabModels : [HomeTabModel] = [HomeTabModel]()    
}

// MARK: 发送网络请求
extension HomeViewModel {
    // 请求推荐数据
    func requestData(finishCallback: @escaping () -> ()) {
        //0. 定义参数
        let parameters = getDefaulParam(type: .main)

        NetWorkTools.requestData(type: .post, URLString: currentServer.serverDomain, parameters: parameters) { (result) in
            
            //1.1. 将 result 转成字典类型
            guard let resultDic = result as? [String : NSObject] else { return }
            
            //1.2. 根据 data 该 key，获取数组
            guard let dataArray = resultDic["data"] as? [[String : NSObject]] else { return }
            
            //1.3 遍历数组，获取字典，并将字典转成模型对象
            //1.3.1 获取tab数据
            for dict in dataArray {
                self.tabModels.append(HomeTabModel.init(dict: dict))
            }
            
            finishCallback()
        }
    }
}

