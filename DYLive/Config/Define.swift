//
//  Define.swift
//  elevate
//
//  Created by Aisino on 2019/7/12.
//

import Foundation

func RGBCOLOR(r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}

func RGBACOLOR(r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
}

//状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.height

//导航栏高度
let navigationHeight = (statusBarHeight + 44)

//tabbar高度
let tabBarHeight = (statusBarHeight > 20 ? 83 : 49)

/// 获取屏幕大小
let screenBounds:CGRect = UIScreen.main.bounds

/// 系统statusBar高度
let kStatusBarHeight = UIApplication.shared.statusBarFrame.height

/// 系统naviBar高度
let kNaviBarHeight = DeviceTypeDefine.navigationHeight()

/// 系统tabBar高度
let kToolBarHeight = DeviceTypeDefine.toolBarHeight()

/// 屏幕宽高
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

//░░░░░░░Common░░░░░░░░░
/// 主题颜色
let kThemeColor = RGBACOLOR(r: 90, 109, 252, 0.8)
/// 通用背景色
let kBgColor = UIColor.init(r: 245, g: 245, b: 249)
/// 导航渐变色
let kNaviGradientColors = [UIColor.init(r: 80, g: 170, b: 235), UIColor.init(r: 55, g: 116, b: 217)]
/// 视图默认边距
let kDefaultMargin: CGFloat = 15.0
/// 分隔线颜色
let kSeparatorLineColor = UIColor.init(r: 221, g: 221, b: 221)
let kSeparatorInsets = UIEdgeInsets(top: 0, left: kDefaultMargin, bottom: 0, right: kDefaultMargin)
/// 文本灰色
let kTextGrayColor = UIColor.init(r: 124, g: 124, b: 124)
/// 文本浅灰色
let kTextLightGrayColor = RGBCOLOR(r: 177, 177, 177)
/// 弹出框页面背景色
let kToastViewBgColor = RGBACOLOR(r: 0, 0, 0, 0.5)
/// Item未选中颜色
let kItemNormalColor = RGBCOLOR(r: 241, 242, 243)
/// Item选中颜色
let kItemSelectColor = RGBCOLOR(r: 56, 123, 204)
/// 输入框颜色
let kTFTextColor = RGBCOLOR(r: 15, 15, 15)
/// 边框色
let kBorderColor = RGBCOLOR(r: 213, 226, 245)
/// 提示颜色
let kMarkColor = RGBCOLOR(r: 186, 186, 186)
/// Tip背景色
let kTipBgColor = RGBCOLOR(r: 231, 249, 234)
/// Tip文字颜色
let kTipTextColor = RGBCOLOR(r: 55, 184, 73)
/// 分割线颜色
let kLineColor = RGBCOLOR(r: 241, 241, 241)
let kPageTitleBgColor = RGBCOLOR(r: 90, 109, 252)

/// 上传文件大小限制为15M
let HXMaxFileSize = 1024 * 1024 * 15

extension UserDefaults {
    //应用第一次启动
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunched = "hasBeenLaunched"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunched)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunched)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
    
    //当天首次启动
    static func isFirstLaunchedToday() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        //上次存入时间
        let lastString = UserDefaults.standard.object(forKey: "lastLaunchDate") as? String
        UserDefaults.standard.setValue(todayString, forKey: "lastLaunchDate")
        UserDefaults.standard.synchronize()
        return todayString == lastString ? true : false
    }
    
    //当前版本第一次启动
    static func isFirstLaunchOfNewVersion() -> Bool {
        //主程序版本号
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"] as? String ?? ""
        
        //上次启动的版本号
        let hasBeenLaunchedOfNewVersion = "hasBeenLaunchedOfNewVersion"
        let lastLaunchVersion = UserDefaults.standard.string(forKey:
            hasBeenLaunchedOfNewVersion)
        
        //版本号比较
        let isFirstLaunchOfNewVersion = majorVersion != lastLaunchVersion
        if isFirstLaunchOfNewVersion {
            UserDefaults.standard.set(majorVersion, forKey:
                hasBeenLaunchedOfNewVersion)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunchOfNewVersion
    }
    
    /// 当前版本号,如 V1.0
    static func currentVersion() -> String {
        //主程序版本号
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"] as! String
        return "V" + majorVersion
    }
    
    /// 当前版本号,如 1.0
    static func currentVersionNum() -> String {
        //主程序版本号
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"] as! String
        return majorVersion
    }
}

extension Date {
    /// 获取当前毫秒级时间戳
    ///
    /// - Returns: 当前时间戳
    public func getTimeStamp() -> String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval*1000)
        return "\(timeStamp)"
    }
}
