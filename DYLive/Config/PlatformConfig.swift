//
//  PlatformConfig.swift
//  DYLive
//
//  Created by Tony-sg on 2020/7/12.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import Foundation

/// 当前使用服务器(打包时,仅需修改此配置即可)
var currentServer = ServerConfig.develop

/// 服务器地址枚举
enum ServerConfig {
    // 开发环境
    case develop
    // 发布环境
    case release
    
    /// 域名
    var serverDomain: String {
        switch self {
        case .develop:
            return "http://192.168.10.189:39110"
        default:
            return "http://192.168.10.189:39110"
        }
    }
}

public let Base_URL = currentServer.serverDomain

#if DEBUG
public let UMeng_Channel = "test"
public let APSForProduction = false
#else
public let UMeng_Channel = "release"
public let APSForProduction = true
#endif


// MARK: -- 极光
/// 极光推送 AppKey
let JPushAppKey = "e45f27f8b5da6f7fa555a064"

// MARK: -- 友盟
/// 友盟 AppKey
let UMengAppKey = "609a21acc9aacd3bd4cf0693"
/// 友盟 渠道
let UMengChannel = UMeng_Channel

/// 平台配置类
class PlatformConfig: NSObject {
    var headPortraitUrl = ""
    
    @objc
    static let shared: PlatformConfig = {
        let sharedConfig = PlatformConfig()
        return sharedConfig
    }()
    
    private override init() {}
    
    /// 三方SDK初始化
    /// - Parameters:
    ///   - application: 当前应用
    ///   - launchOptions: 启动项
    func init3rdSDK(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        /// 极光推送
        initJPush(application: application, launchOptions: launchOptions)
        /// 友盟统计
        initUMengAnalysis()
    }
    
    /// 初始化友盟统计
    ///
    /// - Parameter enableLog: 设置是否在console输出sdk的log信息.默认false(不输出log)
    /// - Parameter encrypLog: 设置是否对日志信息进行加密, 默认false(不加密).
    func initUMengAnalysis(enableLog: Bool? = false, encrypLog: Bool? = false) {
        // 注册AppKey和渠道
        UMConfigure.initWithAppkey(UMengAppKey, channel: UMengChannel)
        // 配置日志开关,输出可供调试参考的log信息. 发布产品时必须设置为NO.
        UMConfigure.setLogEnabled(false)
        // 配置日志加密开关
        UMConfigure.setEncryptEnabled(encrypLog!)
    }
    
    func initJPush(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        /// 注册极光推送(模拟器不支持,仅在真机环境配置)
        if Platform.isRealDevice {
            let entity = JPUSHRegisterEntity()
            entity.types = 1 << 0 | 1 << 1 | 1 << 2
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: application as? JPUSHRegisterDelegate)
            // 需要IDFA 功能，定向投放广告功能
            // let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            JPUSHService.setup(withOption: launchOptions, appKey: JPushAppKey, channel: "Develop", apsForProduction: APSForProduction, advertisingIdentifier: nil)
            
            JPUSHService.registrationIDCompletionHandler { (statusCode, registrationID) in
                /// 配置当前用户的registrationID,登录时传给服务器
                if statusCode == 0  && registrationID != nil{
                    deviceRegistrationID = registrationID!
                } else {
                    LogUtil.debug("极光注册失败")
                }
                LogUtil.debug("statusCode ="+String(statusCode))
                LogUtil.debug("registrationID = " + String(registrationID!))
            }
        }
    }
}

// Token
public var token = ""
// 极光注册成功的设备标识
public var deviceRegistrationID = ""
