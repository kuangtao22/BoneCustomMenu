//
//  BoneCustomMenuDelegate.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/7.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneMenuDataSource {
    
    typealias BoneIndexPath = BoneCustomMenuSource.BoneIndexPath
    typealias ColumnInfo = BoneCustomMenuSource.ColumnInfo
    typealias ColumnType = BoneCustomMenuSource.ColumnType
    typealias SelectType = BoneCustomMenuSource.SelectType
    
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
    func boneMenu(_ menu: BoneCustomMenu, numberOfRowsInSections indexPath: BoneIndexPath) -> Int
    
    
    
    
    /// 返回 boneMenu column类型
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, typeForColumnAt column: Int) -> ColumnInfo
    
    
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
    func boneMenu(_ menu: BoneCustomMenu, titleForSectionAt indexPath: BoneIndexPath) -> String
    
    
    
    
    
    /// 返回 boneMenu row标题
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, titleForRowAt indexPath: BoneIndexPath) -> String
    
    
    
    
    
    /// 返回 boneMenu filter section选择类型
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns: 多选/单选
    func boneMenu(_ menu: BoneCustomMenu, filterDidForSectionAt indexPath: BoneIndexPath) -> SelectType?
    
    
}

protocol BoneMenuDelegate: NSObjectProtocol {
    
    typealias BoneIndexPath = BoneCustomMenuSource.BoneIndexPath
    typealias ColumnInfo = BoneCustomMenuSource.ColumnInfo
    typealias ColumnType = BoneCustomMenuSource.ColumnType
    typealias SelectType = BoneCustomMenuSource.SelectType
    
    /// boneMenu 常规 点击事件
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtIndexPath indexPath: BoneIndexPath)

    
    
    
    /// boneMenu filter 点击事件
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtColumn column: Int, indexPaths: [IndexPath])
    
    
    
    /// 日历点击事件
    ///
    /// - Parameters:
    ///   - menu:
    ///   - date:
    ///   - error:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, didSelectCalendar date: [Date], error: String?)
    
    
}



extension BoneMenuDataSource {
    
    func boneMenu(_ menu: BoneCustomMenu, titleForRowAt indexPath: BoneIndexPath) -> String {
        return ""
    }
    
    func boneMenu(_ menu: BoneCustomMenu, numberOfSectionsInColumn column: Int) -> Int {
        return 1
    }
    
    func boneMenu(_ menu: BoneCustomMenu, menuHeightFor column: Int) -> CGFloat? {
        return nil
    }
    
    func boneMenu(_ menu: BoneCustomMenu, filterDidForSectionAt indexPath: BoneIndexPath) -> SelectType? {
        return SelectType.only
    }
}


extension BoneMenuDelegate {
    
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtIndexPath indexPath: BoneIndexPath) {
        
    }
    
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtColumn column: Int, indexPaths: [IndexPath]) {
        
    }
    
    func boneMenu(_ menu: BoneCustomMenu, didSelectCalendar date: [Date], error: String?) {
        
    }
    
   
}
