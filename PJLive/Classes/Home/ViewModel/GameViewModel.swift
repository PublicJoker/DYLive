//
//  GameViewModel.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/19.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

class GameViewModel {
    
    lazy var games : [GameModel] = [GameModel]()

}


// MARK:
extension GameViewModel {
    
    func loadAllGameData(finishCallback: @escaping () -> ()) {
        
        // http://capi.douyucdn.cn/api/v1/getColumnDetail?shortName=game
        NetWorkTools.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/getColumnDetail", parameters: nil) { (result) in
            
            //1. 获取数据
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = result["data"] as? [[String : Any]] else { return }
            
            //2. 字典转模型
            for dict in dataArray {
                self.games.append(GameModel(dict: dict))
            }
            
            //3. 完成回调
            finishCallback()
            
        }
        
    }
    
}
