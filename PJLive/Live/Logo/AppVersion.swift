//
//  AppVersion.swift
//  PJLive
//
//  Created by PublicJoker on 2021/8/20.
//  Copyright © 2021 PublicJoker. All rights reserved.
//

import UIKit
import HandyJSON

class AppVersion: HandyJSON {
    var resultCount: Int = 0
    var results = [Results]()
    
    required init() {}
}

class Results: HandyJSON {
    var version = ""
    required init() {}
}

