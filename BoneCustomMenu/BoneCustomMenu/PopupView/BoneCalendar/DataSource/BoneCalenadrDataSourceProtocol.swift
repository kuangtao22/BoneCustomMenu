//
//  BoneCalenadrProtocol.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/10/26.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneCalenadrDataSourceProtocol {
    
    var selectDates: [Date] { get set }
    
    /// 日历开始的日期, 计算属性
    var startDate: Date { get set }
    
    /// 日历结束的日期, 计算属性
    var endDate: Date { get set }
    
    /// 选中日期最大数
    var selectMaxDay: Int { get set }
    
    /// 多少年
    var yearCount: Int { get }
    
    /// 多少月
    var monthCount: Int { get }
    
    /// 一星期多少天
    var weekCount: Int { get }
    
    /// 一个月多少天
    func daysInMonth(_ monthIndex: Int) -> Int
    
    /// 每天的信息
    func dayState(_ indexPath: IndexPath) -> (Date, BoneCalenadrDataSource.DayStateOptions)
    
    /// 格式化天日期
    func dayString(_ fromDate: Date) -> String
    
    /// 每年的时间
    func yearState(_ item: Int) -> Date
    
    /// 输出年
    func yearString(_ item: Int) -> Int
    
    /// 格式化日期
    func dateString(_ fromDate: Date) -> String
    
    /// 某个section的对应月份有几个星期
    func weeksInMonth(_ monthIndex: Int) -> Int
    
    /// 某个section的对应月份的信息 目前和firstOfMonthForSection差不多
    func monthState(_ monthIndex: Int) -> Date
    
    /// 获取当前indexPath时间
    func getDate(_ indexPath: IndexPath) -> Date
    
    /// 某日期所在的section
    func sectionForDate(_ date: Date) -> Int
    
    /// 某日期所在的IndexPath
    func indexPathForRowAtDate(_ date: Date) -> IndexPath
    
    /// 选中某天，返回true表示修改了selectedDates，collectionView需要刷新
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) -> Bool
    
    /// 清除所有选择
    func cleanAllDate()
}


/// 代理协议
protocol BoneCalenadrDataSourceDelegate {
    
    func calenadr(_ dataSource: BoneCalenadrDataSource, didSelect dates: [Date], error: String?)

}
