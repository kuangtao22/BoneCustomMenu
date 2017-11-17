//
//  BoneCustomListsDelegate.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/11.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneCustomDelegate: NSObjectProtocol {
    
    /// section数量
    func numberOfSection() -> Int
    
    /// row数量
    func numberOfRows(_ section: Int) -> Int
    
    /// section标题
    func titleOfSection(_ section: Int) -> String
    
    /// row标题
    func titleForSectionInRow(_ section: Int, row: Int) -> String
    
//    func getSelectData() -> BoneCustomListsView.SelectData
    
    /// 是否有数据
    func isTwoCol() -> Bool
    
    /// 获取section内选择模式（单选/多选）
    func filterTypeOfSection(_ section: Int) -> BoneMenuSelectType
    
    /// 获取已选中选中IndexPaths
    func getSelectIndexPaths() -> [IndexPath]
    
    /// 点击row事件
    func didSelectAtRow(_ indexPath: IndexPath)
    
    /// 点击section事件
    func didSelect(_ section: Int)
    
    /// 点击确认按钮事件
    func buttonSelect(_ indexPaths: [IndexPath], isConfirm: Bool)
}
