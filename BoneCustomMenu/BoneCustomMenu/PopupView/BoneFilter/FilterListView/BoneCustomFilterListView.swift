//
//  BoneCustomFilterListView.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/10.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCustomFilterListView: UIView {

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

    
    fileprivate var dataSource = BoneFilterSource()
    fileprivate var leftTable: UITableView!
    var rightTable: UITableView!
    fileprivate var footView: BoneFilterFootView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.footView = BoneFilterFootView(self.frame.height - 45, width: self.frame.width)
        self.footView.onClick = { type in
            switch type {
            case .clean:
                self.cleanAction()
            case .confirm:
                self.confirmAction()
            }
        }
        self.addSubview(self.footView)
        
        self.leftTable = UITableView(
            frame: CGRect(x: 0, y: 0, width: self.dataSource.leftWidth, height: self.frame.height - self.footView.frame.height),
            style: UITableViewStyle.plain
        )
        self.leftTable.rowHeight = BoneCustomPopup.Size.rowHeight
        self.leftTable.delegate = self
        self.leftTable.dataSource = self
        self.leftTable.separatorColor = UIColor.clear   // 隐藏分割线
        self.leftTable.backgroundColor = BoneCustomPopup.Color.section
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
    
    /// 清除事件
    @objc private func cleanAction() {
        self.dataSource.cleanData()
        if self.dataSource.isTwoCol { self.leftTable.reloadData() }
        self.rightTable.reloadData()
    }
    
    
    /// 确认事件
    @objc private func confirmAction() {
        self.dataSource.submitData()
    }
}

extension BoneCustomFilterListView: BoneCustomMenuProtocol {
    
    func reloadData() {
        self.dataSource.initData()
        
        let isTwoCol = self.dataSource.isTwoCol
        self.leftTable.isHidden = self.dataSource.isLeftHidden
        self.leftTable.frame.size.width = self.dataSource.leftWidth
        self.rightTable.frame.size.width = self.dataSource.rightWidth
        self.rightTable.frame.origin.x = isTwoCol ? self.dataSource.leftWidth : 0
        if self.dataSource.isTwoCol {
            self.leftTable.reloadData()
        }
        self.rightTable.reloadData()
        self.footView.reloadData()
    }
}

extension BoneCustomFilterListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.leftTable {
            return self.dataSource.sectionNum
        } else {
            return self.dataSource.rowNum(self.dataSource.selectSection)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isLeft = tableView == self.leftTable
        let isTwoCol = self.dataSource.isTwoCol
        let identifier = "FilterListCell\(indexPath.row)\(isLeft)"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BoneListsCell
        if cell == nil {
            cell = BoneListsCell(style: .default, reuseIdentifier: identifier)
        }
        if isLeft {
            let isSelect = self.dataSource.sectionState(indexPath.row)
            cell?.set(isLeft: isLeft, isSelect: isSelect, isTwo: isTwoCol)
            cell?.textLabel?.text = self.dataSource.sectionTitle(indexPath.row)
            cell?.num = self.dataSource.rowSumFor(indexPath.row)
        } else {
            let indexPath = IndexPath(row: indexPath.row, section: self.dataSource.selectSection)
            let isSelect = self.dataSource.rowState(indexPath)
            cell?.set(isLeft: isLeft, isSelect: isSelect, isTwo: isTwoCol)
            cell?.textLabel?.text = self.dataSource.rowTitle(indexPath)
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.leftTable {
            self.dataSource.onClickLeft(indexPath.row)
            self.leftTable.reloadData()
            self.rightTable.reloadData()
            
        } else {
            
            let index = IndexPath(row: indexPath.row, section: self.dataSource.selectSection)
            self.dataSource.onClickRight(index)
            
            switch self.dataSource.getSelectType(self.dataSource.selectSection) {
            case .multi:
                if self.dataSource.isTwoCol {
                    self.leftTable.reloadRows(at: [IndexPath(row: self.dataSource.selectSection, section: 0)], with: .none)
                }
                self.rightTable.reloadRows(at: [indexPath], with: .none)
                
            case .only:
                if self.dataSource.isTwoCol {
                    self.leftTable.reloadData()
                }
                self.rightTable.reloadData()
            }
        }
        
    }
}

