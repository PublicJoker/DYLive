//
//  FunnyViewModel.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/22.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

class FunnyViewModel : BaseViewModel {

}


extension FunnyViewModel {
    
    func loadFunnyData(finishCallback: @escaping () -> ()) {
        
        // http://capi.douyucdn.cn/api/v1/getColumnRoom/3?limit=30&offset=0
        loadAnchorData(isGroupData: true ,URLString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", parameters: nil, finishCallback: finishCallback)
        
    }
    
}
