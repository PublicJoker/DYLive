//
//  ApiMoya.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/26.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import SnapKit
import HandyJSON
private let moya = MoyaProvider<ApiMoya>()

/// 证书配置
public func defaultAlamofireManager() -> Manager {
    return Manager.default
}

public enum ApiMoya{
    //MARK:--📢:查询版本要用post请求!!!get请求有缓存,会导致版本信息不同步
    case getAppVersion(appId: String)
    case apiHome(vsize: String)
    case apiMovie(movieId: String, vsize:String)
    case apiHomeMore(page: Int, size: Int, ztid: String)
    case apiMovieMore(page: Int, size: Int, movieId: String)
    case apiSearch(page: Int, size: Int, keyWord: String)
    case apiShow(movieId: String)
}
extension ApiMoya : TargetType{
    public var baseURL: URL {
        switch self {
        case .getAppVersion:
            return URL.init(string: "https://itunes.apple.com")!
        default:
            return URL.init(string: "http://api.haidan.me")!
        }
    }
    
    public var path: String {
        switch self {
          case .apiHome:
              return "/index.php/app/ios/topic/index"
          case .apiMovie:
              return "/index.php/app/ios/type/index"
        case .getAppVersion:
            return "/lookup"
          default :
              return ""
          }
    }
    public var method: Moya.Method {
        switch self {
        case .apiHome, .apiMovie:
            return .get
        default:
            return .post
        }
    }
    public var sampleData: Data {//单元测试
        return Data(base64Encoded: "just for test")!
    }
    public var task: Task {
        switch self {
        case let .apiHome(vsize: vsize):
            return .requestParameters(parameters: ["vsize":vsize], encoding: parameterEncoding);
        case let .apiHomeMore(page: page, size: size, ztid: ztid):
            return .requestParameters(parameters: ["page":(page),"size":(size),"ztid":ztid], encoding: parameterEncoding);
        case let .apiMovie(movieId: movieId, vsize: vsize):
            return .requestParameters(parameters: ["id":movieId,"vsize":vsize], encoding: parameterEncoding);
        case let .apiMovieMore(page: page, size: size, movieId: movieId):
            return .requestParameters(parameters: ["page":(page),"size":(size),"id":movieId], encoding: parameterEncoding);
        case let .apiSearch(page: page, size: size, keyWord: keyWord):
            return .requestParameters(parameters: ["page":(page),"size":(size),"key":keyWord], encoding: parameterEncoding);
        case let .apiShow(movieId: movieId):
            var param = getDefaulParam(type: .detail)
            param["id"] = movieId
            return .requestParameters(parameters: param, encoding: parameterEncoding)
        case let .getAppVersion(appId):
            return .requestParameters(parameters: ["id": appId], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getAppVersion://查询版本号不传请求头
            return nil
        default:
            return [
                "Accept": "*/*",
                "accept-encoding": "br, gzip, deflate",
                "Accept-Language": "en-CN;q=1, zh-CN",
                "Connection": "keep-alive",
                "Content-Type": "application/x-www-form-urlencoded;charset=utf8",
                "origin": self.baseURL.absoluteString,
                "Host": self.baseURL.host ?? ""
            ]
        }
    }
    
    /// 参数编码
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    /// 参数 (在parameters 或task 中配置参数,二选一)
    public var parameters: [String: Any] {
        return [:]
    }
    
    /// HTTP请求成功的状态码(200..<400)
    public var validationType: ValidationType {
        return .successAndRedirectCodes
    }

    //普通模式
    public static func apiMoyaRequest(target: ApiMoya,sucesss:@escaping ((_ object : JSON) ->()),failure:@escaping ((_ error : String) ->())){
                
        apiTime().request(target, callbackQueue: DispatchQueue.main, progress: { (progress) in
            
        }) { (result) in
            switch result{
            case let .success(respond):
                let json = JSON(respond.data)
                
                //该接口返回没有code
                if target.baseURL.absoluteString.contains("itunes.apple.com") {
                    sucesss(json)
                    break
                }
                
                if json["ret"] == 200 {
                    sucesss(json["data"])
                }else{
                    failure("code != 0")
                }
                break
            case let .failure(error):
                failure(error.errorDescription!)
                break
            }
        }
    }
    //使用泛型
    public static func apiRequest<T:HandyJSON>(target: ApiMoya,model:T.Type,sucesss:@escaping ((_ object : T) ->()),failure:@escaping ((_ error : String) ->())){
        apiTime().request(target, callbackQueue: DispatchQueue.main, progress: { (progress) in
            
        }) { (result) in
            switch result{
            case let .success(respond):
                let json = JSON(respond.data)
                if json["ret"] == 200 {
//                    guard let model = JSONDeserializer<T>.deserializeFrom(json:json.rawString()) else { return
//                        failure("data is error");
//                    }
                    guard let model = T.deserialize(from: json.rawString())else{
                        failure("data is error");
                        return
                    }
                    sucesss(model)
                }else{
                    failure("code != 0");
                }
                break
            case let .failure(error):
                failure(error.errorDescription!)
                break
            }
        }
    }
    public static func apiTime(timeInterval:TimeInterval = 10) -> MoyaProvider<ApiMoya> {
        return MoyaProvider<ApiMoya>(manager: defaultAlamofireManager() ,plugins: [SLPrintParameterAndJson()])
    }
}

