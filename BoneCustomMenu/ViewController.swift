//
//  ViewController.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/7.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var data1 = [String]()
    var data2 = [String]()
    var data3 = ["综合排序", "距离最近", "关注最高", "销量最高"]
    var filters = ["配送方式", "优惠活动", "人均消费"]
    var filterArray1 = ["蜂鸟专送", "普通快递"]
    var filterArray2 = ["新用户优惠", "特价商品", "下单立减", "赠品优惠", "下单返券", "进店领券"]
    var filterArray3 = ["￥20以下", "￥20~40", "￥40以上"]
    var filterArrays = [[String]]()

    var menuView: BoneCustomMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.lightGray
        self.filterArrays = [filterArray1, filterArray2, filterArray3]
        for i in 0...20 {
            self.data1.append("父类\(i)")
        }
        
        for i in 0...20 {
            self.data2.append("子类\(i)")
        }

        menuView = BoneCustomMenu(top: 200, height: 40)
        menuView.delegate = self
        BoneCustomPopup.Color.font = UIColor.gray   // 字体颜色
//        BoneCustomPopup.Color.fontSelect = UIColor.red
//        BoneCustomPopup.Color.line // 分割线颜色
        self.view.addSubview(menuView)
        
        menuView.reloadData()
        
        menuView.calendarView.selectDates = [date("2013-04-11"), date("2013-03-23")]
        menuView.calendarView.selectMaxDay = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func date(_ string: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date = dateFormat.date(from: string)
        return date!
    }

}

extension ViewController: BoneCustomMenuDelegate {

    
    func boneMenu(_ menu: BoneCustomMenu, filterDidForSectionAt indexPath: BoneCustomPopup.IndexPath) -> BoneCustomPopup.FilterType? {
        if indexPath.column == 3 {
            if indexPath.section == 0 {
                return BoneCustomPopup.FilterType.only
            } else if indexPath.section == 1 {
                return BoneCustomPopup.FilterType.multi
            } else if indexPath.section == 2 {
                return BoneCustomPopup.FilterType.only
            }
        }
        return nil
    }
    
    
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtColumn column: Int, filterDatas: [[Int]]) {
        print("filterDatas:\(filterDatas)")
    }
    
    
    
    internal func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtIndexPath indexPath: BoneCustomPopup.IndexPath) {
        print("indexPath:\(indexPath)")
    }

   
    /// 返回 boneMenu row标题
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    internal func boneMenu(_ menu: BoneCustomMenu, titleForRowAt indexPath: BoneCustomPopup.IndexPath) -> String {
        if indexPath.column == 0 {
            return self.data2[indexPath.row]
            
        } else if indexPath.column == 3 {
            return self.filterArrays[indexPath.section][indexPath.row]
        }
        return "ccccccc"
    }

    
    
    /// 返回 boneMenu section标题
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    ///   - section:
    /// - Returns:
    internal func boneMenu(_ menu: BoneCustomMenu, titleForSectionAt indexPath: BoneCustomPopup.IndexPath) -> String {
        if indexPath.column == 0 {
            return self.data1[indexPath.section]
        } else if indexPath.column == 1 {
            return self.data3[indexPath.section]
        } else if indexPath.column == 3 {
            return self.filters[indexPath.section]
        }
        return ""
    }
    
    

    /// 返回 boneMenu column类型
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    /// - Returns:
    internal func boneMenu(_ menu: BoneCustomMenu, typeForColumnAt column: Int) -> BoneCustomPopup.ColumnInfo {
        if column == 0 {
            return BoneCustomPopup.ColumnInfo(title: "分类", type: .list)
        } else if column == 1 {
            return BoneCustomPopup.ColumnInfo(title: "时间选择", type: .calendar)
        } else if column == 2 {
            return BoneCustomPopup.ColumnInfo(title: "是否买单", type: .button)
        }
        return BoneCustomPopup.ColumnInfo(title: "筛选", type: .filter)
        
    }
    
    
    /// 返回 boneMenu 第column列section区有多少行
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    ///   - section:
    /// - Returns: 二级列表行数
    internal func boneMenu(_ menu: BoneCustomMenu, numberOfRowsInSections indexPath: BoneCustomPopup.IndexPath) -> Int {
        if indexPath.column == 0 {
            return self.data2.count
        } else if indexPath.column == 3 {
            return self.filterArrays[indexPath.section].count
        }
        return 0    // 如果是button类型，直接返回0就可以了
    }
    
    

    /// 返回 boneMenu 第column列有多少行
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    /// - Returns:
    internal func boneMenu(_ menu: BoneCustomMenu, numberOfSectionsInColumn column: Int) -> Int {
        if column == 0 {
            return self.data1.count
        } else if column == 1 {
            return self.data3.count
        } else if column == 3 {
            return self.filters.count
        }
        return 0    // 如果是button类型，直接返回0就可以了
    }
    
    

    /// 返回 boneMenu 有多少列 ，默认1列
    ///
    /// - Parameter menu
    /// - Returns
    internal func numberOfColumns(_ menu: BoneCustomMenu) -> Int {
        return 4
    }

    func boneMenu(_ menu: BoneCustomMenu, didSelectCalendar date: [Date], error: String?) {
        print("error:\(error)")
        print("date:\(date)")
    }
    
}
