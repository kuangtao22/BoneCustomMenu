//
//  BoneListsView.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/11.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCustomListsView: UIView {
    
    var fontColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
    
    var selectColor = UIColor(red: 0/255, green: 139/255, blue: 254/255, alpha: 1)
    ///
    var sectionColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    /// 行高
    var rowHeight: CGFloat = 45
    /// 代理方法
    var delegate: BoneCustomDelegate?  {
        didSet {
            self.dataSource.delegate = self.delegate
        }
    }
    
    /// 设置高度
    var setHeight: CGFloat? {
        didSet {
            guard let height = self.setHeight else {
                return
            }
            self.frame.size.height = height
            self.leftTable.frame.size.height = height
            self.rightTable.frame.size.height = height
        }
    }
    
    fileprivate var leftTable: UITableView!
    fileprivate var rightTable: UITableView!
//    fileprivate var selectSection = 0           // 点击左边tableView
//    fileprivate var selectIndexPath: IndexPath! // 右边tableView

    fileprivate var dataSource = BoneCustomListSource()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.leftTable = UITableView(
            frame: CGRect(x: 0, y: 0, width: self.dataSource.leftWidth, height: self.frame.height),
            style: UITableViewStyle.plain
        )
        self.leftTable.rowHeight = self.rowHeight
        self.leftTable.delegate = self
        self.leftTable.dataSource = self
        self.leftTable.separatorColor = UIColor.clear   // 隐藏分割线
        self.leftTable.backgroundColor = self.sectionColor
        self.addSubview(self.leftTable)
        
        self.rightTable = UITableView(
            frame: CGRect(x: self.leftTable.frame.width, y: 0, width: self.frame.width - self.leftTable.frame.width, height: self.leftTable.frame.height),
            style: UITableViewStyle.plain
        )
        self.rightTable.rowHeight = self.leftTable.rowHeight
        self.rightTable.delegate = self
        self.rightTable.dataSource = self
        self.rightTable.separatorColor = UIColor.clear
        self.addSubview(self.rightTable)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BoneCustomListsView: BoneCustomMenuProtocol {
    
    /// 重载数据
    func reloadData() {
        self.dataSource.initData()
        let isTwoCol = self.dataSource.isTwoCol
        self.leftTable.isHidden = self.dataSource.isLeftHidden
        self.leftTable.frame.size.width = self.dataSource.leftWidth
        self.rightTable.frame.size.width = self.dataSource.rightWidth
        self.rightTable.frame.origin.x = isTwoCol ? self.dataSource.leftWidth : 0
        if isTwoCol {
            self.leftTable.reloadData()
            for i in 0..<self.leftTable.numberOfSections {
                if self.leftTable.numberOfRows(inSection: i) > 0 {
                    // 自动定位到选中行
                    let leftIndex = IndexPath(row: self.dataSource.selectRow.section, section: 0)
                    self.leftTable.scrollToRow(at: leftIndex, at: .middle, animated: false)
                }
            }
        }
        self.rightTable.reloadData()
        for i in 0..<self.rightTable.numberOfSections {
            if self.rightTable.numberOfRows(inSection: i) > 0 {
                let rightIndex = IndexPath(row: self.dataSource.selectRow.row, section: 0)
                self.rightTable.scrollToRow(at: rightIndex, at: .middle, animated: false)
            }
        }
    }
}


extension BoneCustomListsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.rowNum(tableView == self.leftTable)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isLeft = tableView == self.leftTable
        let identifier = "ListCell\(indexPath.row)\(isLeft)"
        let isTwoCol = self.dataSource.isTwoCol
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BoneListsCell
        if cell == nil {
            cell = BoneListsCell(style: .default, reuseIdentifier: identifier)
            cell?.textLabel?.textColor = self.fontColor
            cell?.backgroundColor = isLeft ? self.sectionColor : UIColor.white
            cell?.selectColor = self.selectColor
            cell?.fontColor = self.fontColor
        }
        cell?.listLeftWidth = self.dataSource.leftWidth
        if isLeft {
            if isTwoCol {
                let isSelect = self.dataSource.sectionState(indexPath.row)
                cell?.textLabel?.textColor = isSelect ? self.selectColor : self.fontColor
                cell?.selectView1.isHidden = !isSelect
                cell?.textLabel?.text = self.dataSource.sectionTitle(indexPath.row)
            }
            
        } else {
            let isSelect = self.dataSource.rowState(indexPath.row)
            cell?.selectView2.isHidden = !isSelect
            if !isTwoCol {
                cell?.selectView1.isHidden = !isSelect
            }
            cell?.textLabel?.text = self.dataSource.rowTitle(indexPath.row)
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.leftTable {
            self.dataSource.onClickLeft(indexPath.row)
            self.leftTable.reloadData()
            self.rightTable.reloadData()

        } else {
            self.dataSource.onClickRight(indexPath.row)
            self.rightTable.reloadData()
        }
        
    }
}
