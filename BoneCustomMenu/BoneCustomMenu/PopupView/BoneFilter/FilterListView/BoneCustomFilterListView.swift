//
//  BoneCustomFilterListView.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/10.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCustomFilterListView: UIView {
    /// 字体颜色
    var fontColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
    /// 选中颜色
    var selectColor = UIColor(red: 0/255, green: 139/255, blue: 254/255, alpha: 1)
    ///
    var sectionColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    
    var line = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)

    /// 行高
    var rowHeight: CGFloat = 45
    
    var listLeftWidth: CGFloat = UIScreen.main.bounds.width * 0.3
    /// 设置高度
    var setHeight: CGFloat? {
        didSet {
            guard let height = self.setHeight else {
                return
            }
            self.frame.size.height = height
            self.footView.frame.origin.y = height - self.footView.frame.height
            self.leftTable.frame.size.height = height - self.footView.frame.height
            self.rightTable.frame.size.height = height - self.footView.frame.height
        }
    }
    
    /// 代理方法
    var delegate: BoneCustomDelegate? {
        didSet {
            self.dataSource.delegate = self.delegate
        }
    }
    
    fileprivate var selectLeft = 0  // 记录左边点击行数
    
    fileprivate var dataSource = BoneFilterDataSource()
    fileprivate var leftTable: UITableView!
    fileprivate var rightTable: UITableView!
    fileprivate var footView: BoneFilterFootView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.footView = BoneFilterFootView(self.frame.height - 45, width: self.frame.width)
        self.footView.onClick = { type in
            switch type {
            case .clean:
                self.dataSource.cleanData()
                self.reloadData()
            case .confirm:
                self.dataSource.submitData()
            }
        }
        self.addSubview(self.footView)
        
        self.leftTable = UITableView(
            frame: CGRect(x: 0, y: 0, width: self.listLeftWidth, height: self.frame.height - self.footView.frame.height),
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

extension BoneCustomFilterListView: BoneCustomMenuProtocol {
    
    func reloadData() {
        self.dataSource.initData()
        self.selectLeft = 0
        if self.delegate?.isRight() == true {
            self.rightTable.isHidden = false
            self.leftTable.frame.size.width = self.frame.width - self.rightTable.frame.width
            self.rightTable.reloadData()
            
        } else {
            self.rightTable.isHidden = true
            self.leftTable.frame.size.width = self.frame.width
        }        
        self.leftTable.reloadData()

        self.footView.selectColor = self.selectColor
        self.footView.fontColor = self.fontColor
        self.footView.line = self.line
    }
    
    
}

extension BoneCustomFilterListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.leftTable {
            return self.dataSource.sectionNum
        } else {
            return self.dataSource.rowNum(section)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isLeft = tableView == self.leftTable
        
        let identifier = "FilterListCell\(indexPath.row)\(isLeft)"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BoneCustomFilterCell
        if cell == nil {
            cell = BoneCustomFilterCell(identifier, listLeftWidth: self.listLeftWidth)
            cell?.rowHeight = self.rowHeight
            cell?.textLabel?.textColor = self.fontColor
            cell?.selectColor = self.selectColor
            cell?.listLeftWidth = self.dataSource.isHaveRow ? self.listLeftWidth : 0
            cell?.fontColor = self.fontColor
            cell?.selectView2.isHidden = self.dataSource.isHaveRow ? isLeft : false
            cell?.selectView1.isHidden = !isLeft
            cell?.numLabel.isHidden = self.dataSource.isHaveRow ? (!isLeft) : true
        }
        if isLeft {
            let isSelect = self.selectLeft == indexPath.row
            cell?.backgroundColor = isSelect ? UIColor.white : self.sectionColor
            cell?.textLabel?.textColor = isSelect ? self.selectColor : self.fontColor
            cell?.selectView1.isHidden = !isSelect
            cell?.selectView2.isHidden = self.dataSource.isHaveRow ? true : !isSelect
            if self.dataSource.selectData.count > indexPath.row {
                cell?.num = self.dataSource.selectData[indexPath.row].count
            } else {
                cell?.num = 0
            }
            cell?.textLabel?.text = self.dataSource.getTitle(indexPath.row)
            
        } else {
            cell?.backgroundColor = UIColor.white
            let index = IndexPath(row: indexPath.row, section: self.selectLeft)
            cell?.textLabel?.text = self.dataSource.getSubTitle(index)
            cell?.selectView2.isHidden = !self.dataSource.getSelectState(index)
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.leftTable {
            self.selectLeft = indexPath.row
            self.leftTable.reloadData()
            self.rightTable.reloadData()
            
        } else {
            let index = IndexPath(row: indexPath.row, section: self.selectLeft)
            self.dataSource.updata(index)
            switch self.dataSource.getSelectType(self.selectLeft) {
            case .multi:
                self.rightTable.reloadRows(at: [indexPath], with: .none)
            case .only:
                self.rightTable.reloadData()
            }
            self.leftTable.reloadRows(at: [IndexPath(row: self.selectLeft, section: 0)], with: .automatic)
        }
        
    }
}

