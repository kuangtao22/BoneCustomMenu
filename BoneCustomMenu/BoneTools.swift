//
//  BoneTools.swift
//  YichuanCRM
//
//  Created by 俞旭涛 on 2017/3/25.
//  Copyright © 2017年 俞旭涛. All rights reserved.
//

import UIKit


extension UIImage {
    /// 改变图片颜色
    ///
    /// - Parameter toColor: 改变颜色
    /// - Returns: 改变后的图片
    func color(_ to: UIColor) -> UIImage {
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        to.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}

/// 默认主色调颜色代码
let color_code_default = "#ff493e"
struct AppColor {
    static let navDefault = BoneTools.shared.checkColor(color_code_default)
    static let navLight = BoneTools.shared.checkColor("#fbfbfb")
    
    static func orange(alpha: CGFloat = 1) -> UIColor {  // 橙色
        return BoneTools.shared.checkColor("#ff8400", alpha: alpha)
    }
    static func blue(alpha: CGFloat = 1) -> UIColor {    // 蓝色
        return BoneTools.shared.checkColor("#7abcff", alpha: alpha)
    }
    static func green(alpha: CGFloat = 1) -> UIColor {    // 绿色
        return BoneTools.shared.checkColor("#0a93f3", alpha: alpha)
    }
    static func yellow(alpha: CGFloat = 1) -> UIColor {  // 鹅黄
        return BoneTools.shared.checkColor( "#ffd236", alpha: alpha)
    }
    static func red(alpha: CGFloat = 1) -> UIColor {     // 红色
        return BoneTools.shared.checkColor("#f94242", alpha: alpha)
    }
    static func black(alpha: CGFloat = 1) -> UIColor {
        return BoneTools.shared.checkColor("#000000", alpha: alpha)
    }
    static func white(alpha: CGFloat = 1) -> UIColor {
        return BoneTools.shared.checkColor("#ffffff", alpha: alpha)
    }
    static let line = BoneTools.shared.checkColor("#e8e9eb")          // 线
    static let background = BoneTools.shared.checkColor("#f5f5f5")    // 背景
    static let disabled = BoneTools.shared.checkColor("#fbfbfb")      // 禁用
    
    /// 字体颜色规范
    struct font {
        static let dark = BoneTools.shared.checkColor("#333333")
        static let darkGrey = BoneTools.shared.checkColor("#666666")
        static let grey = BoneTools.shared.checkColor("#999999")
        static let greyLight = BoneTools.shared.checkColor("#c9c9c9")
    }
}

/// 屏幕尺寸
/// - 
/// - width: 屏幕宽度
/// - height: 屏幕高度
/// - navHeight: 导航栏高度
/// - statusBar: 状态栏高度
struct Screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let navHeight: CGFloat = 44
    static let statusBar = UIApplication.shared.statusBarFrame.size.height
}

/// 常用间距
/// -
/// - Ⅰ、Ⅱ、Ⅲ、Ⅳ、Ⅴ、Ⅵ、Ⅶ、Ⅷ、Ⅸ、Ⅹ、Ⅺ、Ⅻ
struct AppSize {
    static var tableHeight: CGFloat {
        return BoneTools.iPhone.is5 ? 45 : 50
    }
    struct spacing {
        static let xii: CGFloat = 60
        static let xi:  CGFloat = 55
        static let x:   CGFloat = 50
        static let ix:  CGFloat = 45
        static let viii:CGFloat = 40
        static let vii: CGFloat = 35
        static let vi:  CGFloat = 30
        static let v:   CGFloat = 25
        static let iv:  CGFloat = 20
        static let iii: CGFloat = 15
        static let ii:  CGFloat = 10
        static let i:   CGFloat = 5
    }
    
    struct radius {
        static let i: CGFloat = 4
        static let ii: CGFloat = 8
    }
}

struct BoneTools {
    private let appId = "1209703132"    // 项目ID
    static var shared = BoneTools()

    /// 判断iphone尺寸
    struct iPhone {
        // iPhone5/5c/5s/SE 4英寸 屏幕宽高：320*568点 屏幕模式：2x 分辨率：1136*640像素
        static var is5: Bool {
            return UIScreen.main.bounds.size.height == 568.0
        }
        // iPhone6/6s/7 4.7英寸 屏幕宽高：375*667点 屏幕模式：2x 分辨率：1334*750像素
        static var is6: Bool {
            return UIScreen.main.bounds.size.height == 667.0
        }
        // iPhone6 Plus/6s Plus/7 Plus 5.5英寸 屏幕宽高：414*736点 屏幕模式：3x 分辨率：1920*1080像素
        static var is6P: Bool {
            return UIScreen.main.bounds.size.height == 736.0
        }
    }
    
    /// 转换class获取参数
    ///
    /// - Parameter anyClass: 需要传的参数(必须要class类型)
    /// - Returns: 字典类型参数
    func getParam(anyClass: Any) -> [String: Any]? {
        let mirror = Mirror(reflecting: anyClass)
        var param = [String: Any]()
        for (key, value) in mirror.children {
            param.updateValue(value, forKey: key!)
        }
        return param
    }
    
    //todo
    /// 根据class名称，获取class
    ///
    /// - Parameter className: class名称
    /// - Returns: class
    public func getClass(className: String) -> AnyClass? {
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            let classStringName = "\(appName).\(className)"
            return NSClassFromString(classStringName)
        }
        return nil
    }
    
    
    /// 状态栏样式
    ///
    /// - Parameter style: `default`黑色 / lightContent白色
    public func statusBar(style: UIStatusBarStyle) {
        UIApplication.shared.statusBarStyle = style
    }
    
    
    /// 求和方法
    ///
    /// - Parameter to: 需要相加的数值
    /// - Returns: 返回所有to总数
    public func sum(to: Double...) -> Double {
        return to.reduce(0,{ $0 + $1 })
    }
    

    /// 打开APP设置
    ///
    /// - Parameter type: URL类型
    public func openUrl(type: AppURLType) {
        switch type {
        case .setting:
            if #available(iOS 8.0, *) {
                self.open(url: URL(string: UIApplicationOpenSettingsURLString))
            }
        default:
            self.open(url: URL(string: String(format: "%@%@", type.rawValue, self.appId)))
        }
    }
    
    /// 打开URL
    ///
    /// - Parameter url: url description
    private func open(url: URL?) {
        guard let url = url else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (bool) in
                
            }
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    /// App链接类型
    ///
    /// - setting: App设置
    /// - download: App下载
    /// - evaluate: App评价
    enum AppURLType: String {
        case setting
        case download = "https://itunes.apple.com/us/app/%E4%BC%A0%E8%B4%9D/id"
        case evaluate = "itms-apps://itunes.apple.com/app/id"
    }
    
    /// 打开电话
    ///
    /// - Parameter mobile: 固定电话/手机号码
    public func open(mobile: String) {
        if mobile.isTelephone || mobile.isMobile {
            self.open(url: URL(string: "tel://\(mobile)"))
        }
    }
    
    // 获取版本
    public func getVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }

    /// 16进制颜色值转换为UIColor
    ///
    /// - Parameters:
    ///   - code: 16进制颜色值
    ///   - alpha: 透明度
    /// - Returns: 返回颜色
    public func checkColor(_ code: String, alpha: CGFloat = 1) -> UIColor {
        var cString: String = code.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count < 6 {return UIColor.black}
        if cString.hasPrefix("0X") {cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))}
        if cString.hasPrefix("#") {cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))}
        if cString.count != 6 {return UIColor.black}
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    /// 返回一张纯色图片
    ///
    /// - Parameter color: color description
    /// - Returns: return value description
    public func imageTo(color: UIColor) -> UIImage {
        let rect:CGRect = CGRect(x: 0, y: 0, width: 1, height: 1) // 描述矩形
        UIGraphicsBeginImageContext(rect.size) // 开启位图上下文
        let context:CGContext = UIGraphicsGetCurrentContext()! // 获取位图上下文
        context.setFillColor(color.cgColor) // 使用color演示填充上下文
        context.fill(rect)
        let theImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return theImage
    }
    
    
    /// 获取文字高度
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - font: 字号
    ///   - width: 宽度
    /// - Returns: 返回高度
    public func getTextHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.height
    }
    
    
    /// 获取文字宽度
    ///
    /// - Parameters:
    ///   - text: 文字内容
    ///   - font: 字号
    ///   - height: 宽度
    /// - Returns: 返回高度
    public func getTextWidth(text: String,font: UIFont, height: CGFloat) -> CGFloat {
        let size = CGSize(width: 1000, height: height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.width
    }
    
}


