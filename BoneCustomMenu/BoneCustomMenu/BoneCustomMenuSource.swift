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
    var delegate: BoneMenuDelegate?
    
    var dataSource: BoneMenuDataSource?
    
    /// 所有选中索引
    var selectIndexPaths: [BoneIndexPath] {
        get { return self.selectArray }
        set { self.selectArray = newValue }
    }
    
    /// 判断是否有二级分类
    var isTwoCol: Bool {
        get { return self.sectionNum() > 0 }
    }
    
    /// column标题
    func columnInfo(_ column: Int) -> ColumnInfo {
        let defaultInfo = ColumnInfo(title: "", type: .button)
        return self.dataSource?.boneMenu(self.menu, typeForColumnAt: column) ?? defaultInfo
    }
    
    /// 过滤器，可把不存在的indexPaht剔除
    func filterIndexPaths(_ indexPath: [BoneIndexPath]) -> [BoneIndexPath] {
        return indexPath.filter {
            $0.column < self.columnNum && $0.section < self.sectionNum($0.column) && $0.row < self.rowNum($0)
        }
    }
    
    /// section标题
    func sectionTitle(_ section: Int) -> String {
        let indexPath = BoneIndexPath(column: self.currentSelect, section: section, row: 0)
        return self.dataSource?.boneMenu(self.menu, titleForSectionAt: indexPath) ?? ""
    }
    
    /// row标题
    func rowTitle(_ indexPath: BoneIndexPath) -> String {
        return self.dataSource?.boneMenu(self.menu, titleForRowAt: indexPath) ?? ""
    }
    
    /// 列数
    var columnNum: Int {
        get { return self.dataSource?.numberOfColumns(self.menu) ?? 0 }
    }
    
    /// 分区数(column如果为空，则返回当前分区数量)
    func sectionNum(_ column: Int? = nil) -> Int {
        return self.dataSource?.boneMenu(self.menu, numberOfSectionsInColumn: column ?? self.currentSelect) ?? 0
    }
    
    /// 行数
    func rowNum(_ indexPath: BoneIndexPath) -> Int {
        return self.dataSource?.boneMenu(self.menu, numberOfRowsInSections: indexPath) ?? 0
    }
    
    /// 选择类型
    func selectType(_ section: Int) -> SelectType {
        let indexPath = BoneIndexPath(column: self.currentSelect, section: section, row: 0)
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
        return self.rowTitle(self.selectIndexPaths[index])
    }
    
    /// 获取某个选中的indexPath（用于barView）
    func selectIndexPath(_ index: Int) -> BoneIndexPath {
        return self.selectIndexPaths[index]
    }
    
    /// 删除某个选中indexPath（用于barView）
    func delSelectIndexPath(_ index: Int) {
        self.selectIndexPaths.remove(at: index)
//        self.selectArray = self.selectArray.filter {
//            ($0.column != indexPath.column) && ($0.section != indexPath.section) && ($0.row != indexPath.row)
//        }
    }
    
    /// 更新indexPaths
    func updata(_ indexPaths: [IndexPath]) {
        self.selectArray = self.selectArray.filter { $0.column != self.currentSelect }
        for index in indexPaths {
            self.selectArray.append(BoneIndexPath(column: self.currentSelect, section: index.section, row: index.row))
        }
        self.delegate?.boneMenu(self.menu, didSelectRowAtColumn: self.currentSelect, indexPaths: self.indexPathsForColumn)
    }
    
    /// 更新indexPath
    func updata(_ indexPath: IndexPath) {
        self.selectArray = self.selectArray.filter { $0.column != self.currentSelect }
        self.selectArray.append(BoneIndexPath(column: self.currentSelect, section: indexPath.section, row: indexPath.row))
        let current = self.selectArray.filter { $0.column == self.currentSelect }
        self.delegate?.boneMenu(self.menu, didSelectRowAtIndexPath: current[0])
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
            self.selectArray = [BoneIndexPath]()
            for i in 0..<dataSource.numberOfColumns(self.menu) {
                self.selectArray.append(BoneIndexPath(column: i, section: 0, row: 0))
            }
        }
    }
    
    /// 获取弹出菜单高度
    func menuHeight(_ column: Int? = nil) -> CGFloat {
        if let column = column {
            return self.dataSource?.boneMenu(self.menu, menuHeightFor: column) ?? self.defaultMenuheight
        }
        return self.defaultMenuheight
    }
    
    fileprivate var selectArray = [BoneIndexPath]()
    
    fileprivate var menu: BoneCustomMenu
    /// 默认菜单高度
    fileprivate let defaultMenuheight = UIScreen.main.bounds.height * 0.5
    
    init(menu: BoneCustomMenu) {
        self.menu = menu
        self.initData()
    }
}



extension BoneCustomMenuSource {
    
    /// 格式
    struct BoneIndexPath {
        var column: Int     // 一级列
        var section: Int    // 区
        var row: Int        // 行
    }
    
    /// 主菜单信息(名称/类型)
    struct ColumnInfo {
        var title: String
        var type: ColumnType
    }
    
    /// 主菜单触发类型
    enum ColumnType {
        case button         // 直接触发
        case list           // 列表菜单
        case filterList     // 多选列表
        case filter         // 筛选菜单
        case calendar       // 日历
    }
    
    /// 筛选类型
    enum SelectType {
        case only   // 单选
        case multi  // 多选
    }
}
