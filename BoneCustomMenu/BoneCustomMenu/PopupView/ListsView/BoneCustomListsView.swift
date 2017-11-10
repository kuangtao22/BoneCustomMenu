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
    var delegate: BoneCustomDelegate?
    var listLeftWidth: CGFloat = UIScreen.main.bounds.width * 0.3
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
    fileprivate var selectSection = 0
    fileprivate var selectRow: SelectData!
    
    struct SelectData {
        var section: Int
        var row: Int
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.leftTable = UITableView(
            frame: CGRect(x: 0, y: 0, width: self.listLeftWidth, height: self.frame.height),
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
        
        self.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BoneCustomListsView: BoneCustomMenuProtocol {
    
    /// 重载数据
    func reloadData() {
        
        if let data = self.delegate?.getSelectData() {
            self.selectRow = data
            self.selectSection = data.section
        } else {
            self.selectRow = SelectData(section: self.selectSection, row: 0)
        }
        
        if self.delegate?.isRight() == true {
            self.rightTable.isHidden = false
            self.leftTable.frame.size.width = self.frame.width - self.rightTable.frame.width
            
        } else {
            self.rightTable.isHidden = true
            self.leftTable.frame.size.width = self.frame.width
        }

        self.leftTable.reloadData()
        for i in 0..<self.leftTable.numberOfSections {
            if self.leftTable.numberOfRows(inSection: i) > 0 {
                // 自动定位到选中行
                let leftIndex = IndexPath(row: self.selectRow.section, section: 0)
                self.leftTable.scrollToRow(at: leftIndex, at: .middle, animated: false)
            }
        }

        if self.delegate?.isRight() == true {
            self.rightTable.reloadData()
            let rightIndex = IndexPath(row: self.selectRow.row, section: 0)
            self.rightTable.scrollToRow(at: rightIndex, at: .middle, animated: false)
        }

    }
}


extension BoneCustomListsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.leftTable {
            return self.delegate?.numberOfSection() ?? 1
        } else {
            return self.delegate?.customList(numberOfRowsInSections: section) ?? 1
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isLeft = tableView == self.leftTable
        let identifier = "ListCell\(indexPath.row)\(isLeft)"
        let isHaveRow = self.delegate?.isRight() == true
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BoneListsCell
        if cell == nil {
            cell = BoneListsCell(style: .default, reuseIdentifier: identifier)
            cell?.textLabel?.textColor = self.fontColor
            cell?.selectColor = self.selectColor
            cell?.listLeftWidth = isHaveRow ? self.listLeftWidth : 0
            cell?.fontColor = self.fontColor
            cell?.selectView2.isHidden = isHaveRow ? isLeft : false
            cell?.selectView1.isHidden = !isLeft
        }
        if isLeft {
            let isSelect = indexPath.row == self.selectSection
            cell?.backgroundColor = isSelect ? UIColor.white : self.sectionColor
            cell?.textLabel?.textColor = isSelect ? self.selectColor : self.fontColor
            cell?.selectView1.isHidden = !isSelect
            cell?.selectView2.isHidden = isHaveRow ? true : !isSelect
            cell?.textLabel?.text = self.delegate?.customList(titleInSection: indexPath.row)
            
        } else {
            cell?.backgroundColor = UIColor.white
            let isSelect = (self.selectRow.row == indexPath.row) && (self.selectSection == self.selectRow.section)
            cell?.selectView2.isHidden = !isSelect
            cell?.textLabel?.text = self.delegate?.customList(titleForSectionInRow: self.selectSection, row: indexPath.row)
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.leftTable {
            self.selectSection = indexPath.row
            self.leftTable.reloadData()
            self.rightTable.reloadData()
            if self.delegate?.isRight() == false {
                self.delegate?.customList(didSelectRowAt: self.selectSection, row: 0)
            }
            
        } else {
            self.selectRow.section = self.selectSection
            self.selectRow.row = indexPath.row
            self.delegate?.customList(didSelectRowAt: self.selectRow.section, row: self.selectRow.row)
            self.rightTable.reloadData()
        }
        
    }
}
