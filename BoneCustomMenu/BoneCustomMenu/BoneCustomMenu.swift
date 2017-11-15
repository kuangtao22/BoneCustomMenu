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
    var delegate: BoneMenuDelegate? {
        didSet {
            self.source.delegate = self.delegate
        }
    }
    
    var dataSource: BoneMenuDataSource? {
        didSet {
            self.source.dataSource = self.dataSource
        }
    }
    
    var fontColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
    
    /// 选中颜色
    var selectColor: UIColor? {
        didSet {
            guard let color = self.selectColor else {
                return
            }
            self.calendarView.selectColor = color
            self.listView.selectColor = color
            self.filterView.selectColor = color
            self.filterListView.selectColor = color
        }
    }
    
    var sectionColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    
    var line = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    
    fileprivate var scrollView: UIScrollView!
    
    /// 所有选中索引
    var selectIndexPaths = [BoneIndexPath]() {
        didSet {
            self.source.selectIndexPaths = self.selectIndexPaths
        }
    }
    /// 日历时间
    var calendarDates = [Date]() {
        didSet {
            self.calendarView.selectDates = self.calendarDates
        }
    }
    
    fileprivate var menuType: ColumnType = .button
    
    
    fileprivate var source: BoneCustomMenuSource!
    
    typealias BoneIndexPath = BoneCustomMenuSource.BoneIndexPath
    typealias ColumnType = BoneCustomMenuSource.ColumnType
    typealias FilterType = BoneCustomMenuSource.SelectType
    
    convenience init(top: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: top, width: UIScreen.main.bounds.width, height: height))
        self.initializa()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializa()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化
    private func initializa() {
        self.source = BoneCustomMenuSource(menu: self)
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
        let view = BoneCustomListsView(frame: CGRect(x: 0, y: -self.source.menuHeight(), width: self.menuView.frame.width, height: self.source.menuHeight()))
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    lazy var filterView: BoneCustomFiltersView = {
        let view = BoneCustomFiltersView(frame: CGRect(x: 0, y: -self.source.menuHeight(), width: self.menuView.frame.width, height: self.source.menuHeight()))
        view.delegate = self
        view.line = self.line
        view.isHidden = true
        return view
    }()
    
    lazy var filterListView: BoneCustomFilterListView = {
        let view = BoneCustomFilterListView(frame: CGRect(x: 0, y: -self.source.menuHeight(), width: self.menuView.frame.width, height: self.source.menuHeight()))
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    lazy var calendarView: BoneCalendarView = {
        let calenadr = BoneCalendarView(frame: CGRect(x: 0, y: -self.source.menuHeight(), width: self.menuView.frame.width, height: self.source.menuHeight()), type: .section)
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
        
        self.source.currentSelect = tag
        switch type {
        case .button:
            self.popupAction(false)
            let indexPath = IndexPath(row: (button.isSelected ? 1 : 0), section: 0)
            self.source.updata(indexPath)
            
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
        for i in 0..<self.source.columnNum {
            let type = self.source.columnInfo(i).type
            let height = self.source.menuHeight(i)
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
        guard let dataSource = self.dataSource else {
            return
        }
        let type = dataSource.boneMenu(self, typeForColumnAt: column).type
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
        let columnNum = self.source.columnNum
        let width = self.frame.width / CGFloat(columnNum > 4 ? 4 : columnNum)
        
        for i in 0..<columnNum {
            let info = self.source.columnInfo(i)
            let origin = CGPoint(x: CGFloat(i) * width, y: 0)
            let size = CGSize(width: width, height: self.frame.height)
            let menuBtn = ColumnBtn(frame: CGRect(origin: origin, size: size), type: info.type)
            menuBtn.normalColor = self.fontColor
            menuBtn.selectColor = self.selectColor
            menuBtn.title = info.title
            menuBtn.tag = i + 100
            
            switch info.type {
            case .button:
                menuBtn.isSelected = self.source.selectIndexPaths[i].row == 1
            case .list:
                let listArray = self.source.selectIndexPaths.filter { $0.column == i }
                if !listArray.isEmpty {
                    menuBtn.title = self.source.rowTitle(listArray[0])
                }
            default:
                break
            }
            menuBtn.onClickAction(cellback: { (type, button) in
                self.menuType = type
                self.currentAction(type: type, button: button)
            })
            self.scrollView.addSubview(menuBtn)
            if i == (columnNum - 1) {
                self.scrollView.contentSize.width = menuBtn.frame.origin.x + menuBtn.frame.width
            }
        }
        self.setMenuHeight()
        self.listView.reloadData()
    }
}

extension BoneCustomMenu: BoneCustomPopupDelegate {
    
    internal func customPopup(_ isShow: Bool) {
        guard let dataSource = self.dataSource else {
            return
        }
        let num = dataSource.numberOfColumns(self)
        for i in 0..<num {
            let menuBtn = self.scrollView.viewWithTag(i + 100) as? ColumnBtn
            switch dataSource.boneMenu(self, typeForColumnAt: i).type {
            case .button:
                break
            default:
                if isShow {
                    if self.source.currentSelect != i {
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
    
    func numberOfSection() -> Int {
        return self.source.sectionNum
    }
    
    func numberOfRows(_ section: Int) -> Int {
        let indexPath = BoneIndexPath(column: self.source.currentSelect, section: section, row: 0)
        return self.source.rowNum(indexPath)
    }
    
    func titleOfSection(_ section: Int) -> String {
        return self.source.sectionTitle(section)
    }
    
    func titleForSectionInRow(_ section: Int, row: Int) -> String {
        let indexPath = BoneIndexPath(column: self.source.currentSelect, section: section, row: row)
        return self.source.rowTitle(indexPath)
    }
    
    func isTwoCol() -> Bool {
        return self.source.isTwoCol
    }
    
    func didSelect(_ section: Int) {
        self.source.onClickSection(section)
    }
    
    func didSelectAtRow(_ indexPath: IndexPath) {
        self.source.updata(indexPath)
        let currentSelect = self.source.currentSelect
        self.popupAction(false)
        
        let menuBtn = self.scrollView.viewWithTag(currentSelect + 100) as? ColumnBtn
        let indexPath = BoneIndexPath(column: self.source.currentSelect, section: indexPath.section, row: indexPath.row)
        menuBtn?.title = self.source.rowTitle(indexPath)
    }
    
    func filterTypeOfSection(_ section: Int) -> BoneCustomMenuSource.SelectType {
        return self.source.selectType(section)
    }
    
    func getSelectIndexPaths() -> [IndexPath] {
        return self.source.indexPathsForBone
    }
    
    func buttonSelect(_ indexPaths: [IndexPath], isConfirm: Bool) {
        if isConfirm {
            self.popupAction(false)
            self.source.updata(indexPaths)
        }
    }
}

