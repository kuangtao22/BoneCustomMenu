//
//  BoneFilterDataSource.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/10.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneFilterDataSource {
    
    /// 获取选中数据
    var selectData: [[Int]] {
        get { return self.selectArray }
    }

    /// 获取分区数量
    var sectionNum: Int {
        get { return self.delegate?.numberOfSection() ?? 0}
    }
    
    /// 是否有二级分类
    var isHaveRow: Bool {
        get { return self.delegate?.isRight() ?? false }
    }
    
//    func selectRowNum(_ section: Int) {
//        self.selectData
//    }
    
    /// 获取行数
    func rowNum(_ section: Int) -> Int {
        return self.delegate?.customList(numberOfRowsInSections: section) ?? 0
    }

    /// 获取标题
    func getTitle(_ section: Int) -> String {
        return self.delegate?.customList(titleInSection: section) ?? ""
    }
    
    /// 获取副标题
    func getSubTitle(_ indexPath: IndexPath) -> String {
        return  self.delegate?.customList(titleForSectionInRow: indexPath.section, row: indexPath.item) ?? ""
    }
    
    /// 获取选择类型(多选/单选)
    func getSelectType(_ section: Int) -> BoneCustomPopup.FilterType {
        return self.delegate?.customList(filterDidForSectionAt: section) ?? .only
    }
    
    /// 更新数据
    func updata(_ indexPath: IndexPath) {
        if self.selectArray.isEmpty {
            self.initData()
        }
        switch self.getSelectType(indexPath.section) {
        case .only:
            if self.selectArray[indexPath.section].contains(indexPath.item) {
                self.selectArray[indexPath.section] = []
            } else {
                self.selectArray[indexPath.section] = [indexPath.item]
            }
        case .multi:
            if self.selectArray[indexPath.section].contains(indexPath.item) {
                let items = self.selectArray[indexPath.section].filter { $0 != indexPath.item }
                self.selectArray[indexPath.section] = items
            } else {
                self.selectArray[indexPath.section].append(indexPath.item)
            }
        }
    }
    
    /// 清空数据
    func cleanData() {
        for i in 0..<self.selectArray.count {
            self.selectArray[i] = []
        }
        self.delegate?.customList(didSelect: self.selectArray, isConfirm: false)
    }
    
    /// 提交数据
    func submitData() {
        self.delegate?.customList(didSelect: self.selectArray, isConfirm: true)
    }
    
    /// 初始化数据
    func initData() {
        guard let delegate = self.delegate else {
            return
        }
        if self.selectArray.count < delegate.numberOfSection() {
            for _ in 0..<delegate.numberOfSection() {
                self.selectArray.append([])
            }
        } else {
            self.selectArray = delegate.customFilter()
        }
    }
    
    /// 获取选中状态
    func getSelectState(_ indexPath: IndexPath) -> Bool {
        if self.selectArray.count > 0 {
            return self.selectArray[indexPath.section].contains(indexPath.row)
        }
        return false
    }
    
    var delegate: BoneCustomDelegate?
    fileprivate var selectArray = [[Int]]()
    
    init() {
        self.initData()
    }
}

extension BoneFilterDataSource {
    
//    /// 筛选类型
//    enum SelectType {
//        case only   // 单选
//        case multi  // 多选
//    }
}
