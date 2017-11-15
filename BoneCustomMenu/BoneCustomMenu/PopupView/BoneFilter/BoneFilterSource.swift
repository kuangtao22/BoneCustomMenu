//
//  BoneFilterDataSource.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/10.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneFilterSource {
    
    /// 代理方法
    var delegate: BoneCustomDelegate?
    
    var isTwoCol: Bool {
        get { return self.delegate?.isTwoCol() ?? false }
    }
    
    /// 左边表格宽度
    var leftWidth: CGFloat {
        get { return self.isTwoCol ? UIScreen.main.bounds.width * 0.3 : 0 }
    }
    
    var rightWidth: CGFloat {
        get { return self.isTwoCol ? (UIScreen.main.bounds.width - self.leftWidth) : UIScreen.main.bounds.width }
    }
    
    /// 是否隐藏左边表格
    var isLeftHidden: Bool {
        get { return self.isTwoCol ? false : true }
    }
    
    var selectIndexPaths: [IndexPath] {
        get {return self.selectArray}
    }
    
    /// 获取section中row的和
    func rowSumFor(_ section: Int) -> Int {
        let current = self.selectIndexPaths.filter {$0.section == section}
        return current.count
    }

    /// 获取分区数量
    var sectionNum: Int {
        get { return self.delegate?.numberOfSection() ?? 0 }
    }
    
    /// 获取行数
    func rowNum(_ section: Int) -> Int {
        return self.delegate?.numberOfRows(section) ?? 0
    }

    /// 获取标题
    func sectionTitle(_ section: Int) -> String {
        return self.delegate?.titleOfSection(section) ?? ""
    }
    
    /// 获取副标题
    func rowTitle(_ indexPath: IndexPath) -> String {
        return self.delegate?.titleForSectionInRow(indexPath.section, row: indexPath.item) ?? ""
    }
    
    /// section的状态是否选中
    func sectionState(_ row: Int) -> Bool {
        return (row == self.selectSection)
    }
    
    /// 获取row选中状态
    func rowState(_ indexPath: IndexPath) -> Bool {
        if self.selectArray.count > 0 {
            return self.selectArray.contains(indexPath)
        }
        return false
    }
    
    /// 获取选择类型(多选/单选)
    func getSelectType(_ section: Int) -> BoneCustomMenuSource.SelectType {
        return self.delegate?.filterTypeOfSection(section) ?? .only
    }
    
    /// 左边tableView点击事件
    func onClickLeft(_ section: Int) {
        self.selectSection = section
        if self.isTwoCol {
            self.delegate?.didSelect(self.selectSection)
        }
    }
    
    /// 右边点击indexPath,如果已选中则取消
    func onClickRight(_ indexPath: IndexPath) {
        if self.selectArray.contains(indexPath) {
            let items = self.selectArray.filter { $0 != indexPath }
            self.selectArray = items
        } else {
            switch self.getSelectType(indexPath.section) {
            case .only:
                let items = self.selectArray.filter { $0.section != indexPath.section }
                self.selectArray = items
                self.selectArray.append(indexPath)
                
            case .multi:
                self.selectArray.append(indexPath)
            }
        }
    }
    
    /// 清空数据
    func cleanData() {
        self.selectArray = []
        self.delegate?.buttonSelect(self.selectArray, isConfirm: false)
    }
    
    /// 提交数据
    func submitData() {
        self.delegate?.buttonSelect(self.selectArray, isConfirm: true)
    }
    
    /// 初始化数据
    func initData() {
        guard let delegate = self.delegate else {
            return
        }
        self.selectSection = 0
        self.selectArray = delegate.getSelectIndexPaths()
    }
    
    

    fileprivate var selectArray = [IndexPath]()
    var selectSection = 0  // 记录左边点击行数
    init() {
        self.initData()
    }
}


