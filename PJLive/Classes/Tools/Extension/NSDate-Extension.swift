
//
//  NSDate-Extension.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/17.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit


extension NSDate {
    
    class func getCurrentTime() -> String {
        
        let nowDate = NSDate()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
        
    }
    
}

extension Date {
    
    ///  格式化日期字符串
    ///
    /// - Parameter formatStr: 格式
    /// - Returns: 转换后的字符串
    public func transformToString(formatStr: String? = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatStr!
        formatter.locale = Locale.init(identifier: "zh_Hans_CN")
        formatter.timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        return formatter.string(from: self)
    }
    
    /// 字符串转换成日期
    /// - Parameters:
    ///   - dateStr: 字符串
    ///   - format: 格式
    /// - Returns: 转换后日期
   public static func getDate(dateStr: String, format: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "zh_Hans_CN")
        dateFormatter.timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: dateStr)
        return date
    }
    
    /// 获取当前日期
    /// - Parameter component:
    /// - Returns:
    public func getComponent(component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }
    
    /// 获取当前毫秒级时间戳
    ///
    /// - Returns: 当前时间戳
    public func getTimeStamp() -> String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval*1000)
        return "\(timeStamp)"
    }
    
    
    
}
