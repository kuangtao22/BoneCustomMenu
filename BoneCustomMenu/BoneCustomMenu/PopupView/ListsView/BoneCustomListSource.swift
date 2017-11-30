//
//  BoneCustomListDataSource.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/14.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCustomListSource {
    
    /// 代理方法
    var delegate: BoneCustomDelegate?
    
    /// 当前选中rightTabel row
    var selectRow: IndexPath {
        get { return self.selectIndexPath }
        set { self.selectIndexPath = newValue }
    }
    
    var isTwoCol: Bool {
        get {
            return self.delegate?.isTwoCol() ?? false
        }
    }
    
    /// 左边表格宽度
    var leftWidth: CGFloat {
        get { return self.isTwoCol ? UIScreen.main.bounds.width * 0.3 : 0 }
    }
    
    /// 右边表格宽度
    var rightWidth: CGFloat {
        get { return self.isTwoCol ? (UIScreen.main.bounds.width - self.leftWidth) : UIScreen.main.bounds.width }
    }
    
    /// 是否隐藏左边表格
    var isLeftHidden: Bool {
        get { return self.isTwoCol ? false : true }
    }
    
    /// row的状态是否选中
    func rowState(_ row: Int) -> Bool {
        return (self.selectSection == self.selectRow.section) && (self.selectRow.row == row)
    }
    
    /// section的状态是否选中
    func sectionState(_ row: Int) -> Bool {
        return (row == self.selectSection)
    }
    
    /// 行数
    /// 如果是左边列表或是只有一列数据
    /// - Parameter isLeft: 左边列表
    func rowNum(_ isLeft: Bool) -> Int {
        if isLeft {
            return self.delegate?.numberOfSection() ?? 0
        } else {
            if self.isTwoCol {
                return self.delegate?.numberOfRows(self.selectSection) ?? 1
            } else {
                return self.delegate?.numberOfRows(0) ?? 1
            }
        }
    }
    
    func sectionTitle(_ row: Int) -> String? {
        return self.delegate?.titleOfSection(row)
    }
    
    func rowTitle(_ row: Int) -> String? {
        return self.delegate?.titleForSectionInRow(self.selectSection, row: row)
    }
    
    /// 左边tableView点击事件
    func onClickLeft(_ section: Int) {
        self.selectSection = section
        if self.isTwoCol {
            self.delegate?.didSelect(self.selectSection)
        }
    }
    
    /// 右边tableView点击事件
    func onClickRight(_ row: Int) {
        self.selectRow = IndexPath(row: row, section: self.selectSection)
        self.delegate?.didSelectAtRow(self.selectRow)
    }

    /// 初始化数据
    func initData() {
        guard let delegate = self.delegate else {
            return
        }
        let indexPaths = delegate.getSelectIndexPaths()
        if indexPaths.count > 0 {
            self.selectIndexPath = indexPaths[0]
            self.selectSection = indexPaths[0].section
            
        } else {
            self.selectIndexPath = IndexPath(row: 0, section: self.selectSection)
        }
    }
    
    var selectSection = 0           // 点击左边tableView
    fileprivate var selectIndexPath: IndexPath // 右边tableView
    
    init() {
        self.selectIndexPath = IndexPath(row: 0, section: 0)
        self.initData()
    }
}
