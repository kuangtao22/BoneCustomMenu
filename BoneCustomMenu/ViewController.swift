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
    var dates = [Date]()

    var menuView: BoneCustomMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        self.filterArrays = [filterArray1, filterArray2, filterArray3]
        for i in 0...20 {
            self.data1.append("父类\(i)")
        }
        
        for i in 0...20 {
            self.data2.append("子类\(i)")
        }
        self.dates = [date("2018-04-11"), date("2018-04-23")]
        
        self.menuView = BoneCustomMenu(top: 100, height: 40)
        self.menuView.delegate = self
        self.menuView.dataSource = self
        self.menuView.isFilterBar = true    // 开启筛选工具栏
//        self.menuView.selectIndexPaths = [
//            BoneMenuIndexPath(column: 0, section: 1, row: 2),
//            BoneMenuIndexPath(column: 2, section: 0, row: 1),
//            BoneMenuIndexPath(column: 3, section: 1, row: 1),
//            BoneMenuIndexPath(column: 3, section: 0, row: 2),
//            BoneMenuIndexPath(column: 4, section: 1, row: 2)
//        ]
//        self.menuView.lineColor = UIColor.red //
        self.menuView.selectColor = UIColor(red: 244/255, green: 92/255, blue: 76/255, alpha: 1)
        self.menuView.fontSize = 14
        self.view.addSubview(menuView)
        
        self.menuView.reloadData()
        self.menuView.calendarView.maxDate = date("2018-09-20")
        self.menuView.calendarView.showTime = true
        self.menuView.calendarDates = self.dates
        self.menuView.calendarView.selectMaxDay = 20
        self.menuView.calendarView.selectType = .section
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

extension ViewController: BoneMenuDataSource {
    
    /// 返回 boneMenu 有多少列 ，默认1列
    ///
    /// - Parameter menu
    /// - Returns
    func numberOfColumns(_ menu: BoneCustomMenu) -> Int {
        return 6
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
            return self.filterArrays.count
        }
        return 0    // 如果是button类型，直接返回0就可以了
    }
    
    /// 返回 boneMenu 第column列section区有多少行
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    ///   - section:
    /// - Returns: 二级列表行数
    internal func boneMenu(_ menu: BoneCustomMenu, numberOfRowsInSections indexPath: BoneMenuIndexPath) -> Int {
        if indexPath.column == 0 {
            return self.data2.count
        } else if indexPath.column == 3 {
            if self.filterArrays.count > indexPath.section {
                return self.filterArrays[indexPath.section].count
            }
        } else if indexPath.column == 4 {
            return self.filterArray2.count
        }
        return 0    // 如果是button类型/单列，直接返回0就可以了
    }
    
    /// 返回 boneMenu column类型
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, typeForColumnAt column: Int) -> BoneMenuColumnInfo {
        if column == 0 {
            return BoneMenuColumnInfo(title: "分类", type: .filterList)
        } else if column == 1 {
            return BoneMenuColumnInfo(title: "时间选择", type: .calendar)
        } else if column == 2 {
            return BoneMenuColumnInfo(title: "是否买单", type: .button)
        } else if column == 3 {
            return BoneMenuColumnInfo(title: "筛选", type: .filter)
        } else if column == 4 {
            return BoneMenuColumnInfo(title: "一级单选", type: .list)
        }
        return BoneMenuColumnInfo(title: "自定义", type: .custom)
    }
    
    
    /// 返回 boneMenu section标题
    ///
    /// - Parameters:
    ///   - menu:
    ///   - column:
    ///   - section:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, titleForSectionAt indexPath: BoneMenuIndexPath) -> String {
        if indexPath.column == 0 {
            return self.data1[indexPath.section]
        } else if indexPath.column == 1 {
            return self.data3[indexPath.section]
        } else if indexPath.column == 3 {
            return self.filters[indexPath.section]
        } else if indexPath.column == 4 {
            return self.filterArray2[indexPath.section]
        }
        return ""
    }
    
    /// 返回 boneMenu row标题
    ///
    /// - Parameters:
    ///   - menu:
    ///   - indexPath:
    /// - Returns:
    func boneMenu(_ menu: BoneCustomMenu, titleForRowAt indexPath: BoneMenuIndexPath) -> String {
        if indexPath.column == 0 {
            return self.data2[indexPath.row]
            
        } else if indexPath.column == 3 {
            if self.filterArrays.count > indexPath.section {
                return self.filterArrays[indexPath.section][indexPath.row]
            }
            
        } else if indexPath.column == 4 {
            return self.filterArray2[indexPath.row]
        }
        return "ccccccc"
    }
    
    func boneMenu(_ menu: BoneCustomMenu, filterDidForSectionAt indexPath: BoneMenuIndexPath) -> BoneMenuSelectType? {
        if indexPath.section == 0 {
            return BoneMenuSelectType.multi
        } else if indexPath.section == 1 {
            return BoneMenuSelectType.multi
        } else if indexPath.section == 2 {
            return BoneMenuSelectType.only
        }
        return nil
    }

    func boneMenu(_ menu: BoneCustomMenu, menuHeightFor column: Int) -> CGFloat? {
        if column == 0 {
            return 450
        }
        return 400
    }
    
    func boneMenu(_ menu: BoneCustomMenu, customViewForSectionAt column: Int) -> UIView? {
        print("column:\(column)")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
        view.backgroundColor = UIColor.red
        return view
    }
}

extension ViewController: BoneMenuDelegate {
    
    
    func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtColumn indexPaths: [BoneMenuIndexPath]) {
        print("indexPaths:\(indexPaths)")
    }
    

    
    internal func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtIndexPath indexPath: BoneMenuIndexPath) {
        print("indexPath:\(indexPath)")
    }


    

    func boneMenu(_ menu: BoneCustomMenu, didSelectCalendar date: [Date], error: String?) {
        print("error:\(error)")
        print("date:\(date)")
        self.dates = date
    }
    
}
