//
//  LogUtil.swift
//  basics.Util
//
//  Created by Aisino on 2019/5/9.
//  Copyright © 2019 Aisino. All rights reserved.
//

import UIKit
@_exported import XCGLogger

let thirdLogger = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

let loggerDestinationIdentifier = "advancedLogger.systemDestination"

//敏感信息过滤tag
public let LogUtilTagSensitive = "sensitive"

//过滤敏感信息tag日志
let sensitiveTagFilter = TagFilter(excludeFrom: [LogUtilTagSensitive])

/**  打印管理类
 *   打印示例:
 *  LogUtil.debug("这里进行用户身份验证。", userInfo: LogUtil.defaultUserInfo)
 *  LogUtil.verbose("一条verbose级别消息：程序执行时最详细的信息。")
 *  LogUtil.debug("一条debug级别消息：用于代码调试。")
 *  LogUtil.info("一条info级别消息：常用与用户在console.app中查看。")
 *  LogUtil.warning("一条warning级别消息：警告消息，表示一个可能的错误。")
 *  LogUtil.error("一条error级别消息：表示产生了一个可恢复的错误，用于告知发生了什么事情。")
 *  LogUtil.severe("一条severe error级别消息：表示产生了一个严重错误。程序可能很快会奔溃。")
 */
public class LogUtil: NSObject {
    /// log管理工具单例
    public static let shared: LogUtil = {
        let shared = LogUtil()
        shared.setUpLogger()
        return shared
    }()
    
    /// tag
    public static let tags: String = {
        return XCGLogger.Constants.userInfoKeyTags
    }()
    
    /// 默认过滤规则
    public static let defaultUserInfo: [String: Any] = {
        return [LogUtil.tags: LogUtilTagSensitive]
    }()
    
    public class func debug(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = defaultUserInfo) {
        shared.setUpLogger()
        thirdLogger.debug(closure())
    }
    
    public class func info(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String : Any] = defaultUserInfo) {
        shared.setUpLogger()
        thirdLogger.info(closure())
    }
    
    public class func warning(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = defaultUserInfo) {
        shared.setUpLogger()
        thirdLogger.warning(closure())
    }
    
    public class func error(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = defaultUserInfo) {
        shared.setUpLogger()
        thirdLogger.error(closure())
    }
    
    public class func severe(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = defaultUserInfo) {
        shared.setUpLogger()
        thirdLogger.severe(closure())
    }

    public class func verbose(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = defaultUserInfo) {
        shared.setUpLogger()
        thirdLogger.verbose(closure())
    }
    
    /// 初始化配置
    fileprivate func setUpLogger () {
        //只配置一次
        if (thirdLogger.destination(withIdentifier: loggerDestinationIdentifier) != nil) {
            return
        }
        
        // Log
        let systemDestination = AppleSystemLogDestination(identifier: loggerDestinationIdentifier)
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = false
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = false
        systemDestination.showLineNumber = false
        systemDestination.showDate = false
        
        // logger对象中添加控制台输出
        thirdLogger.add(destination: systemDestination)
        // 颜色 -> 设置了还是没有效果，需要XcodeColors插件支持
//        let ansiColorLogFormatter: ANSIColorLogFormatter = ANSIColorLogFormatter()
//        ansiColorLogFormatter.colorize(level: .verbose, with: .colorIndex(number: 244), options: [.faint])
//        ansiColorLogFormatter.colorize(level: .debug, with: .black)
//        ansiColorLogFormatter.colorize(level: .info, with: .blue, options: [.underline])
//        ansiColorLogFormatter.colorize(level: .warning, with: .red, options: [.faint])
//        ansiColorLogFormatter.colorize(level: .error, with: .red, options: [.bold])
//        ansiColorLogFormatter.colorize(level: .severe, with: .white, on: .red)
//        systemDestination.formatters = [ansiColorLogFormatter]
        
        // 日志文件地址
        let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                                 in: .userDomainMask)[0]
        let logURL = cachePath.appendingPathComponent("log.txt")
        // 文件出输出
        let fileDestination = FileDestination(writeToFile: logURL,
                                              identifier: "advancedLogger.fileDestination",
                                              shouldAppend: true, appendMarker: "-- Relauched App --")
        
        // 设置各个配置项
        fileDestination.outputLevel = .debug
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = false
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        
        // 文件输出在后台处理
        fileDestination.logQueue = XCGLogger.logQueue
        
        // logger对象中添加控制台输出
        thirdLogger.add(destination: fileDestination)
        
        // 颜色 -> 设置了还是没有效果，还没有找到原因
        if let fileDestination: FileDestination = thirdLogger.destination(withIdentifier: XCGLogger.Constants.fileDestinationIdentifier) as? FileDestination {
            let ansiColorLogFormatter: ANSIColorLogFormatter = ANSIColorLogFormatter()
            ansiColorLogFormatter.colorize(level: .verbose, with: .colorIndex(number: 244), options: [.faint])
            ansiColorLogFormatter.colorize(level: .debug, with: .black)
            ansiColorLogFormatter.colorize(level: .info, with: .blue, options: [.underline])
            ansiColorLogFormatter.colorize(level: .warning, with: .red, options: [.faint])
            ansiColorLogFormatter.colorize(level: .error, with: .red, options: [.bold])
            ansiColorLogFormatter.colorize(level: .severe, with: .white, on: .red)
            fileDestination.formatters = [ansiColorLogFormatter]
        }
        
        // 日期格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mma"
        dateFormatter.locale = Locale.current
        thirdLogger.dateFormatter = dateFormatter
        
        // 按标签过滤
        thirdLogger.filters = [sensitiveTagFilter]

        // 设置
        #if DEBUG
        thirdLogger.setup(level: .debug, showThreadName:true, showLevel:true, showFileNames:true, showLineNumbers:true, fileLevel:.debug)
        #else
        thirdLogger.setup(level: .severe, showThreadName:true, showLevel:true, showFileNames:true, showLineNumbers:true)
        #endif
        
        // 日志转存: 转存后原有的日志也会清空
        // 获取用户文档目录
        //        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //        let documentLogURL = documentPath.appendingPathComponent("log.txt")
        //        // 将当前的日志文件复制到用户文档目录中去
        //        fileDestination.rotateFile(to: documentLogURL)
        
        // 开始启用
        thirdLogger.logAppDetails()
    }
}
