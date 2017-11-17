//
//  BoneCustomMenuDelegate.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/7.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

/// 格式
struct BoneMenuIndexPath {
    var column: Int     // 一级列
    var section: Int    // 区
    var row: Int        // 行
}

/// 主菜单信息(名称/类型)
struct BoneMenuColumnInfo {
    var title: String
    var type: BoneMenuColumnType
}

/// 主菜单触发类型
enum BoneMenuColumnType {
    case button         // 直接触发
    case list           // 列表菜单
    case filterList     // 多选列表
    case filter         // 筛选菜单
    case calendar       // 日历
}

/// 筛选类型
enum BoneMenuSelectType {
    case only   // 单选
    case multi  // 多选
}

protocol BoneMenuDataSource {
    

    /// 返回 boneMenu 有多少列 ，默认1列
    ///
    /// - Parameter menu
    /// - Returns
    func numberOfColumns(_ menu: BoneCustomMenu) -> Int
    
    
    /// 返回 boneMenu 第column列有多少行
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, numberOfSectionsInColumn column: Int) -> Int
    
    
    
    
    /// 返回 boneMenu 第column列section区有多少行
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    ///   - section:
    /// - Returns: 二级列表行数
    func boneMenu(_ menu: BoneCustomMenu, numberOfRowsInSections indexPath: BoneMenuIndexPath) -> Int
    
    
    
    
    /// 返回 boneMenu column类型
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, typeForColumnAt column: Int) -> BoneMenuColumnInfo
    
    
    /// 返回每列菜单高度
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, menuHeightFor column: Int) -> CGFloat?
    
    
    /// 返回 boneMenu section标题
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    ///   - section:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, titleForSectionAt indexPath: BoneMenuIndexPath) -> String
    
    
    
    
    
    /// 返回 boneMenu row标题
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, titleForRowAt indexPath: BoneMenuIndexPath) -> String
    
    
    
    
    
    /// 返回 boneMenu filter section选择类型
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns: 多选/单选
    func boneMenu(_ menu: BoneCustomMenu, filterDidForSectionAt indexPath: BoneMenuIndexPath) -> BoneMenuSelectType?
    
    
}

protocol BoneMenuDelegate: NSObjectProtocol {
    
    /// boneMenu 常规 点击事件
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtIndexPath indexPath: BoneMenuIndexPath)

    
    /// boneMenu Section 点击事件
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    ///   - section:
    func boneMenu(_ menu: BoneCustomMenu, didSelectSectionAtColumn column: Int, section: Int)
    
    /// boneMenu filter 点击事件
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtColumn indexPaths: [BoneMenuIndexPath])
    
    
    
    /// 日历点击事件
    ///
    /// - Parameters:
    ///   - menu:
    ///   - date:
    ///   - error:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, didSelectCalendar date: [Date], error: String?)
    
    /// 显示筛选器坐标
    func boneBar(_ barView: BoneMenuBarView, contentOffsetY: CGFloat)
}



extension BoneMenuDataSource {
    
    func boneMenu(_ menu: BoneCustomMenu, titleForRowAt indexPath: BoneMenuIndexPath) -> String {
        return ""
    }
    
    func boneMenu(_ menu: BoneCustomMenu, numberOfSectionsInColumn column: Int) -> Int {
        return 1
    }
    
    func boneMenu(_ menu: BoneCustomMenu, menuHeightFor column: Int) -> CGFloat? {
        return nil
    }
    
    func boneMenu(_ menu: BoneCustomMenu, filterDidForSectionAt indexPath: BoneMenuIndexPath) -> BoneMenuSelectType? {
        return BoneMenuSelectType.only
    }
}


extension BoneMenuDelegate {
    
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtIndexPath indexPath: BoneMenuIndexPath) {
        
    }
    
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtColumn indexPaths: [BoneMenuIndexPath]) {
        
    }
    
    func boneMenu(_ menu: BoneCustomMenu, didSelectCalendar date: [Date], error: String?) {
        
    }
    
    func boneMenu(_ menu: BoneCustomMenu, didSelectSectionAtColumn column: Int, section: Int) {
        
    }
    
    func boneBar(_ barView: BoneMenuBarView, contentOffsetY: CGFloat) {
        
    }
}

