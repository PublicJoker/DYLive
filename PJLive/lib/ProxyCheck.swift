//
//  ProxyCheck.swift
//  PJLive
//
//  Created by PublicJoker on 2021/8/17.
//  Copyright © 2021 君凯商联网. All rights reserved.
//

import Foundation
import CFNetwork

func getProxyStatus() -> Bool {
    let proxySettings = CFNetworkCopySystemProxySettings()?.autorelease()
    let proxies = CFNetworkCopyProxiesForURL(URL(string: "www.baidu.com")! as CFURL, proxySettings as! CFDictionary)
    let setting = (proxies.takeRetainedValue() as Array).first
    
    let host = setting?.object(forKey: kCFProxyHostNameKey)
    let port = setting?.object(forKey: kCFProxyPortNumberKey)
    let type = setting?.object(forKey: kCFProxyTypeKey) as! CFString
    
    guard type == kCFProxyTypeNone else {
        return true
    }

    return false
}
