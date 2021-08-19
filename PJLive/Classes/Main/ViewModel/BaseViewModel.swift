//
//  BaseViewModel.swift
//  PJLive
//
//  Created by Mr_Han on 2019/4/22.
//  Copyright © 2019 Mr_Han. All rights reserved.

//

import UIKit

class BaseViewModel {
    
    lazy var anchorGroups : [VideoGroupModel] = [VideoGroupModel]()

}

extension BaseViewModel {
    
    func loadAnchorData(isGroupData: Bool ,URLString: String, parameters: [String : Any]? = nil, finishCallback: @escaping () -> ()) {
        
        NetWorkTools.requestData(type: .get, URLString: URLString, parameters: parameters) { (result) in
            
            //1. 获取字典数据
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            //2. 判断是否分组数据
            if isGroupData {
                
                //2.1 字典转模型对象
                for dict in dataArray {
                    self.anchorGroups.append(VideoGroupModel(dict: dict))
                }
                
            } else {
                //2.1 创建组
                let group = VideoGroupModel()
                
                //2.2 遍历 dataArray 所有的字典
                for dict in dataArray {
                    group.video_list.append(VideoModel(dict: dict))
                }
                
                //2.3 将 group 添加到 anchorGroups 里面
                self.anchorGroups.append(group)
                
            }
            
            //3. 完成回调
            finishCallback()
        }
        
    }
    
}
