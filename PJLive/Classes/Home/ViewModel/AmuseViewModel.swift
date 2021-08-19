//
//  AmuseViewModel.swift
//  PJLive
//
//  Created by Mr_Han on 2019/4/22.
//  Copyright © 2019 Mr_Han. All rights reserved.

//

import UIKit

class AmuseViewModel : BaseViewModel {

}


// MARK: 请求数据
extension AmuseViewModel {
    
    func loadAmuseData(finishCallback: @escaping () -> ()) {
        
        loadAnchorData(isGroupData:true ,URLString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", parameters: nil, finishCallback: finishCallback)
        
    }
    
}
