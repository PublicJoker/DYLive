//
//  Created by Tony-sg on 2020/4/11.
//  Copyright © 2020 Tony-sg. All rights reserved.
//
// @class MoyaPlugin.swift
// @abstract Moya拓展支持
// @discussion 提供请求Moya操作与服务
//

import Foundation
import UIKit
import Moya
import Result
import SwiftyJSON

/// 超时时间默认10s
let kTimeoutInterval:Double = 10

/// Moya插件: 控制台打印请求的参数和服务器返回的json数据
public final class SLPrintParameterAndJson: NSObject, PluginType {
    /// 发生请求
    ///
    /// - Parameters:
    ///   - request: 请求类型
    ///   - target: 目标类型
    public func willSend(_ request: RequestType, target: TargetType) {
        /// 判断是否需要显示: 网络请求之前，显示对应的进度条
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        #if DEBUG
        print("""
            \(Date().transformToString(formatStr: "yyyy-MM-dd HH:mm:ss:sss")) 发送请求:
            1.API:\n\(request.request?.url?.absoluteString ?? "") -- \(request.request?.httpMethod ?? "")
            2.参数:\n\(NSString(data: (request.request?.httpBody ?? Data()), encoding: String.Encoding.utf8.rawValue)?.removingPercentEncoding ?? "")
            3.请求头:\n\(target.headers ?? [:])\n<=====
            """)
        #endif
    }
    
    /// 接受数据
    ///
    /// - Parameters:
    ///   - result: 结果
    ///   - target: 目标类型
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        /// 0.3s后消失：网络请求之后，移除进度条
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        #if DEBUG
        switch result {
        case .success(let response):
            DispatchQueue.global().async {
                do {
                    let jsonObiect = try response.mapJSON()
                    print("""
                        \(Date().transformToString(formatStr: "yyyy-MM-dd HH:mm:ss:sss")) 请求成功:
                        1.API:\n\(response.request?.url?.absoluteString ?? "") -- \(response.request?.httpMethod ?? "")
                        2.参数:\n\(NSString(data: (response.request?.httpBody ?? Data()), encoding: String.Encoding.utf8.rawValue) ?? "")
                        3.请求头:\n\(target.headers ?? [:])
                        4.接口返回:\n\(JSON(jsonObiect))\n<=====
                        """)
                } catch {
                    print("""
                            \(Date().transformToString(formatStr: "yyyy-MM-dd HH:mm:ss:sss")) 接口异常: -- statusCode:\(response.statusCode)
                            1.API:\n\(response.request?.url?.absoluteString ?? "") -- \(response.request?.httpMethod ?? "")
                            2.参数:\n\(NSString(data: (response.request?.httpBody ?? Data()), encoding: String.Encoding.utf8.rawValue) ?? "")
                            3.请求头:\n\(target.headers ?? [:])
                            4.接口返回:\n\(response.data))\n<=====
                            """)
                }
            }
        case.failure(let error):
            guard let errorJson = try? result.error?.response?.mapJSON() as? [String: Any] else {
                LogUtil.error("""
                \(target) 请求失败: \((error.errorObj ?? NSError())) <=====
                """)
                return
            }
                        
            guard let code = errorJson["code"] as? Int, code == 401 else {
                LogUtil.error("""
                \(target) 请求失败: \(errorJson.description)) <=====
                """)
                return
            }
                        
            LogUtil.error("""
            \(target) 请求失败: \(errorJson.description)) <=====
            """)
            
        }
        self.analyezeResponse(result)
        #endif
    }
    
    /// 分析返回数据
    func analyezeResponse(_ result: Result<Response, MoyaError>) {
        
    }
}

/// 为MoyaError提供扩展方法,解析完整的错误信息
extension MoyaError {
    public var errorObj: NSError? {
        switch self {
        case .imageMapping:
            return NSError(domain: "", code: HttpStatus.unknownError.rawValue, userInfo: [NSLocalizedDescriptionKey : "Failed to map data to an Image."])
        case .jsonMapping:
            return NSError(domain: "", code: HttpStatus.unknownError.rawValue, userInfo: [NSLocalizedDescriptionKey : "Failed to map data to JSON."])
        case .stringMapping:
            return NSError(domain: "", code: HttpStatus.unknownError.rawValue, userInfo: [NSLocalizedDescriptionKey : "Failed to map data to a String."])
        case .objectMapping:
            return NSError(domain: "", code: HttpStatus.unknownError.rawValue, userInfo: [NSLocalizedDescriptionKey : "Failed to map data to a Decodable object."])
        case .encodableMapping:
            return NSError(domain: "", code: HttpStatus.unknownError.rawValue, userInfo: [NSLocalizedDescriptionKey : "Failed to encode Encodable object into data."])
        case .statusCode:
            return NSError(domain: "", code: HttpStatus.unknownError.rawValue, userInfo: [NSLocalizedDescriptionKey : "Status code didn't fall within the given range."])
        case .requestMapping:
            return NSError(domain: "", code: HttpStatus.unknownError.rawValue, userInfo: [NSLocalizedDescriptionKey : "Failed to map Endpoint to a URLRequest."])
        case .parameterEncoding(let error):
            return NSError(domain: "", code: HttpStatus.unknownError.rawValue, userInfo: [NSLocalizedDescriptionKey : "Failed to encode parameters for URLRequest. \(error.localizedDescription)"])
        case .underlying(let error, _):
            return error as NSError
        }
    }
}

/// 各code代表什么
public enum HttpStatus: Int {
    case success = 0000 // 成功
    case logout = 9999 // token过期
    case requestFailed = 300 //网络请求失败
    case noDataOrDataParsingFailed = 301 //无数据或解析失败
    case unknownError = -999 //未知错误
}

extension Task {
    public var parameters: [String: Any] {
        switch self {
        case .requestParameters(let parameters, _):
            return parameters
        default:
            return [:]
        }
    }
    
//    /// A request with no additional data.
//    case requestPlain
//
//    /// A requests body set with data.
//    case requestData(Data)
//
//    /// A request body set with `Encodable` type
//    case requestJSONEncodable(Encodable)
//
//    /// A request body set with `Encodable` type and custom encoder
//    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
//
//    /// A requests body set with encoded parameters.
//    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
//
//    /// A requests body set with data, combined with url parameters.
//    case requestCompositeData(bodyData: Data, urlParameters: [String: Any])
//
//    /// A requests body set with encoded parameters combined with url parameters.
//    case requestCompositeParameters(bodyParameters: [String: Any], bodyEncoding: ParameterEncoding, urlParameters: [String: Any])
//
//    /// A file upload task.
//    case uploadFile(URL)
//
//    /// A "multipart/form-data" upload task.
//    case uploadMultipart([MultipartFormData])
//
//    /// A "multipart/form-data" upload task  combined with url parameters.
//    case uploadCompositeMultipart([MultipartFormData], urlParameters: [String: Any])
//
//    /// A file download task to a destination.
//    case downloadDestination(DownloadDestination)
//
//    /// A file download task to a destination with extra parameters using the given encoding.
//    case downloadParameters(parameters: [String: Any], encoding: ParameterEncoding, destination: DownloadDestination)
}
