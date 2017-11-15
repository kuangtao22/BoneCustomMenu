//
//  BoneCustomCalendarView.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/10/25.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCalendarView: UIView {
    
    var setHeight: CGFloat? {
        didSet {
            guard let height = self.setHeight else {
                return
            }
            self.frame.size.height = height
            self.footerView.frame.origin.y = self.frame.height - self.footerView.frame.height
            self.collectionView.frame.size.height = self.bounds.height - self.footerView.frame.height
        }
    }
    
    var delegate: BoneCalenadrDelegate?
    
    // 选中颜色
    var selectColor = UIColor.red
    
    // 字体颜色
    var fontColor = UIColor.black
    
    // 今日字体颜色
    var todayFontColor = UIColor.red
    
    // 最大选中天
    var selectMaxDay: Int? {
        didSet {
            self.dataSourceManager.selectMaxDay = self.selectMaxDay ?? 0
        }
    }
    
    /// 选择样式
    var selectType: BoneCalenadrDataSource.SelectionType = .none {
        didSet {
            self.dataSourceManager.selectionType = self.selectType
        }
    }
    
    /// 选中时间, 标记选中时间后，自动滚动到最小选中时间页
    var selectDates: [Date]? {
        didSet {
            guard let dates = self.selectDates else {
                return
            }
            guard dates.count > 0 else {
                return
            }
            let newDates = dates.sorted()
            self.scrollToMonth(newDates[0], animated: true)
            self.dataSourceManager.selectDates = newDates
        }
    }
    
    
    // 日历模块
    fileprivate var collectionView: UICollectionView!   // 日历滚动视图
    fileprivate var layout: BoneCalendarLayout!
    fileprivate lazy var  dataSourceManager = BoneCalenadrDataSource()      // 日历数据源
    
    fileprivate var isCollection = false      // 是日历视图滑动
    
    // 按钮
    fileprivate var footerView: BoneCalendarFooter!
    
    fileprivate let identifier = "BoneDayCell"
    fileprivate let headerIdentifier = "headerIdentifier"
    fileprivate let footerIdentifier = "footerIdentifier"
    
    convenience init(frame: CGRect, type: BoneCalenadrDataSource.SelectionType) {
        self.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.dataSourceManager.delegate = self
        self.dataSourceManager.selectionType = type
        
        self.footerView = BoneCalendarFooter(frame: CGRect(x: 0, y: self.frame.height - 43, width: self.frame.width, height: 43))
        self.footerView.onClickAction { (type) in
            switch type {
            case .clean:
                self.dataSourceManager.cleanAllDate()
                self.collectionView.reloadData()
            case .confirm:
                self.delegate?.calenadr(self, confirm: self.dataSourceManager.selectDates)
            case .today:
                self.scrollToMonth(Date(), animated: true)
            }
        }
        self.addSubview(self.footerView)
        
        self.layout = BoneCalendarLayout(self.bounds.width)
        self.collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - self.footerView.frame.height),
            collectionViewLayout: self.layout
        )
        self.collectionView.allowsSelection = true          // 允许用户选择
        self.collectionView.allowsMultipleSelection = true  // 允许用户多选
        
        self.collectionView.backgroundColor = UIColor.white
        // 水平居中collectionView两边
        self.collectionView.contentInset.left = self.layout.leftOffset
        self.collectionView.contentInset.right = self.layout.rightOffset
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(BoneDayCell.self, forCellWithReuseIdentifier: self.identifier)
        self.collectionView.register(
            BoneCalenadrReusableView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: self.headerIdentifier
        )
        self.collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
            withReuseIdentifier: self.footerIdentifier
        )
        self.addSubview(self.collectionView)
        
        // 滑动到今日
        self.scrollToMonth(Date(), animated: false)
    }
    
    // 滑动到当前月当前时间
    fileprivate func scrollToMonth(_ date: Date, animated: Bool, position: UICollectionViewScrollPosition = .centeredVertically) {
        let indexPath = self.dataSourceManager.indexPathForRowAtDate(date)
        self.collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
    }
    
    
    // 点击Cell事件
    fileprivate func didCellClick(_ indexPath: IndexPath){
        let (_, dayState) = self.dataSourceManager.dayState(indexPath)
        if dayState.contains(.NotThisMonth) || dayState.contains(.UnSelectable) {
            return
        }
        if self.dataSourceManager.didSelectItemAtIndexPath(indexPath) {
            self.collectionView?.reloadData()
        }
    }
}



extension BoneCalendarView: BoneCalenadrDataSourceDelegate {
    
    func calenadr(_ dataSource: BoneCalenadrDataSource, didSelect dates: [Date], error: String?) {
        self.dataSourceManager.selectDates = dates
        self.delegate?.calenadr(self, didSelect: dates, error: error)
    }
}

extension BoneCalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSourceManager.monthCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceManager.daysInMonth(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as? BoneDayCell
        
        let (date,dayState) = dataSourceManager.dayState(indexPath)
        cell?.dayLabel.backRoundColor = self.selectColor
        cell?.dayLabel.text = dayState.contains(.Today) ? "今" : dataSourceManager.dayString(date)
        
        // 不在本月
        if dayState.contains(.NotThisMonth) {
            cell?.dayLabel.textColor = UIColor.lightGray
            cell?.dayLabel.roundType = .none
            return cell!
        }
        // 不可选
        if dayState.contains(.UnSelectable) {
            cell?.dayLabel.textColor = UIColor.lightGray
            cell?.dayLabel.roundType = .none
            return cell!
        }
        cell?.dayLabel.roundType = dayState.roundType
        
        // 选中效果
        if dayState.contains(.Selected) {
            cell?.dayLabel.textColor = self.selectColor
        } else {
            if dayState.contains(.Today) {
                cell?.dayLabel.textColor = self.todayFontColor
            } else {
                cell?.dayLabel.textColor = self.fontColor
            }
        }
        return cell!
    }
    
    // 返回headView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    // 返回footview的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10)
    }
    
    // 返回headView/footview样式
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerIdentifier, for: indexPath) as! BoneCalenadrReusableView
            let month = self.dataSourceManager.monthState(indexPath.section)
            reusableView.label.text = self.dataSourceManager.dateString(month)
            return reusableView
            
        } else {//} if kind == UICollectionElementKindSectionFooter {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footerIdentifier, for: indexPath)
            return reusableView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didCellClick(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.didCellClick(indexPath)
    }
}



