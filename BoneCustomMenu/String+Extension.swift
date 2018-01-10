//
//  String+Extension.swift
//  EasyPayStore
//
//  Created by 俞旭涛 on 2017/3/23.
//  Copyright © 2017年 俞旭涛. All rights reserved.
//

import UIKit

extension String {
    
    
    /// 转换双精度型(如小数点后为0，自动去0)
    var double: Double {
        return NumberFormatter().number(from: self)?.doubleValue ?? 0
    }
    
    /// 验证邮箱
    var isEmail: Bool {
        let regex = "[A-Z0-9a-z._% -] @[A-Za-z0-9.-] \\.[A-Za-z]{2,4}"
        return self.regex(format: regex)
    }
    
    /// 验证手机(手机号以13,15,17,18开头，八个 \d 数字字符)
    var isMobile: Bool {
        let regex = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
        return self.regex(format: regex)
    }
    
    /// 隐藏手机号(格式:138****9999)
    var hideMobile: String {
        let a = self.getSubstring(offset: 3)
        let b = self.getSubstring(offset: -4)
        return String(format: "%@****%@",a,b)
    }
    
    /// 验证固定电话(格式:0573-88090005)
    var isTelephone: Bool {
        let regex = "(\\(\\d{3,4}\\)|\\d{3,4}-|\\s)?\\d{8}"
        return self.regex(format: regex)
    }
    
    /// 判断http
    var isHttp: Bool {
        let regex = "^(((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp)://)|(www\\.))+(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(/[a-zA-Z0-9\\&%_\\./-~-]*)?$"
        return self.regex(format: regex)
    }
    
    /// 正则表达式
    ///
    /// - Parameter to: 正则
    /// - Returns: 返回判断结果
    private func regex(format: String) -> Bool {
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", format)
        return phonePredicate.evaluate(with: self)
    }
    
    /// 字符串分割
    ///
    /// - Parameter format: 分割符
    /// - Returns: 数组
    func separated(format: String) -> [String] {
        return self.components(separatedBy: format)
    }
    
    /// 判断是否包含字符串
    ///
    /// - Parameter to: 包含字符串
    /// - Returns: 返回是否找到to字符串
    func isContain(to: String) -> Bool {
        return self.range(of: to) != nil
    }
    
    /// 替换字符串分隔符
    ///
    /// - Parameters:
    ///   - to: 原来分隔符
    ///   - format: 替换分隔符
    /// - Returns: 替换后字符串
    func replace(to: String, format: String) -> String {
        let array = self.separated(format: to)
        return array.joined(separator: format)
    }
    
    /// 拷贝剪切板
    func copy() {
        UIPasteboard.general.string = self
    }
    
    /// 大写字母
    var uppercase: String {
        get { return self.uppercased() }
    }
    
    /// 小写字母
    var lowercase: String {
        get { return self.lowercased() }
    }
    
    /// 去除空格
    var delSpace: String {
        get { return String(self.filter { $0 != " " }) }
    }
    
    /// 判断整型
    var isInt: Bool {
        get {
            let scan: Scanner = Scanner(string: self)
            var val:Int = 0
            return scan.scanInt(&val) && scan.isAtEnd
        }
    }
    
    /// 判断浮点型
    var isFloat: Bool {
        get {
            let scan: Scanner = Scanner(string: self)
            var val: Float = 0
            return scan.scanFloat(&val) && scan.isAtEnd
        }
    }
    
    /// 添加编码
    var addEncoding: String {
        get { return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics) ?? "" }
    }
    
    /// 解码
    var delEncoding: String {
        get { return self.removingPercentEncoding ?? "" }
    }
    
    
    /// 截取字符串
    ///
    /// - Parameter offset: 偏移位置(正数从左到右 / 负数从右到左)
    /// - Returns: 最终截取子字符串
    func getSubstring(offset: Int) -> String {
        guard self.count > abs(offset) else {
            return ""
        }
        if offset > 0 {
            let mobile = self.index(self.startIndex, offsetBy: abs(offset))
            return self.substring(to: mobile)
        } else {
            let mobile = self.index(self.endIndex, offsetBy: -abs(offset))
            return self.substring(from: mobile)
        }
    }
}

