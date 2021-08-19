//
//  NSString-Extension.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/28.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

extension String {
    static func localizedString(_ key : String) -> String {
        let language = Locale.preferredLanguages.first
        if let language = language {
            var fileNamePrefix = "zh-Hans"
            if language.hasPrefix("en") {
                fileNamePrefix = "en"
            }
            
            let path: String? = Bundle.main.path(forResource: fileNamePrefix, ofType: "lproj")
            if let path = path {
                let bundle = Bundle.init(path: path)
                var localizedString = bundle?.localizedString(forKey: key, value: nil, table: "HXLocalizable")
                if localizedString == nil {
                    localizedString = key
                }
                return localizedString!
            } else {
                debugPrint("String-\(key)未国际化")
                return key
            }
        } else {
            return key
        }
    }
    
    /// 转URL
    public var toUrl: URL {
        return URL(string: self)!
    }
    
    /// 随机字符串 onlyNumbers 纯数字
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let random_str_numbers = "0123456789"
    
    public static func randomStr(len : Int, onlyNumbers: Bool? = false) -> String {
        var ranStr = ""
        let validRandomStr = onlyNumbers! ? random_str_numbers : random_str_characters
        
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(validRandomStr.count)))
            ranStr.append(validRandomStr[validRandomStr.index(validRandomStr.startIndex, offsetBy: index)])
        }
        return ranStr
    }

    /// 计算高度
    public func calculateHeight(_ font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: 99999)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    /// 计算宽度
    public func calculateWidth(_ font: UIFont, height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: 99999, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    /// 字符串截取函数
    public func hx_subString(to index: Int) -> String {
        if index >= self.count {
            return String(self[..<self.index(self.startIndex, offsetBy: self.count)])
        }
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    /// 字符串截取函数
    public func hx_subString(from index: Int) -> String {
        if index >= self.count {
            return String(self[self.index(self.startIndex, offsetBy: self.count)...])
        }
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    public func hx_subString(from index: Int, offSet: Int) -> String {
        let begin = self.hx_subString(from: index)
        let str = begin.hx_subString(to: offSet)
        return str
    }
    
    /// range转换为NSRange
    public func hx_range(text: String, from range: Range<String.Index>) -> NSRange? {
        let utf16view = text.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }

    /// 获取中间字符串
    public func between(left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards), left != right && leftRange.upperBound != rightRange.lowerBound
            else { return nil }
        
        let rightRangeAgain = range(of: right, options: .backwards)
        return String(self[leftRange.upperBound...right.index(before: (rightRangeAgain?.lowerBound)!)])
        
    }
    
    /// 转换成驼峰格式
    ///
    /// - Returns: a dog -> aDog
    public func camelize() -> String {
        let source = clean(with: " ", allOf: "-", "_")

        if source.contains(" ") {
            let first = source.hx_subString(to: 1)
            let cammel = NSString(format: "%@", (source.capitalized as NSString).replacingOccurrences(of: " ", with: "")) as String
            let rest = String(cammel.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercased.hx_subString(to: 1)
            let rest = String(source.dropFirst())
            return "\(first)\(rest)"
        }
    }

    /// 判断是否包含字符串
    public func contains(substring: String) -> Bool {
        return range(of: substring) != nil
    }
    
    /// 去掉前缀
    public func chompLeft(prefix: String) -> String {
        if let prefixRange = range(of: prefix) {
            if prefixRange.upperBound >= endIndex {
                return String(self[startIndex..<prefixRange.lowerBound])
            } else {
                return String(self[prefixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    // 去掉后缀
    public func chompRight(suffix: String) -> String {
        if let suffixRange = range(of: suffix, options: .backwards) {
            if suffixRange.upperBound >= endIndex {
                return String(self[startIndex..<suffixRange.lowerBound])
            } else {
                return String(self[suffixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    // 增加间隔
    public func collapseWhitespace() -> String {
        let componentsOf = components(separatedBy: NSCharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return componentsOf.joined(separator: " ")
    }
    
    // 用指定字符串替换目标字符串
    public func clean(with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
    
    // 字符串出现次数
    public func count(substring: String) -> Int {
        return components(separatedBy: substring).count-1
    }
    
    // 判断结尾
    public func endsWith(suffix: String) -> Bool {
        return hasSuffix(suffix)
    }
    
    // 固定前缀
    public func ensureLeft(prefix: String) -> String {
        if startsWith(prefix: prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }
    
    // 固定后缀
    public func ensureRight(suffix: String) -> String {
        if endsWith(suffix: suffix) {
            return self
        } else {
            return "\(self)\(suffix)"
        }
    }
    
    // 获取子串的索引
    public func indexOf(substring: String) -> Int? {
        if let range = range(of: substring) {
            return distance(from: startIndex, to: range.lowerBound)
        }
        return nil
    }
    
    public func initials() -> String {
        let words = self.components(separatedBy: " ")
        return words.reduce(""){$0 + $1[0...0]}
    }
    
    public func initialsFirstAndLast() -> String {
        let words = self.components(separatedBy: " ")
        return words.reduce("") { ($0 == "" ? "" : $0[0...0]) + $1[0...0]}
    }
    
    subscript (r: CountableClosedRange<Int>) -> String {
        get {
            let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
            return String(self[startIndex...endIndex])
        }
    }
    
    // 纯字母字符串
    public func isAlpha() -> Bool {
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    // 字母数字
    public func isAlphaNumeric() -> Bool {
        let alphaNumeric = NSCharacterSet.alphanumerics
        return components(separatedBy: alphaNumeric).joined(separator: "").length == 0
    }
    
    // 是否为空
    public func isEmpty() -> Bool {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).length == 0
    }
    
    public var isBlank: Bool {
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
    
    // 数字
    public func isNumeric() -> Bool {
        if let _ = NumberFormatter().number(from: self) {
            return true
        }
        return false
    }
    
    //  拼接字符串
    public func join<S: Sequence>(elements: S) -> String {
        return elements.map{String(describing: $0)}.joined(separator: self)
    }
    
    // 拉丁化
    public func latinize() -> String {
        return self.folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    
    // 获取字符串的行数
    public func lines() -> [String] {
        return self.components(separatedBy: NSCharacterSet.newlines)
    }
    
    // 字符串长度
    var length: Int {
        get {
            return self.count
        }
    }
    
    public func slugify(withSeparator separator: Character = "-") -> String {
        let slugCharacterSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\(separator)")
        return latinize()
            .lowercased()
            .components(separatedBy: slugCharacterSet.inverted)
            .filter { $0 != "" }
            .joined(separator: String(separator))
    }
    
    // 划分字符串
    public func split(separator: Character) -> [String] {
        return self.split{$0 == separator}.map(String.init)
    }
    
    // 匹配开头
    public func startsWith(prefix: String) -> Bool {
        return hasPrefix(prefix)
    }
    
    // 删除标点符号
    public func stripPunctuation() -> String {
        return components(separatedBy: .punctuationCharacters)
            .joined(separator: "")
            .components(separatedBy: " ")
            .filter { $0 != "" }
            .joined(separator: " ")
    }
    
    // 转float
    public func toFloat() -> Float {
        if let number = NumberFormatter().number(from: self) {
            return number.floatValue
        }
        return 0.0
    }
    
    // 转int
    public func toInt() -> Int {
        if let number = NumberFormatter().number(from: self) {
            return number.intValue
        }
        return 0
    }
    
    // 转double
    public func toDouble(locale: Locale = Locale.current) -> Double {
        let nf = NumberFormatter()
        nf.locale = locale as Locale
        if let number = nf.number(from: self) {
            return number.doubleValue
        }
        return 0.0
    }
    
    // 转bool
    public func toBool() -> Bool? {
        let trimmed = self.trimmed().lowercased()
        if trimmed == "true" || trimmed == "false" {
            return (trimmed as NSString).boolValue
        }
        return nil
    }
    
    // 转日期
    public func toDate(format: String = "yyyy-MM-dd") -> NSDate? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = NSLocale.current
        return dateFormatter.date(from: self) as NSDate?
    }
    
    // 转日期时间
    public func toDateTime(format: String = "yyyy-MM-dd HH:mm:ss") -> NSDate? {
        return toDate(format: format)
    }
    
    // 截掉左边
    public func trimmedLeft() -> String {
        if let range = rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines.inverted) {
            return String(self[range.lowerBound..<endIndex])
        }
        return self
    }
    
    // 截掉右边
    public func trimmedRight() -> String {
        if let range = rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines.inverted, options: NSString.CompareOptions.backwards) {
            return String(self[startIndex..<range.upperBound])
        }
        return self
    }
    
    public func trimmed() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    subscript(r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound - r.lowerBound)
            return String(self[startIndex..<endIndex])
        }
    }
    
    public func substring(startIndex: Int, length: Int) -> String {
        if startIndex < 0 {
            return ""
        }
        let start = self.index(self.startIndex, offsetBy: startIndex)
        
        let offset = startIndex + length <= self.count - 1 ? startIndex + length : self.count - 1 - startIndex
        let end = self.index(self.startIndex, offsetBy:offset)
        if start >= end {
            return ""
        }
        return String(self[start..<end])
    }
    
    public subscript(i: Int) -> Character {
        get {
            let index = self.index(startIndex, offsetBy: i)
            return self[index]
        }
    }
    
    /// 格式化金额/价格字符串,如:  1,500.00
    public func formattedPriceString() -> String{
        //初始化NumberFormatter
        let format = NumberFormatter()
        //设置numberStyle（有多种格式）
        format.numberStyle = .currency
        format.currencySymbol = ""
        //转换后的string
        let formattedString = format.string(from: NSNumber(value: self.toDouble()))
        return formattedString ?? "0.00"
    }
    
    /// 四舍五入
    ///
    /// - Parameters:
    ///   - p: 小数点后几位
    /// - Returns: 四舍五入后的结果
    public func preciseDecimal(p : Int) -> String {
        // 为了安全要判空
        if (Double(self) != nil) {
            // 四舍五入
            let decimalNumberHandle : NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode(rawValue: 0)!, scale: Int16(p), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let decimaleNumber : NSDecimalNumber = NSDecimalNumber(value: Double(self)!)
            let resultNumber : NSDecimalNumber = decimaleNumber.rounding(accordingToBehavior: decimalNumberHandle)
            // 生成需要精确的小数点格式，
            // 比如精确到小数点第3位，格式为“0.000”；精确到小数点第4位，格式为“0.0000”；
            // 也就是说精确到第几位，小数点后面就有几个“0”
            var formatterString : String = "0."
            let count : Int = (p < 0 ? 0 : p)
            for _ in 0 ..< count {
                formatterString.append("0")
            }
            let formatter : NumberFormatter = NumberFormatter()
            // 设置生成好的格式，NSNumberFormatter 对象会按精确度自动四舍五入
            formatter.positiveFormat = formatterString
            // 然后把这个number 对象格式化成我们需要的格式，
            // 最后以string 类型返回结果。
            return formatter.string(from: resultNumber)!
        }
        return "0"
    }
    
    /// 四舍五入,限制小数位(2-p),不补零
    ///
    /// - Parameters:
    ///   - p: 小数点后最多保留几位
    /// - Returns: 四舍五入后的结果
    public func preciseDecimalForUnitPrice(p : Int) -> String {
        // 为了安全要判空
        if (Double(self) != nil) {
            // 四舍五入
            let decimalNumberHandle : NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: .plain, scale: Int16(p), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let decimaleNumber : NSDecimalNumber = NSDecimalNumber(value: Double(self)!)
            let resultNumber : NSDecimalNumber = decimaleNumber.rounding(accordingToBehavior: decimalNumberHandle)
            // 生成需要精确的小数点格式，
            // 比如精确到小数点第3位，格式为“0.000”；精确到小数点第4位，格式为“0.0000”；
            // 也就是说精确到第几位，小数点后面就有几个“0”
            var formatterString : String = "0."
            let count : Int = (p < 0 ? 0 : p)
            for _ in 0 ..< count {
                formatterString.append("0")
            }
            let formatter : NumberFormatter = NumberFormatter()
            // 设置生成好的格式，NSNumberFormatter 对象会按精确度自动四舍五入
            formatter.positiveFormat = formatterString
            // 然后把这个number 对象格式化成我们需要的格式，
            // 最后以string 类型返回结果,去掉多余的0,最少保留两位小数
            var result = formatter.string(from: resultNumber)!
            
            while result.hasSuffix("0") && (result.components(separatedBy: ".").last?.count ?? 0 > 2) {
                result.remove(at: result.index(before: result.endIndex))
            }
            return result
        }
        return "0"
    }
    
    /// 获取电话号码
    ///
    /// - Parameter originString: 原始字符串
    /// - Returns: 电话
    public func getPhone() -> String {
        let pattern =  "((((13[0-9])|(15[^4])|(18[0,1,2,3,5-9])|(17[0-8])|(147))\\d{8})|((\\(\\d{3,4}\\)|\\d{3,4}-|\\s)?\\d{7,14}))"
        
        if let result = self.range(of: pattern, options: .regularExpression, range:self.startIndex..<self.endIndex, locale: nil)  {
            return self.substring(with: result)
        } else {
            return ""
        }
    }
    
    /// 包含中文
    public func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
            // 中文字符范围：0x4e00 ~ 0x9fff
            if (0x4e00 < ch.value  && ch.value < 0x9fff) {
                return true
            }
        }
        return false
    }
    
    /// 转化为拼音(不含音标)
    public func transformToPinyin() -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false);
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false);
        let pinyin = stringRef as String;
        //        print(pinyin)
        return pinyin
    }
    
    /// 转化为拼音(不含音标,去掉空格)
    public func transformToPinyinWithoutBlank() -> String {
        var pinyin = self.transformToPinyin().capitalized
        // 去掉空格
        pinyin = pinyin.replacingOccurrences(of: " ", with: "")
        return pinyin
    }
    
    ///拼音首字母,大写
    public func getPinyinHead() -> String {
        // 字符串转换为首字母大写
        let pinyin = self.transformToPinyin().capitalized
        var headPinyinStr = ""
        
        // 获取所有大写字母
        for ch in pinyin {
            if ch <= "Z" && ch >= "A" {
                headPinyinStr.append(ch)
                break;
            }
        }
        return headPinyinStr
    }
    
    /// 是否以特殊字符开头
    public func hasSpecialPrefix() -> Bool {
        let reg = "^[a-zA-Z0-9\\u4e00-\\u9fa5].*"
        let pre = NSPredicate(format: "SELF MATCHES %@", reg)
        if pre.evaluate(with: self) {
            return false
        } else {
            return true
        }
    }
    
    /// 仅包含数字字母
    public func onlyCharAndNumber() -> Bool {
        let reg = "[a-zA-Z0-9]+"
        let pre = NSPredicate(format: "SELF MATCHES %@", reg)
        return pre.evaluate(with: self)
    }
    
    /// 是否以数字开头
    public func isStartWithNum() -> Bool {
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", "^\\b\\d\\S+")
        return predicate.evaluate(with: self)
    }
    
    /// 去掉换行符
    public func removeLineBreak() -> String {
        return self.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: "")
    }
}

extension NSString {
    
    // MARK: 自动计算Label文字决定宽高的封装
    class func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        
        let statusLabelText: NSString = labelStr as NSString
        
        let size = CGSize(width: width, height: 900)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context:nil).size
        
        return strSize.height
        
    }
    
    
    
    func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let statusLabelText: NSString = labelStr as NSString
        
        let size = CGSize(width: 900, height: height)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context:nil).size
        
        return strSize.width
        
    }
    
}
