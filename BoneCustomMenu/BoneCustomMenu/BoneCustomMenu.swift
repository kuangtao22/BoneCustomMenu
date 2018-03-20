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
    weak var delegate: BoneMenuDelegate? {
        didSet { self.source.delegate = self.delegate }
    }
    
    /// 数据源
    weak var dataSource: BoneMenuDataSource? {
        didSet { self.source.dataSource = self.dataSource }
    }
    
    /// 字体大小
    var fontSize: CGFloat {
        get { return Size.font }
        set { Size.font = newValue }
    }
    
    /// 字体颜色
    var fontColor: UIColor {
        get { return Color.font }
        set { Color.font = newValue }
    }
    
    /// 左边宽度
    var leftWidth: CGFloat {
        get { return Size.leftWidth }
        set { Size.leftWidth = newValue }
    }
    
    var menuFontColor: UIColor?
    
    var menuSelectColor: UIColor?
    
    /// 选中颜色
    var selectColor: UIColor {
        get { return Color.select }
        set { Color.select = newValue }
    }
    
    var sectionColor: UIColor {
        get { return Color.section }
        set { Color.section = newValue }
    }
    
    /// 分割线颜色
    var lineColor: UIColor {
        get { return Color.line }
        set { Color.line = newValue }
    }
    
    /// 是否显示菜单
    var showMenu: Bool? {
        didSet {
            guard let showMenu = self.showMenu else {
                return
            }
            self.popupAction(showMenu)
        }
    }
    
    /// 所有选中索引
    var selectIndexPaths: [BoneMenuIndexPath] {
        get { return self.source.selectIndexPaths }
        set {
            self.source.selectIndexPaths = newValue
            if self.isFilterBar == true {
                self.barView.reloadData()
            }
        }
    }
    
    /// 日历时间
    var calendarDates: [Date] {
        get { return self.calendarView.selectDates }
        set { self.calendarView.selectDates = newValue }
    }
    
    /// 全部已选标题
    var selectAllTitles: [String] {
        get { return self.source.selectAllTitles }
    }
    
    /// 添加底部线
    var isBottomLine: Bool = true
    
    /// 是否开启筛选栏
    var isFilterBar: Bool = false
    
    fileprivate var scrollView: UIScrollView!
    
    fileprivate var menuType: BoneMenuColumnType = .button
    fileprivate var defaultHeight: CGFloat = 40
    
    fileprivate var source: BoneCustomMenuSource!
    
    
    convenience init(top: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: top, width: UIScreen.main.bounds.width, height: height))
        self.defaultHeight = height
        self.initializa()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.defaultHeight = frame.height
        self.initializa()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化
    private func initializa() {
        self.source = BoneCustomMenuSource(menu: self)
        self.backgroundColor = UIColor.white
        self.scrollView = UIScrollView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.width, height: self.frame.height - 1)))
        self.addSubview(self.scrollView)
        
        self.popupDelegate = self
        
        self.menuView.addSubview(self.listView)
        self.menuView.addSubview(self.filterView)
        self.menuView.addSubview(self.calendarView)
        self.menuView.addSubview(self.filterListView)
        self.menuView.addSubview(self.customView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(sender:)))
        self.backgroundView.addGestureRecognizer(gesture)
    }
    
    /// 自定义
    lazy var customView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -self.source.menuHeight, width: self.menuView.frame.width, height: self.source.menuHeight))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    /// 列表
    lazy var listView: BoneCustomListsView = {
        let view = BoneCustomListsView(frame: CGRect(x: 0, y: -self.source.menuHeight, width: self.menuView.frame.width, height: self.source.menuHeight))
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    /// 表格型筛选
    lazy var filterView: BoneCustomFiltersView = {
        let view = BoneCustomFiltersView(frame: CGRect(x: 0, y: -self.source.menuHeight, width: self.menuView.frame.width, height: self.source.menuHeight))
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    /// 列表型筛选
    lazy var filterListView: BoneCustomFilterListView = {
        let view = BoneCustomFilterListView(frame: CGRect(x: 0, y: -self.source.menuHeight, width: self.menuView.frame.width, height: self.source.menuHeight))
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    /// 日历
    lazy var calendarView: BoneCalendarView = {
        let calenadr = BoneCalendarView(frame: CGRect(x: 0, y: -self.source.menuHeight, width: self.menuView.frame.width, height: self.source.menuHeight), type: .section)
        calenadr.delegate = self
        calenadr.isHidden = true
        return calenadr
    }()
    
    /// 筛选栏
    lazy var barView: BoneMenuBarView = {
        let barView = BoneMenuBarView(self.frame.maxY)
        barView.delegate = self
        return barView
    }()
    
    /// 点击菜单栏事件
    fileprivate func currentAction(type: BoneMenuColumnType, button: ColumnBtn) {
        let tag = button.tag - 100
        button.isSelected = !button.isSelected
        
        self.filterView.isHidden = (type != .filter)
        self.listView.isHidden = (type != .list)
        self.calendarView.isHidden = (type != .calendar)
        self.filterListView.isHidden = (type != .filterList)
        self.customView.isHidden = (type != .custom)
        
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
            self.calendarView.reloadData()
            
        case .custom:
            self.popupAction(button.isSelected)
            if let view = self.source.customView(tag) {
                for view in self.customView.subviews {
                    view.removeFromSuperview()
                }
                self.customView.addSubview(view)
            }
        }
    }
    
    
    /// 获取菜单类型
    private func getView(type: BoneMenuColumnType) -> UIView {
        switch type {
        case .button: return UIView()
        case .calendar: return self.calendarView
        case .filter: return self.filterView
        case .filterList: return self.filterListView
        case .list: return self.listView
        case .custom: return self.customView
        }
    }
    
    /// 点击背景关闭菜单
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        self.popupAction(false)
    }
    
    
    /// 设置弹出菜单高度
    fileprivate func setColumnHeight() {
        let view = self.getView(type: self.menuType)
        let height = self.source.menuHeight
        if let view = view as? BoneCustomFiltersView {
            view.setHeight = height
        } else if let view = view as? BoneCalendarView {
            view.setHeight = height
        } else if let view = view as? BoneCustomListsView {
            view.setHeight = height
        } else if let view = view as? BoneCustomFilterListView {
            view.setHeight = height
        } else {
            view.frame.size.height = height
        }
    }
    
    /// 显示/隐藏动画
    ///
    /// - Parameter isShow: 是否显示
    fileprivate func popupAction(_ isShow: Bool) {
        let view = self.getView(type: self.menuType)
        self.setColumnHeight()
        if isShow {
            self.superview?.addSubview(self.backgroundView)
            self.superview?.addSubview(self.menuView)
            self.backgroundView.superview?.addSubview(self)
            if self.isFilterBar { self.barView.removeFromSuperview() }
            
            self.menuView.frame.size.height = view.frame.height
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundView.alpha = 1
                view.frame.origin.y = 0
            }, completion: { (finished) in
                self.popupDelegate?.customPopup(isShow)
            })
            
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundView.alpha = 0
                view.frame.origin.y = -view.frame.height
            }, completion: { (finished) in
                self.backgroundView.removeFromSuperview()
                self.menuView.removeFromSuperview()
                self.popupDelegate?.customPopup(isShow)
                if self.isFilterBar { self.superview?.addSubview(self.barView) }
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
    
    func reloadSection(_ column: Int, section: Int) {
        guard let dataSource = self.dataSource else {
            return
        }
        let type = dataSource.boneMenu(self, typeForColumnAt: column).type
        switch type {
        case .button, .calendar, .custom:
            break
        case .filter:
            self.filterView.reloadData()
        case .filterList:
            self.filterListView.rightTable.reloadData()
        case .list:
            self.listView.reloadData()
        }
    }
    
    /// 重载某列菜单数据
    func reloadColumn(_ column: Int) {
        guard let dataSource = self.dataSource else {
            return
        }
        let type = dataSource.boneMenu(self, typeForColumnAt: column).type
        switch type {
        case .button, .calendar, .custom:
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
            let size = CGSize(width: width, height: self.scrollView.frame.height)
            let menuBtn = ColumnBtn(frame: CGRect(origin: origin, size: size), type: info.type)
            menuBtn.normalColor = self.menuFontColor ?? self.fontColor
            menuBtn.selectColor = self.menuSelectColor ?? self.selectColor
            menuBtn.title = info.title
            menuBtn.tag = i + 100
            switch info.type {
            case .button:
                menuBtn.isSelected = self.source.selectIndexPaths.contains {
                    ($0.column == i) && ($0.section == 0) && ($0.row == 1)
                }
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
    }
    
    override func draw(_ rect: CGRect) {
        guard self.isBottomLine else {
            return
        }
        BoneCustomPopup.Color.line.setStroke()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.stroke()
        super.draw(rect)
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

/// 筛选显示栏
extension BoneCustomMenu: BoneMenuBarDelegate {
    func state(_ barView: BoneMenuBarView) {
        let y = self.barView.isShow ? self.barView.frame.maxY : self.frame.maxY
        self.delegate?.boneBar(self.barView, contentOffsetY: y)
    }
    
    func getCount() -> Int {
        return self.source.selectIndexPaths.count
    }
    
    func getTitle(_ index: Int) -> String {
        return self.source.selectTitle(index)
    }
    
    func getSelectIndexPath(_ index: Int) -> BoneMenuIndexPath {
        return self.source.selectIndexPath(index)
    }
    
    func onClick(_ index: Int) {
        self.source.updata(index) {
            self.barView.reloadData()
        }
        self.reloadData()
    }
    
    func clean() {
        self.source.delAll {
            self.barView.reloadData()
        }
        self.reloadData()
    }
}

// MARK: - 列表类型代理协议
extension BoneCustomMenu: BoneCustomDelegate {
    
    func numberOfSection() -> Int {
        return self.source.sectionNum()
    }
    
    func numberOfRows(_ section: Int) -> Int {
        let indexPath = BoneMenuIndexPath(column: self.source.currentSelect, section: section, row: 0)
        return self.source.rowNum(indexPath)
    }
    
    func titleOfSection(_ section: Int) -> String {
        return self.source.sectionTitle(section)
    }
    
    func titleForSectionInRow(_ section: Int, row: Int) -> String {
        let indexPath = BoneMenuIndexPath(column: self.source.currentSelect, section: section, row: row)
        return self.source.rowTitle(indexPath)
    }
    
    func isTwoCol() -> Bool {
        return self.source.isTwoCol
    }
    
    func didSelect(_ section: Int) {
        self.source.onClickSection(section)
    }
    
    func didSelectAtRow(_ indexPath: IndexPath) {
        self.popupAction(false)
        self.source.updata(indexPath)
        
        let currentSelect = self.source.currentSelect
        let menuBtn = self.scrollView.viewWithTag(currentSelect + 100) as? ColumnBtn
        let index = BoneMenuIndexPath(column: self.source.currentSelect, section: indexPath.section, row: indexPath.row)
        menuBtn?.title = self.source.rowTitle(index)
    }
    
    func filterTypeOfSection(_ section: Int) -> BoneMenuSelectType {
        return self.source.selectType(section)
    }
    
    func getSelectIndexPaths() -> [IndexPath] {
        return self.source.indexPathsForColumn
    }
    
    func buttonSelect(_ indexPaths: [IndexPath], isConfirm: Bool) {
        if isConfirm {
            self.popupAction(false)
            self.source.updata(indexPaths, cellback: {
                self.barView.reloadData()
            })
        }
    }
}

