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

    var fontColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
    
    var selectColor = UIColor(red: 0/255, green: 139/255, blue: 254/255, alpha: 1)
    
    var sectionColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    
    var line = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
 
    fileprivate var scrollView: UIScrollView!
    fileprivate var currentSelect = 0               // 当前选中
    fileprivate var selectArray = [IndexPath]()     // 所有选中索引
    fileprivate var filterDatas = [[Int]]()
    fileprivate var calendarDates = [Date]()        // 日历时间
    
    fileprivate var menuType: ColumnType = .button
    fileprivate let defaultMenuheight = UIScreen.main.bounds.height * 0.5   // 默认菜单高度
    
    convenience init(top: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: top, width: UIScreen.main.bounds.width, height: height))
        let line = UIView(frame: CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5))
        line.backgroundColor = self.line
        self.addSubview(line)
        
        self.scrollView = UIScrollView(frame: self.bounds)
        self.addSubview(self.scrollView)
        self.popupDelegate = self

        self.menuView.addSubview(self.listView)
        self.menuView.addSubview(self.filterView)
        self.menuView.addSubview(self.calendarView)
        self.menuView.addSubview(self.filterListView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(sender:)))
        self.backgroundView.addGestureRecognizer(gesture)
    }
    
    lazy var listView: BoneCustomListsView = {
        let view = BoneCustomListsView(frame: CGRect(x: 0, y: -self.defaultMenuheight, width: self.menuView.frame.width, height: self.defaultMenuheight))
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    lazy var filterView: BoneCustomFiltersView = {
        let view = BoneCustomFiltersView(frame: CGRect(x: 0, y: -self.defaultMenuheight, width: self.menuView.frame.width, height: self.defaultMenuheight))
        view.delegate = self
        view.selectColor = self.selectColor
        view.line = self.line
        view.isHidden = true
        return view
    }()
    
    lazy var filterListView: BoneCustomFilterListView = {
        let view = BoneCustomFilterListView(frame: CGRect(x: 0, y: -self.defaultMenuheight, width: self.menuView.frame.width, height: self.defaultMenuheight))
        view.delegate = self
        view.selectColor = self.selectColor
        view.isHidden = true
        return view
    }()
    
    lazy var calendarView: BoneCalendarView = {
        let calenadr = BoneCalendarView(frame: CGRect(x: 0, y: -self.defaultMenuheight, width: self.menuView.frame.width, height: self.defaultMenuheight), type: .section)
        calenadr.selectColor = self.selectColor
        calenadr.delegate = self
        calenadr.isHidden = true
        return calenadr
    }()
    
    /// 点击菜单栏事件
    fileprivate func currentAction(type: ColumnType, button: ColumnBtn) {
        let tag = button.tag - 100
        button.isSelected = !button.isSelected
        
        self.filterView.isHidden = (type != .filter)
        self.listView.isHidden = (type != .list)
        self.calendarView.isHidden = (type != .calendar)
        self.filterListView.isHidden = (type != .filterList)
        
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
            
        case .filterList:
            self.popupAction(button.isSelected)
            self.filterListView.reloadData()
            
        case .list:
            self.popupAction(button.isSelected)
            self.listView.reloadData()
            
        case .calendar:
            self.popupAction(button.isSelected)
            self.calendarView.selectDates = self.calendarDates
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
    
    
    /// 获取菜单类型
    ///
    /// - 
    private func getView(type: ColumnType) -> UIView {
        switch type {
        case .button: return UIView()
        case .calendar: return self.calendarView
        case .filter: return self.filterView
        case .filterList: return self.filterListView
        case .list: return self.listView
        }
    }
    
    /// 点击背景关闭菜单
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        self.popupAction(false)
    }
    
    
    /// 设置弹出菜单高度
    fileprivate func setMenuHeight() {
        guard let delegate = self.delegate else {
            return
        }
        for i in 0..<delegate.numberOfColumns(self) {
            let type = delegate.boneMenu(self, typeForColumnAt: i).type
            if let height = delegate.boneMenu(self, menuHeightFor: i) {
                let view = self.getView(type: type)
                view.frame.size.height = height
                view.frame.origin.y = -height
                switch type {
                case .button:
                    break
                case .filter:
                    self.filterView.setHeight = height
                case .calendar:
                    self.calendarView.setHeight = height
                case .list:
                    self.listView.setHeight = height
                case .filterList:
                    self.filterListView.setHeight = height
                }
            }
        }
    }
    
    /// 显示/隐藏动画
    ///
    /// - Parameter isShow: 是否显示
    open func popupAction(_ isShow: Bool) {
        let view = self.getView(type: self.menuType)

        if isShow {
            self.menuView.frame.size.height = view.frame.height
            self.superview?.addSubview(self.backgroundView)
            self.superview?.addSubview(self.menuView)
            self.backgroundView.superview?.addSubview(self)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundView.alpha = 1
                view.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
            }, completion: { (finished) in
                self.popupDelegate?.customPopup(isShow)
            })
            
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundView.alpha = 0
                view.transform = CGAffineTransform.identity
                
            }, completion: { (finished) in
                self.backgroundView.removeFromSuperview()
                self.menuView.removeFromSuperview()
                self.popupDelegate?.customPopup(isShow)
            })
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
    
    /// 重载某列菜单数据
    func reloadColumn(_ column: Int) {
        guard let delegate = self.delegate else {
            return
        }
        let type = delegate.boneMenu(self, typeForColumnAt: column).type
        switch type {
        case .button, .calendar:
            break
        case .filter:
            self.filterView.reloadData()
        case .filterList:
            self.filterListView.reloadData()
        case .list:
            self.listView.reloadData()
        }
    }

    /// 重载数据
    func reloadData() {
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
            menuBtn.normalColor = self.fontColor
            menuBtn.selectColor = self.selectColor
            menuBtn.title = info.title
            menuBtn.tag = i + 100
            menuBtn.onClickAction(cellback: { (type, button) in
                self.menuType = type
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
        self.setMenuHeight()
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
    
    internal func customList(didSelect filterDatas: [[Int]], isConfirm: Bool) {
        self.filterDatas = filterDatas
        self.delegate?.boneMenu(self, didSelectRowAtColumn: self.currentSelect, filterDatas: self.filterDatas)
        self.popupAction(!isConfirm)
    }

    
    internal func customList(filterDidForSectionAt section: Int) -> BoneCustomPopup.FilterType {
        let index = BoneCustomPopup.IndexPath(column: self.currentSelect, section: section, row: 0)
        return self.delegate?.boneMenu(self, filterDidForSectionAt: index) ?? .only
    }

    
    internal func customFilter() -> [[Int]] {
        return self.filterDatas
    }
    
    
    internal func isRight() -> Bool {
        return self.isHaveRight
    }

    func getSelectData() -> BoneCustomListsView.SelectData {
        let section = self.selectArray[self.currentSelect].section
        let row = self.selectArray[self.currentSelect].row
        let data = BoneCustomListsView.SelectData(section: section, row: row)
        return data
    }

    internal func customList(didSelectRowAt section: Int, row: Int) {
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

    internal func customList(titleForSectionInRow section: Int, row: Int) -> String {
        let index = BoneCustomPopup.IndexPath(column: self.currentSelect, section: section, row: row)
        return self.delegate?.boneMenu(self, titleForRowAt: index) ?? ""
    }

    internal func customList(titleInSection section: Int) -> String {
        let index = BoneCustomPopup.IndexPath(column: self.currentSelect, section: section, row: 0)
        return self.delegate?.boneMenu(self, titleForSectionAt: index) ?? ""
    }

    
    internal func customList(numberOfRowsInSections sections: Int) -> Int {
        let index = BoneCustomPopup.IndexPath(column: self.currentSelect, section: sections, row: 0)
        return self.delegate?.boneMenu(self, numberOfRowsInSections: index) ?? 0
    }

    internal func numberOfSection() -> Int {
        return self.delegate?.boneMenu(self, numberOfSectionsInColumn: self.currentSelect) ?? 0
    }
}
