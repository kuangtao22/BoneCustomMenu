//
//  BoneCustomMenuDataSour.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/14.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCustomMenuSource {

    /// 当前选中菜单
    var currentSelect = 0
    
    /// 代理协议
    weak var delegate: BoneMenuDelegate?
    
    weak var dataSource: BoneMenuDataSource?
    
    /// 所有选中索引
    var selectIndexPaths: [BoneMenuIndexPath] {
        get { return self.selectArray }
        set { self.selectArray = newValue }
    }
    
    /// 判断是否有二级分类
    var isTwoCol: Bool {
        get { return self.sectionNum() > 0 }
    }
    
    /// 获取弹出菜单高度
    var menuHeight: CGFloat {
        get {
            return self.dataSource?.boneMenu(self.menu, menuHeightFor: self.currentSelect) ?? self.defaultMenuheight
        }
    }
    
    /// column标题
    func columnInfo(_ column: Int) -> BoneMenuColumnInfo {
        let defaultInfo = BoneMenuColumnInfo(title: "", type: .button)
        return self.dataSource?.boneMenu(self.menu, typeForColumnAt: column) ?? defaultInfo
    }
    
    /// 获取自定义view
    func customView(_ column: Int) -> UIView? {
        return self.dataSource?.boneMenu(self.menu, customViewForSectionAt: column)
    }
    
    /// 过滤器，可把不存在的indexPaht剔除
    func filterIndexPaths(_ indexPath: [BoneMenuIndexPath]) -> [BoneMenuIndexPath] {
        return indexPath.filter {
            $0.column < self.columnNum && $0.section < self.sectionNum($0.column) && $0.row < self.rowNum($0)
        }
    }
    
    /// section标题
    func sectionTitle(_ section: Int) -> String {
        let indexPath = BoneMenuIndexPath(column: self.currentSelect, section: section, row: 0)
        return self.dataSource?.boneMenu(self.menu, titleForSectionAt: indexPath) ?? ""
    }
    
    /// row标题
    func rowTitle(_ indexPath: BoneMenuIndexPath) -> String {
        return self.dataSource?.boneMenu(self.menu, titleForRowAt: indexPath) ?? ""
    }
    
    /// 列数
    var columnNum: Int {
        get { return self.dataSource?.numberOfColumns(self.menu) ?? 0 }
    }
    
    /// 分区数(column如果为空，则返回当前分区数量)
    func sectionNum(_ column: Int? = nil) -> Int {
        let sectionNum = self.dataSource?.boneMenu(self.menu, numberOfSectionsInColumn: column ?? self.currentSelect)
        return sectionNum ?? 0
    }
    
    /// 行数
    func rowNum(_ indexPath: BoneMenuIndexPath) -> Int {
        if (self.sectionNum() > indexPath.section) || (self.sectionNum() == 0) {
            return self.dataSource?.boneMenu(self.menu, numberOfRowsInSections: indexPath) ?? 0
        }
        return 0
    }
    
    /// 选择类型
    func selectType(_ section: Int) -> BoneMenuSelectType {
        let indexPath = BoneMenuIndexPath(column: self.currentSelect, section: section, row: 0)
        return self.dataSource?.boneMenu(self.menu, filterDidForSectionAt: indexPath) ?? .only
    }
    
    /// 获取当前选中column的IndexPaths
    var indexPathsForColumn: [IndexPath] {
        get {
            let array = self.selectIndexPaths.filter { $0.column == self.currentSelect }
            var indexPath = [IndexPath]()
            for i in array {
                indexPath.append(IndexPath(row: i.row, section: i.section))
            }
            return indexPath
        }
    }
    
    /// 获取所有选中标题
    var selectAllTitles: [String] {
        get { return self.selectIndexPaths.map { self.rowTitle($0) }}
    }
    
    /// 获取选中的某一个标题（用于barView）
    func selectTitle(_ index: Int) -> String {
        if self.selectIndexPaths.count > index {
            return self.rowTitle(self.selectIndexPaths[index])
        }
        return ""
    }
    
    /// 获取某个选中的indexPath（用于barView）
    func selectIndexPath(_ index: Int) -> BoneMenuIndexPath {
        return self.selectIndexPaths[index]
    }
    
    /// 删除某个选中indexPath（用于barView）
    func updata(_ index: Int, cellback: Cellback?) {
        self.selectIndexPaths.remove(at: index)
        cellback?()
        self.delegate?.boneMenu(self.menu, didSelectRowAtColumn: self.selectIndexPaths)
    }
    
    /// 更新indexPaths
    func updata(_ indexPaths: [IndexPath], cellback: Cellback?) {
        self.selectArray = self.selectArray.filter { $0.column != self.currentSelect }
        for index in indexPaths {
            let index = BoneMenuIndexPath(column: self.currentSelect, section: index.section, row: index.row)
            self.selectArray.append(index)
        }
        cellback?()
        self.delegate?.boneMenu(self.menu, didSelectRowAtColumn: self.selectIndexPaths)
    }

    
    /// 更新indexPath
    func updata(_ indexPath: IndexPath) {
        self.selectArray = self.selectArray.filter { $0.column != self.currentSelect }
        self.selectArray.append(BoneMenuIndexPath(column: self.currentSelect, section: indexPath.section, row: indexPath.row))
        let current = self.selectArray.filter { $0.column == self.currentSelect }
        self.delegate?.boneMenu(self.menu, didSelectRowAtIndexPath: current[0])
    }

    
    /// 全部删除
    func delAll(cellback: Cellback?) {
        self.selectArray = []
        cellback?()
        self.delegate?.boneMenu(self.menu, didSelectRowAtColumn: self.selectIndexPaths)
    }
    
    func onClickSection(_ section: Int) {
        self.delegate?.boneMenu(self.menu, didSelectSectionAtColumn: self.currentSelect, section: section)
    }
    
    /// 初始化数据
    func initData() {
        guard let dataSource = self.dataSource else {
            return
        }
        if self.selectArray.isEmpty {
            self.selectArray = [BoneMenuIndexPath]()
            for i in 0..<dataSource.numberOfColumns(self.menu) {
                self.selectArray.append(BoneMenuIndexPath(column: i, section: 0, row: 0))
            }
        }
    }
    
    
    fileprivate var selectArray = [BoneMenuIndexPath]()
    
    fileprivate var menu: BoneCustomMenu
    /// 默认菜单高度
    fileprivate let defaultMenuheight = UIScreen.main.bounds.height * 0.5
    typealias Cellback = () -> ()
    
    init(menu: BoneCustomMenu) {
        self.menu = menu
        self.initData()
    }
}

