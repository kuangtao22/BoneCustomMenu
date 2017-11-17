//
//  BoneCalenadrDataSource.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/10/25.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

extension BoneCalenadrDataSource: BoneCalenadrDataSourceProtocol {
    
    var selectDates: [Date] {
        get {
            return self.indexPathFotDates()
        }
        set {
            guard newValue.count > 0 else {
                return
            }
            var dates = newValue
            switch self.selectionType {
            case .none:
                break
            case .single:
                dates = [newValue[0]]
            case .mutable:
                break
            case .section:
                dates = [newValue[0], newValue[newValue.count - 1]]
                dates = self.timeString(dates[0]) == self.timeString(dates[1]) ? [dates[0]] : dates
            }
            let newIndexPath = dates.flatMap({ (date) -> IndexPath? in
                self.indexPathForRowAtDate(date)
            })
            self.selectedIndexPaths = newIndexPath
        }
    }
    
    
    
    
    var selectMaxDay: Int {
        get {
            return self.maxDay
        }
        set {
            self.maxDay = newValue
        }
    }
    
    /// 日历开始的日期, 计算属性
    var startDate: Date {
        get {
            return firstDate
        }
        set {
            if firstDate != nil && (newValue == firstDate){
                return
            }
            if lastDate != nil{
                let result = newValue.compare(lastDate)
                if result == .orderedDescending {
                    fatalError("startDate must smaller than endDate")
                }
            }
            
            firstDate = clampDate(date: newValue, toComponents: [.year,.month,.day])
            firstDateMonthBegainDate = clampDate(date: newValue, toComponents: [.month,.year])
            if lastDate != nil{
                let today = Date()
                let result1 = today.compare(newValue)
                let result2 = today.compare(lastDate)
                if result1 != .orderedAscending && result2 != .orderedDescending{
                    todayIndex = indexPathForRowAtDate(today)
                } else {
                    todayIndex = nil
                }
            }
        }
    }
    
    /// 日历结束的日期, 计算属性
    var endDate: Date {
        set{
            if lastDate != nil && (newValue == lastDate){
                return
            }
            if firstDate != nil{
                let result = firstDate.compare(newValue)
                if result == .orderedDescending {
                    fatalError("startDate must smaller than endDate")
                }
            }
            var components =  (self.calendar as NSCalendar).components([.year,.month,.day],from:newValue)
            components.hour = 23
            components.minute = 59
            components.second = 59
            lastDate = self.calendar.date(from: components)
            let firstOfMonth = self.clampDate(date: newValue, toComponents: [.month,.year])
            var offsetComponents = DateComponents()
            offsetComponents.month = 1
            let temp = (self.calendar as NSCalendar).date(byAdding: offsetComponents, to: firstOfMonth, options: .wrapComponents)!
            lastDateMonthEndDate = Date(timeIntervalSince1970: temp.timeIntervalSince1970 - 1)
            if firstDate != nil{
                let today = Date()
                let result1 = today.compare(firstDate)
                let result2 = today.compare(newValue)
                if result1 != .orderedAscending && result2 != .orderedDescending {
                    todayIndex = indexPathForRowAtDate(today)
                } else {
                    todayIndex = nil
                }
            }
        }
        get{
            return lastDate
        }
    }
    
    //多少年
    var yearCount: Int {
        get {
            let startYear = (calendar as NSCalendar).components(.year,from: BoneCalenadrDataSource.defaultMinDate, to: firstDateMonthBegainDate, options: .wrapComponents).year ?? 0
            let endYear = (calendar as NSCalendar).components(.year,from: BoneCalenadrDataSource.defaultMinDate, to: lastDateMonthEndDate,options: .wrapComponents).year ?? 0
            return endYear - startYear + 1
        }
    }
    
    
    
    // 多少月
    var monthCount: Int {
        get{
            let calendar = self.calendar as NSCalendar
            let month = calendar.components(.month, from: firstDateMonthBegainDate, to: lastDateMonthEndDate, options: .wrapComponents).month ?? 0
            return month + 1
        }
    }
    
    // 一星期多少天
    var weekCount: Int {
        get {
            return calendar.maximumRange(of: .weekday)?.count ?? 0
        }
    }
    
    // 一个月多少天
    func daysInMonth(_ monthIndex: Int) -> Int {
        return weeksInMonth(monthIndex) * weekCount
    }
    
    /// 输出年
    func yearString(_ item: Int) -> Int {
        let firstYear = self.calendar.component(.year, from: firstDateMonthBegainDate)
        return item + firstYear
    }
    
    func itemAtDate(_ date: Date) -> Int {
        let year = Calendar.current.dateComponents([.year], from: date).year ?? 0
        let firstYear = self.calendar.component(.year, from: firstDateMonthBegainDate)
        return year - firstYear
    }
    
    /// 每年的时间
    func yearState(_ item: Int) -> Date {
        var components = DateComponents()
        components.year = self.yearString(item)
        components.month = 1
        components.day = 1
        components.timeZone = TimeZone(abbreviation: "GMT")
        return self.calendar.date(from: components)!
    }
    
    // 每天的信息
    func dayState(_ indexPath: IndexPath) -> (Date, DayStateOptions) {
        let monthInfo = getMonthInfo(indexPath.section)
        return monthInfo.getDayInfo(indexPath.row, selectedType: self.selectionType)
    }
    
    // 格式化天日期
    func dayString(_ fromDate: Date) -> String {
        return String(self.calendar.component(.day, from: fromDate))
    }
    
    // 格式化日期
    func dateString(_ fromDate: Date) -> String {
        return formatter.string(from: fromDate)
    }
    
    //某个section的对应月份有几个星期
    func weeksInMonth(_ monthIndex: Int) -> Int {
        let firstOfMonth = self.firstOfMonthForSection(monthIndex)
        let rangeOfWeeks = (self.calendar as NSCalendar).range(of: .weekOfMonth, in: .month,for: firstOfMonth).length
        return rangeOfWeeks
    }

    /// 某个section的对应月份的信息 目前和firstOfMonthForSection差不多
    func monthState(_ monthIndex: Int) -> Date {
        var offset = DateComponents()
        offset.month = monthIndex
        let calendar = (self.calendar as NSCalendar)
        return calendar.date(byAdding: offset, to: firstDateMonthBegainDate, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /// 获取当前indexPath时间
    func getDate(_ indexPath: IndexPath) -> Date {
        let (date, _) = self.dayState(indexPath)
        return date
    }
    
    // 某日期所在的section
    func sectionForDate(_ date: Date) -> Int {
        let calendar = (self.calendar as NSCalendar)
        return calendar.components(.month, from: self.firstDateMonthBegainDate,to: date,options: .wrapComponents).month!
    }
    
    // 某日期所在的IndexPath
    func indexPathForRowAtDate(_ date: Date) -> IndexPath {
        let section = self.sectionForDate(date)
        let firstOfMonth = self.firstOfMonthForSection(section)
        
        let ordinalityOfFirstDay =  1 - (self.calendar as NSCalendar).component(.weekday, from: firstOfMonth)
        
        var  dateComponents = DateComponents()
        dateComponents.day = ordinalityOfFirstDay
        let startDateInSection = (self.calendar as NSCalendar).date(byAdding: dateComponents, to: firstOfMonth, options: NSCalendar.Options(rawValue: 0))!
        
        let row = (self.calendar as NSCalendar).components(.day, from: startDateInSection, to: date, options: NSCalendar.Options(rawValue: 0)).day
        return IndexPath(row:row!,section:section)
    }
    
    //选中某天，返回true表示修改了selectedDates，collectionView需要刷新
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) -> Bool {
        switch self.selectionType {
        case .none:
            return false
        case .single:
            if self.selectedIndexPaths.count == 0{
                self.selectedIndexPaths.append(indexPath)
            } else if self.selectedIndexPaths[0] != indexPath {
                self.selectedIndexPaths[0] = indexPath
            } else {
                self.selectedIndexPaths.removeAll()
            }
        case .mutable:
            if let index = self.selectedIndexPaths.index(of: indexPath) {
                self.selectedIndexPaths.remove(at: index)
            } else {
                if self.selectedIndexPaths.count >= self.maxDay {
                    let error = String(format: "您最多可以选取%d天", self.maxDay)
                    self.delegate?.calenadr(self, didSelect: self.indexPathFotDates(), error: error)
                    return false
                }
                self.selectedIndexPaths.append(indexPath)
            }
        case .section:
            if self.selectedIndexPaths.count == 0 {
                self.selectedIndexPaths.append(indexPath)
                
            } else if self.selectedIndexPaths.count == 1 {
                // 如果已被选中，则删除
                if self.selectedIndexPaths[0] == indexPath {
                    self.selectedIndexPaths.removeAll()
                    
                } else {
                    // 不能大于maxDay最大选择天数
                    if self.getIndexPathsDayNum(self.selectedIndexPaths[0], toIndexPath: indexPath) > self.maxDay {
                        let error = String(format: "您最多可以选取%d天", self.maxDay)
                        self.delegate?.calenadr(self, didSelect: self.indexPathFotDates(), error: error)
                        return false
                    } else {
                        let result = self.selectedIndexPaths[0].compare(indexPath)
                        switch result {
                        case .orderedSame:
                            return false
                        case .orderedAscending:     // 升序直接添加
                            self.selectedIndexPaths.append(indexPath)
                        case .orderedDescending:    // 降序直接插入到第一个
                            self.selectedIndexPaths.insert(indexPath, at: 0)
                        }
                    }
                }
            } else  {
                self.selectedIndexPaths.removeAll()
                self.selectedIndexPaths.append(indexPath)
            }
        }
        self.delegate?.calenadr(self, didSelect: self.indexPathFotDates(), error: nil)
        self.monthInfoCache = nil
        return true
    }
    
    /// indexPath数组转date数组，并排序
    fileprivate func indexPathFotDates() -> [Date] {
        let selectDates = self.selectedIndexPaths.flatMap { (indexPath) -> Date? in
            self.getDate(indexPath)
        }
        return selectDates.sorted()
    }
    
    func cleanAllDate() {
        self.selectedIndexPaths.removeAll()
        self.delegate?.calenadr(self, didSelect: [Date](), error: nil)
        self.monthInfoCache = nil
    }
    
}

class BoneCalenadrDataSource {
    /// 默认最小最大年月
    fileprivate static let defaultMinDate = Date(timeIntervalSince1970: -28800)
    fileprivate static let defaultMaxDate = Date(timeIntervalSince1970:2145801599)
    
    /// 日历开始的日期
    fileprivate var firstDate: Date!
    
    /// 日历结束的日期
    fileprivate var lastDate: Date!
    
    
    /// 最大选中日期范围
    fileprivate var maxDay: Int = 365
    
    /// 用户设置的开始日期的月初那一秒
    fileprivate var firstDateMonthBegainDate: Date!
    
    /// 用户设置的结束日期的月末那一秒
    fileprivate var lastDateMonthEndDate: Date!
    
    fileprivate var monthInfoCache: MonthInfoCache?
    
    /// 日历类
    fileprivate lazy var calendar: Calendar = {
        return Calendar.current
    }()
    
    /// 当天所在的IndexPath
    fileprivate var todayIndex: IndexPath?
    
    /// 选中的日子所在的位置的数组，单选保持0-1个值，多选 0-N个值,节选 0-2个值
    fileprivate var selectedIndexPaths = [IndexPath]()
    
    /// 设置日期编码
    var formatter: DateFormatter
    
    var delegate: BoneCalenadrDataSourceDelegate?
    
    /// 选择模式
    public var selectionType: SelectionType = .none
    

    //使用默认的开始和结束时间
    public convenience init(){
        self.init(
            startDate: BoneCalenadrDataSource.defaultMinDate,
            endDate:BoneCalenadrDataSource.defaultMaxDate
        )
    }
    //使用自定义的开始和结束时间
    public init(startDate: Date, endDate: Date) {
        
        let result = startDate.compare(endDate)
        // 降序
        if result == .orderedDescending {
            fatalError("startDate must smaller than endDate")
        }
        self.formatter = DateFormatter()
        self.startDate = startDate
        self.endDate = endDate
        formatter.dateFormat = "yyyy年MM月"
        
        
    }
    
    fileprivate func getMonthInfo(_ section: Int) -> MonthInfoCache {
        if self.monthInfoCache?.section != section{
            //每月1号那天
            let firstOfMonth =  self.firstOfMonthForSection(section)
            
            //需要填补的天数
            let ordinalityOfFirstDay =  (self.calendar as NSCalendar).component(.weekday, from: firstOfMonth) - 1
            
            var offset = DateComponents()
            offset.day = -ordinalityOfFirstDay
            
            let placeHolderFirstOfMonth = (self.calendar as NSCalendar).date(byAdding: offset, to: firstOfMonth, options: NSCalendar.Options(rawValue: 0))!
            let nsCalendar = (calendar as NSCalendar)
            
            //这个月天数
            let ordinalityOfLastDay = nsCalendar.range(of: .day, in: .month, for: firstOfMonth).length
            
            var todayIndexInMonth = -1
            
            if section == todayIndex?.section {
                todayIndexInMonth = todayIndex!.row
            }
            self.monthInfoCache = MonthInfoCache(calendar: self.calendar, section: section, monthStartDate: placeHolderFirstOfMonth, thisMonthDayStart: ordinalityOfFirstDay, thisMonthDayEnd: ordinalityOfFirstDay + ordinalityOfLastDay - 1, todayIndex: todayIndexInMonth)
            
            self.setSelectedInfo(section)
            if section == 0 {
                let unselectedEnd = nsCalendar.components(.day, from: placeHolderFirstOfMonth, to: firstDate, options: NSCalendar.Options(rawValue: 0)).day! - 1
                let unselectedStart = ordinalityOfFirstDay
                self.monthInfoCache!.unselectedableStartIndex = unselectedStart
                self.monthInfoCache!.unselectedableEndIndex = unselectedEnd
            }
            
            if section == monthCount - 1 {
                let unselectedStart = nsCalendar.components(.day, from: placeHolderFirstOfMonth, to: lastDate, options: NSCalendar.Options(rawValue: 0)).day! + 1
                
                let unselectedEnd = ordinalityOfFirstDay + ordinalityOfLastDay - 1
                self.monthInfoCache!.unselectedableStartIndex = unselectedStart
                self.monthInfoCache!.unselectedableEndIndex = unselectedEnd
            }
        }
        return self.monthInfoCache!
    }
    
    //把时时分分秒秒的信息改成0
    fileprivate func clampDate(date: Date, toComponents unitFlags: NSCalendar.Unit) -> Date {
        let components = (self.calendar as NSCalendar).components(unitFlags, from: date)
        return self.calendar.date(from: components)!
    }
    
    //某个section的对应月份开始那天
    fileprivate func firstOfMonthForSection(_ monthIndex: Int) -> Date  {
        var offset = DateComponents()
        offset.month = monthIndex
        return (self.calendar as NSCalendar).date(byAdding: offset, to: firstDateMonthBegainDate, options: NSCalendar.Options(rawValue: 0))!
    }
    
    // 获取两个indexPath的间隔天数
    fileprivate func getIndexPathsDayNum(_ fromIndexPath: IndexPath, toIndexPath: IndexPath) -> Int {
        let date1 = self.getDate(fromIndexPath)
        let date2 = self.getDate(toIndexPath)
        let fromDate = self.clampDate(date: date1, toComponents: [.year, .month, .day])
        let toDate = self.clampDate(date: date2, toComponents: [.year, .month, .day])
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var result = gregorian?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options(rawValue: 0))
        return abs(result?.day ?? 0) + 1
    }
    
    fileprivate func setSelectedInfo(_ section: Int) {
        let daysInmonth: Int = self.daysInMonth(section)
        var startIndex = -1
        var endIndex = -1
        let count = selectedIndexPaths.count
        switch count {
        case 0:
            break
        case 2:
            if selectionType == .section {
                if selectedIndexPaths[0].section < section {
                    if section < selectedIndexPaths[1].section {
                        startIndex = 0
                        endIndex = daysInmonth - 1
                    } else if section == selectedIndexPaths[1].section{
                        startIndex = 0
                        endIndex = selectedIndexPaths[1].row
                    }

                } else if selectedIndexPaths[0].section == section {
                    if section < selectedIndexPaths[1].section {
                        startIndex = selectedIndexPaths[0].row
                        endIndex = daysInmonth - 1
                    } else if section == selectedIndexPaths[1].section {
                        startIndex = selectedIndexPaths[0].row
                        endIndex = selectedIndexPaths[1].row
                    }
                }
                monthInfoCache?.selectedStartIndex = startIndex
                monthInfoCache?.selectedendIndex = endIndex
                
            } else {
                fallthrough
            }
        default:
            for indexPath in selectedIndexPaths {
                if indexPath.section == section{
                    monthInfoCache?.selectedIndex.insert(indexPath.row)
                }
            }
        }
    }
    
    /// 时间格式化
    fileprivate func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.string(from: date)
        return date
    }
}

extension BoneCalenadrDataSource {
    
    /// 月信息缓存
    fileprivate class MonthInfoCache {
        let section: Int
        var monthStartDate: Date        // 月开始日期
        var thisMonthDayStart: Int      // 本月日开始
        var thisMonthDayEnd: Int        // 本月日结束
        var todayIndex: Int             // 今天
        
        var selectedIndex = Set<Int>()
        var selectedStartIndex = -1
        var selectedendIndex = -1
        
        var unSelectableIndex: Set<Int>?
        var unselectedableStartIndex = -1
        var unselectedableEndIndex = -1
        var calendar: Calendar?
        var dateComponents = DateComponents()
        
        
        init(calendar: Calendar?, section: Int, monthStartDate: Date, thisMonthDayStart: Int, thisMonthDayEnd: Int, todayIndex: Int){
            self.calendar = calendar
            self.section = section
            self.monthStartDate = monthStartDate
            self.thisMonthDayStart = thisMonthDayStart
            self.thisMonthDayEnd = thisMonthDayEnd
            self.todayIndex = todayIndex
        }
        
        convenience init(section: Int) {
            self.init(calendar:nil, section: -1,monthStartDate: Date(), thisMonthDayStart: -1, thisMonthDayEnd: -1, todayIndex: -1)
        }
        
        func getDayInfo(_ index: Int, selectedType: SelectionType) -> (Date, DayStateOptions) {
            dateComponents.day = index
            let date = (self.calendar! as NSCalendar).date(byAdding: dateComponents, to: monthStartDate, options: NSCalendar.Options(rawValue: 0))!
            var options = DayStateOptions(rawValue:0)
            
            if index == todayIndex {
                options = [options,.Today]
            }
            
            if index < thisMonthDayStart || index > thisMonthDayEnd {
                options = [options,.NotThisMonth]
            }
            
            if index >= unselectedableStartIndex && index <= unselectedableEndIndex {
                options = [options,.UnSelectable]
            } else {
                if selectedType != .section {
                    if self.selectedIndex.contains(index) {
                        options = [options,.Selected,.SelectedLeftNone,.SelectedRightNone]
                    }
                } else {
                    if selectedStartIndex != -1{
                        if selectedStartIndex <= index && index <= selectedendIndex {
                            options = [options, .Selected]
                            if selectedStartIndex == index {
                                options = [options,.SelectedLeftNone]
                            } else if index == selectedendIndex {
                                options = [options, .SelectedRightNone]
                            }
                        }
                    } else {
                        if selectedIndex.contains(index) {
                            options = [options, .Selected, .SelectedLeftNone, .SelectedRightNone]
                        }
                    }
                }
            }
            return (date,options)
        }
    }
    
    public struct DayStateOptions: OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt){
            self.rawValue = rawValue
        }
        //不在本月
        public static var NotThisMonth: DayStateOptions {
            return DayStateOptions(rawValue: 1<<0)
        }
        //是今天
        public static var Today: DayStateOptions {
            return DayStateOptions(rawValue: 1<<1)
        }
        //不可选择
        public static var UnSelectable: DayStateOptions {
            return DayStateOptions(rawValue: 1<<2)
        }
        //被选中
        public static var Selected: DayStateOptions {
            return DayStateOptions(rawValue: 1<<3)
        }
        //左边没选择
        public static var SelectedLeftNone: DayStateOptions {
            return DayStateOptions(rawValue: 1<<4)
        }
        //右边没选择
        public static var SelectedRightNone: DayStateOptions {
            return DayStateOptions(rawValue: 1<<5)
        }
        var roundType: RoundType {
            get{
                if self.contains(.Selected) {
                    if self.contains(.SelectedRightNone) {
                        if self.contains(.SelectedLeftNone) {
                            return .single
                        } else {
                            return .end
                        }
                    } else {
                        if self.contains(.SelectedLeftNone) {
                            return .start
                        } else {
                            return .middle
                        }
                    }
                } else {
                    return .none
                }
            }
        }
    }
    
    // 圆形状态类型
    public enum RoundType {
        case single // 单一的
        case start  // 开始
        case middle // 中间的
        case end    // 结束
        case none   // 无
    }
    
    // 选择类型
    public enum SelectionType: String{
        case none       // 无效
        case single     // 单选
        case mutable    // 多选
        case section    // 区间
    }
    
    // 选择类型
    enum ButtonType: Int {
        case clean = 0     // 清除
        case today = 1     // 回到今日
        case confirm = 2   // 确认
    }
}


