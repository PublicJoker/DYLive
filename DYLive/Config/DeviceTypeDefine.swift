//
//  DeviceTypeDefine.swift
//  Ocean
//
//  Created by Tony-sg on 2020/4/23.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit

/// 设备类型定义,用于判断当前设备型号,尺寸等参数
class DeviceTypeDefine: NSObject {
    
    /// 系统top安全区域
    ///
    /// - Returns: 上方安全区域高度
    static func safeAreaTop() -> CGFloat {
        if #available(iOS 11.0, *) {
            //iOS 12.0以后的非刘海手机top为 20.0
            if (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom == 0 {
                return 20.0
            }
            return (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.top ?? 20.0
        }
        return 20.0
    }
    
    /// 系统bottom安全区域
    ///
    /// - Returns: 下方安全区域高度
    static func safeAreaBottom() -> CGFloat {
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
    
    /// 是否有安全区域
    ///
    /// - Returns:
    static func hasSafeArea() -> Bool {
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom ?? CGFloat(0) > CGFloat(0)
        } else { return false }
    }
    
    /// 获取系统tabBar高度
    ///
    /// - Returns: tabBar高度
    static func toolBarHeight() -> CGFloat {
        return 49 + safeAreaBottom()
    }
    
    /// 获取系统导航栏高度
    ///
    /// - Returns: 导航栏高度
    static func navigationHeight() -> CGFloat {
        return 44 + safeAreaTop()
    }
}

/// 设备平台判断(模拟器/真机)
struct Platform {
    /// 模拟器
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
    /// 真机
    static let isRealDevice: Bool = {
        var isReal = true
        #if arch(i386) || arch(x86_64)
        isReal = false
        #endif
        return isReal
    }()
    
    /// 获取当前设备操作系统和版本,如 iOS 12.0
    ///
    /// - Returns: systemVersion
    static let systemVersion: String = {
        return String(format: "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
    }()
    
    /// 获取当前设备型号,如 iPhone X
    ///
    /// - Returns: deviceModel
    static let deviceModel: String = {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        
        if platform == "iPhone1,1" { return "iPhone 2G"}
        if platform == "iPhone1,2" { return "iPhone 3G"}
        if platform == "iPhone2,1" { return "iPhone 3GS"}
        if platform == "iPhone3,1" { return "iPhone 4"}
        if platform == "iPhone3,2" { return "iPhone 4"}
        if platform == "iPhone3,3" { return "iPhone 4"}
        if platform == "iPhone4,1" { return "iPhone 4S"}
        if platform == "iPhone5,1" { return "iPhone 5"}
        if platform == "iPhone5,2" { return "iPhone 5"}
        if platform == "iPhone5,3" { return "iPhone 5C"}
        if platform == "iPhone5,4" { return "iPhone 5C"}
        if platform == "iPhone6,1" { return "iPhone 5S"}
        if platform == "iPhone6,2" { return "iPhone 5S"}
        if platform == "iPhone7,1" { return "iPhone 6 Plus"}
        if platform == "iPhone7,2" { return "iPhone 6"}
        if platform == "iPhone8,1" { return "iPhone 6S"}
        if platform == "iPhone8,2" { return "iPhone 6S Plus"}
        if platform == "iPhone8,4" { return "iPhone SE"}
        if platform == "iPhone9,1" { return "iPhone 7"}
        if platform == "iPhone9,2" { return "iPhone 7 Plus"}
        if platform == "iPhone10,1" { return "iPhone 8"}
        if platform == "iPhone10,2" { return "iPhone 8 Plus"}
        if platform == "iPhone10,3" { return "iPhone X"}
        if platform == "iPhone10,4" { return "iPhone 8"}
        if platform == "iPhone10,5" { return "iPhone 8 Plus"}
        if platform == "iPhone10,6" { return "iPhone X"}
        if platform == "iPhone11,2" { return "iPhone XS"}
        if platform == "iPhone11,4" { return "iPhone XS Max (China)"}
        if platform == "iPhone11,6" { return "iPhone XS Max (China)"}
        if platform == "iPhone11,8" { return "iPhone XR"}
        if platform == "iPhone12,1" { return "iPhone 11"}
        if platform == "iPhone12,3" { return "iPhone 11 Pro"}
        if platform == "iPhone12,5" { return "iPhone 11 Pro Max"}
        
        if platform == "iPod1,1" { return "iPod Touch 1G"}
        if platform == "iPod2,1" { return "iPod Touch 2G"}
        if platform == "iPod3,1" { return "iPod Touch 3G"}
        if platform == "iPod4,1" { return "iPod Touch 4G"}
        if platform == "iPod5,1" { return "iPod Touch 5G"}
        
        if platform == "iPad1,1" { return "iPad 1"}
        if platform == "iPad2,1" { return "iPad 2"}
        if platform == "iPad2,2" { return "iPad 2"}
        if platform == "iPad2,3" { return "iPad 2"}
        if platform == "iPad2,4" { return "iPad 2"}
        if platform == "iPad2,5" { return "iPad Mini 1"}
        if platform == "iPad2,6" { return "iPad Mini 1"}
        if platform == "iPad2,7" { return "iPad Mini 1"}
        if platform == "iPad3,1" { return "iPad 3"}
        if platform == "iPad3,2" { return "iPad 3"}
        if platform == "iPad3,3" { return "iPad 3"}
        if platform == "iPad3,4" { return "iPad 4"}
        if platform == "iPad3,5" { return "iPad 4"}
        if platform == "iPad3,6" { return "iPad 4"}
        if platform == "iPad4,1" { return "iPad Air"}
        if platform == "iPad4,2" { return "iPad Air"}
        if platform == "iPad4,3" { return "iPad Air"}
        if platform == "iPad4,4" { return "iPad Mini 2"}
        if platform == "iPad4,5" { return "iPad Mini 2"}
        if platform == "iPad4,6" { return "iPad Mini 2"}
        if platform == "iPad4,7" { return "iPad Mini 3"}
        if platform == "iPad4,8" { return "iPad Mini 3"}
        if platform == "iPad4,9" { return "iPad Mini 3"}
        if platform == "iPad5,1" { return "iPad Mini 4"}
        if platform == "iPad5,2" { return "iPad Mini 4"}
        if platform == "iPad5,3" { return "iPad Air 2"}
        if platform == "iPad5,4" { return "iPad Air 2"}
        if platform == "iPad6,3" { return "iPad Pro 9.7"}
        if platform == "iPad6,4" { return "iPad Pro 9.7"}
        if platform == "iPad6,7" { return "iPad Pro 12.9"}
        if platform == "iPad6,8" { return "iPad Pro 12.9"}
        
        if platform == "i386" { return "iPhone Simulator"}
        if platform == "x86_64" { return "iPhone Simulator"}
        
        return platform
    }()

}
