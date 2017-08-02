//
//  BoneCustomMenuDelegate.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/7.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneCustomMenuDelegate: NSObjectProtocol {
    
    
    /// boneMenu 常规 点击事件
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtIndexPath indexPath: BoneCustomPopup.IndexPath)

    
    
    
    /// boneMenu filter 点击事件
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtColumn column: Int, filterDatas: [[Int]])
    
    
    
    
    
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
    func boneMenu(_ menu: BoneCustomMenu, numberOfRowsInSections indexPath: BoneCustomPopup.IndexPath) -> Int
    
    
    
    
    /// 返回 boneMenu column类型
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, typeForColumnAt column: Int) -> BoneCustomPopup.ColumnInfo
    
    
    
    
    
    /// 返回 boneMenu section标题
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    ///   - section:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, titleForSectionAt indexPath: BoneCustomPopup.IndexPath) -> String
    
    
    
    
    
    /// 返回 boneMenu row标题
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, titleForRowAt indexPath: BoneCustomPopup.IndexPath) -> String
    
    
    
    
    
    /// 返回 boneMenu filter section选择类型
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns: 多选/单选
    func boneMenu(_ menu: BoneCustomMenu, filterDidForSectionAt indexPath: BoneCustomPopup.IndexPath) -> BoneCustomPopup.FilterType?
    
    
}

extension BoneCustomMenuDelegate {
    
    
    func boneMenu(_ menu: BoneCustomMenu, filterDidForSectionAt indexPath: BoneCustomPopup.IndexPath) -> BoneCustomPopup.FilterType? {
        return BoneCustomPopup.FilterType.only
    }
    
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtColumn column: Int, filterDatas: [[Int]]) {
        
    }
    func boneMenu(_ menu: BoneCustomMenu, titleForRowAt indexPath: BoneCustomPopup.IndexPath) -> String {
        return ""
    }
    func boneMenu(_ menu: BoneCustomMenu, numberOfRowsInSections indexPath: BoneCustomPopup.IndexPath) -> Int {
        return 0
    }
}
