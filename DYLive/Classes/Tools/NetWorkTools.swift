//
//  NetWorkTools.swift
//  Alamofire的测试
//
//  Created by Mr_Han on 2019/4/17.
//  Copyright © 2019 Mr_Han. All rights reserved.
//  CSDN <https://blog.csdn.net/u010960265>
//  GitHub <https://github.com/HanQiGod>
//

import UIKit
import Alamofire
import CommonCrypto
 
extension String {
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
    
    func longValue() -> u_long {
        return u_long.init(self) ?? 0
    }
}

enum MethodType {
    case get
    case post
}

func getDefaulParam(type: ServerType) -> [String: Any] {
    let time = Date().getTimeStamp()
    let timeinterval = time.longValue()
//    let timeinterval = 1629113581522
    let md5 = "\(timeinterval * 8 - 12)".md5
    
    let parameters = ["service": type.serviceName,
                      "versionCode": 60,
                      "time": time,
                      "md5": md5] as [String : Any]
    return parameters
}

class NetWorkTools {
    
    class func requestData(type: MethodType, URLString: String, parameters: [String : Any]? = nil, finishCallback: @escaping (_ result: AnyObject) -> ()) {
        
        //1. 获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        debugPrint("""
\(URLString) -- \(type)\n
\(parameters?.description ?? "")
""")
        
        //2. 发送请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            //3. 获取数据
            guard let result = response.result.value else {
                print(response.result.error)
                return
            }
            
            //4. 将结果返回
            finishCallback(result as AnyObject)
        }
        
    }

}
