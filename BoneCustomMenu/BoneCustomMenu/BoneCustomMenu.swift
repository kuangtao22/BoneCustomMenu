//
//  BoneCustomMenu.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/7.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneCustomMenuProtocol {
    
    /// 重载数据
    func reloadData()
}

class BoneCustomMenu: BoneCustomPopup {
    
    /// 代理协议
    var delegate: BoneCustomMenuDelegate?
 
    fileprivate var scrollView: UIScrollView!
    fileprivate var currentSelect = 0               // 当前选中
    fileprivate var selectArray = [IndexPath]()     // 所有选中索引
    fileprivate var filterDatas = [[Int]]()
    fileprivate var calendarDates = [Date]()        // 日历时间
    
    convenience init(top: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: top, width: UIScreen.main.bounds.width, height: height))
        let line = UIView(frame: CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5))
        line.backgroundColor = Color.line
        self.addSubview(line)
        
        self.scrollView = UIScrollView(frame: self.bounds)
        self.addSubview(self.scrollView)
        self.popupDelegate = self
        
        self.popupView.addSubview(self.listView)
        self.popupView.addSubview(self.filterView)
        self.popupView.addSubview(self.calendarView)
    }
    
    lazy var listView: BoneCustomListsView = {
        let view = BoneCustomListsView(frame: self.popupView.bounds)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    lazy var filterView: BoneCustomFilterView = {
        let view = BoneCustomFilterView(frame: self.popupView.bounds)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    lazy var calendarView: BoneCalendarView = {
        let calenadr = BoneCalendarView(frame: self.popupView.bounds, type: .section)
        calenadr.selectColor = UIColor.orange
        calenadr.delegate = self
        calenadr.isHidden = true
        return calenadr
    }()

    fileprivate func currentAction(type: ColumnType, button: ColumnBtn) {
        let tag = button.tag - 100
        button.isSelected = !button.isSelected
        
        self.filterView.isHidden = (type != .filter)
        self.listView.isHidden = (type != .list)
        self.calendarView.isHidden = (type != .calendar)
        
        self.currentSelect = tag
        switch type {
        case .button:
            self.popupAction(false)
            self.selectArray[tag].column = tag
            self.selectArray[tag].section = 0
            self.selectArray[tag].row = button.isSelected ? 1 : 0
            self.delegate?.boneMenu(self, didSelectRowAtIndexPath: self.selectArray[tag])
            
        case .filter:
            self.popupAction(button.isSelected)
            self.filterView.reloadData()
            
        case .list:
            self.popupAction(button.isSelected)
            self.listView.reloadData()
            
        case .calendar:
            self.popupAction(button.isSelected)
        }
    }
    
    /// 判断是否有二级分类
    fileprivate var isHaveRight: Bool {
        get {
            let sectionNum = self.delegate?.boneMenu(self, numberOfSectionsInColumn: self.currentSelect) ?? 0
            for i in 0..<sectionNum {
                let index = BoneCustomPopup.IndexPath(column: self.currentSelect, section: i, row: 0)
                let row = self.delegate?.boneMenu(self, numberOfRowsInSections: index) ?? 0
                if row > 0 {
                    return true
                }
            }
            return false
        }
    }
    
    
}


// MARK: - 日历协议方法
extension BoneCustomMenu: BoneCalenadrDelegate {
    
    /// 选择时间
    func calenadr(_ calenadrView: BoneCalendarView, didSelect dates: [Date], error: String?) {
        if let error = error {
            self.delegate?.boneMenu(self, didSelectCalendar: dates, error: error)
        }
        
    }
    
    /// 确认
    func calenadr(_ calenadrView: BoneCalendarView, confirm dates: [Date]) {
        self.calendarDates = dates
        self.popupAction(false)
        self.delegate?.boneMenu(self, didSelectCalendar: dates, error: nil)
    }
}

extension BoneCustomMenu: BoneCustomMenuProtocol {
    
    

    internal func reloadData() {
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        
        guard let delegate = self.delegate else {
            return
        }

        let num = delegate.numberOfColumns(self)
        let width = self.frame.width / CGFloat((num < 5) ? num : 4)
        self.selectArray = [IndexPath]()
        for i in 0..<num {
            let info = delegate.boneMenu(self, typeForColumnAt: i)
            
            self.selectArray.append(IndexPath(column: 0, section: 0, row: 0))
            let menuBtn = ColumnBtn(
                frame: CGRect(origin: CGPoint(x: CGFloat(i) * width, y: 0), size: CGSize(width: width, height: self.frame.height)),
                type: info.type
            )
            menuBtn.normalColor = Color.font
            menuBtn.selectColor = Color.fontSelect
            menuBtn.title = info.title
            menuBtn.tag = i + 100
            menuBtn.onClickAction(cellback: { (type, button) in
                self.currentAction(type: type, button: button)
            })
            self.scrollView.addSubview(menuBtn)
            if i == (num - 1) {
                self.scrollView.contentSize = CGSize(
                    width: menuBtn.frame.origin.x + menuBtn.frame.width,
                    height: self.scrollView.frame.height
                )
            }
        }
        self.listView.reloadData()
    }
}

extension BoneCustomMenu: BoneCustomPopupDelegate {
    
    internal func customPopup(_ isShow: Bool) {

        guard let delegate = self.delegate else {
            return
        }
        let num = delegate.numberOfColumns(self)
        for i in 0..<num {
            let menuBtn = self.scrollView.viewWithTag(i + 100) as? ColumnBtn
            
            switch delegate.boneMenu(self, typeForColumnAt: i).type {
            case .button:
                break
            default:
                if isShow {
                    if self.currentSelect != i {
                        menuBtn?.isSelected = false
                    }
                } else {
                    menuBtn?.isSelected = false
                }
                
            }
        }

    }
}


// MARK: - 列表类型代理协议
extension BoneCustomMenu: BoneCustomDelegate {
    
    
    internal func customList(_ view: UIView, didSelect filterDatas: [[Int]], isConfirm: Bool) {
        self.filterDatas = filterDatas
        self.delegate?.boneMenu(self, didSelectRowAtColumn: self.currentSelect, filterDatas: self.filterDatas)
        self.popupAction(!isConfirm)
    }

    
    internal func customList(_ view: UIView, filterDidForSectionAt section: Int) -> BoneCustomPopup.FilterType {
        let index = BoneCustomPopup.IndexPath(column: self.currentSelect, section: section, row: 0)
        return self.delegate?.boneMenu(self, filterDidForSectionAt: index) ?? .only
    }

    
    internal func customFilter(_ view: UIView) -> [[Int]] {
        return self.filterDatas
    }
    
    
    internal func isRight() -> Bool {
        return self.isHaveRight
    }

    
    internal func customList(currentSelectRowAt view: UIView) -> BoneCustomListsView.SelectData {
        let section = self.selectArray[self.currentSelect].section
        let row = self.selectArray[self.currentSelect].row
        let data = BoneCustomListsView.SelectData(section: section, row: row)
        return data
    }

    internal func customList(_ view: UIView, didSelectRowAt section: Int, row: Int) {
        self.selectArray[self.currentSelect].column = self.currentSelect
        self.selectArray[self.currentSelect].section = section
        self.selectArray[self.currentSelect].row = row

        self.popupAction(false)
        let menuBtn = self.scrollView.viewWithTag(self.currentSelect + 100) as? ColumnBtn
        let index = BoneCustomPopup.IndexPath(column: self.currentSelect, section: section, row: row)
        if self.isHaveRight {
            let menuTitle = self.delegate?.boneMenu(self, titleForRowAt: index)
            menuBtn?.title = menuTitle
        } else {
            let menuTitle = self.delegate?.boneMenu(self, titleForSectionAt: index)
            menuBtn?.title = menuTitle
        }
        self.delegate?.boneMenu(self, didSelectRowAtIndexPath: self.selectArray[self.currentSelect])
    }

    internal func customList(_ view: UIView, titleForSectionInRow section: Int, row: Int) -> String {
        let index = BoneCustomPopup.IndexPath(column: self.currentSelect, section: section, row: row)
        return self.delegate?.boneMenu(self, titleForRowAt: index) ?? ""
    }

    internal func customList(_ view: UIView, titleInSection section: Int) -> String {
        let index = BoneCustomPopup.IndexPath(column: self.currentSelect, section: section, row: 0)
        return self.delegate?.boneMenu(self, titleForSectionAt: index) ?? ""
    }

    
    internal func customList(_ view: UIView, numberOfRowsInSections sections: Int) -> Int {
        let index = BoneCustomPopup.IndexPath(column: self.currentSelect, section: sections, row: 0)
        return self.delegate?.boneMenu(self, numberOfRowsInSections: index) ?? 0
    }

    internal func numberOfSection(_ view: UIView) -> Int {
        return self.delegate?.boneMenu(self, numberOfSectionsInColumn: self.currentSelect) ?? 0
    }
}
