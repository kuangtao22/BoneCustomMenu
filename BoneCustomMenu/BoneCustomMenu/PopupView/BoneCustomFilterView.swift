//
//  BoneCustomFilterView.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/15.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCustomFilterView: UIView {
    
    typealias Model = BoneFilterCell.Model
    
    fileprivate var items = [[Model]]()
    fileprivate var tableView: UITableView!
    fileprivate var cleanBtn: UIButton!
    fileprivate var confirmBtn: UIButton!
    fileprivate var selectArray = [[Int]]()
    
    var delegate: BoneCustomDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cleanBtn = self.getButton(left: 0)
        self.cleanBtn.setTitle("清除", for: UIControlState.normal)
        self.cleanBtn.backgroundColor = UIColor.white
        self.cleanBtn.setTitleColor(BoneCustomPopup.Color.font, for: UIControlState.normal)
        self.cleanBtn.layer.borderWidth = 0.5
        self.cleanBtn.addTarget(self, action: #selector(BoneCustomFilterView.cleanAction), for: UIControlEvents.touchUpInside)
        self.cleanBtn.layer.borderColor = BoneCustomPopup.Color.line.cgColor
        self.addSubview(self.cleanBtn)
        
        self.confirmBtn = self.getButton(left: self.frame.width / 2)
        self.confirmBtn.setTitle("确认", for: UIControlState.normal)
        self.confirmBtn.backgroundColor = BoneCustomPopup.Color.fontSelect
        self.confirmBtn.addTarget(self, action: #selector(BoneCustomFilterView.confirmAction), for: UIControlEvents.touchUpInside)
        self.addSubview(self.confirmBtn)
    
        self.tableView = UITableView(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: self.frame.width, height: self.frame.height - self.cleanBtn.frame.height)),
            style: .grouped
        )
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = BoneCustomPopup.Color.line
        self.tableView.backgroundColor = BoneCustomPopup.Color.section
        self.addSubview(self.tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func getButton(left: CGFloat) -> UIButton {
        let button = UIButton(frame: CGRect(x: left, y: self.frame.height - 45, width: self.frame.width / 2, height: 45))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }
    
    @objc private func cleanAction() {
        for i in 0..<self.selectArray.count {
            self.selectArray[i] = []
        }
        self.delegate?.customList(self, didSelect: self.selectArray, isConfirm: false)
        self.tableView.reloadData()
    }
    
    @objc private func confirmAction() {
        self.delegate?.customList(self, didSelect: self.selectArray, isConfirm: true)
    }
}


extension BoneCustomFilterView: BoneCustomMenuProtocol {
    
    func reloadData() {
        guard let delegate = self.delegate else {
            return
        }
        self.items = [[Model]]()
        self.selectArray = delegate.customFilter(self)
        for i in 0..<delegate.numberOfSection(self) {
            if self.selectArray.count < delegate.numberOfSection(self) {
                self.selectArray.append([])
            }
            self.items.append([])
            for y in 0..<delegate.customList(self, numberOfRowsInSections: i) {
                let title = delegate.customList(self, titleForSectionInRow: i, row: y)
                self.items[i].append(Model(icon: nil, title: title))
            }
        }
        self.tableView.reloadData()
    }
}

extension BoneCustomFilterView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.delegate?.numberOfSection(self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BoneFilterCell.getHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.delegate?.customList(self, titleInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let count = self.delegate?.numberOfSection(self) ?? 0
        return section == count - 1 ? 30 : 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "FilterCell\(indexPath.section)"
        var cell = tableView.cellForRow(at: indexPath) as? BoneFilterCell
        if cell == nil {
            cell = BoneFilterCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
            if let type = self.delegate?.customList(self, filterDidForSectionAt: indexPath.section) {
                cell?.type = type
            }
        }
        if self.items.count > 0 {
            cell?.datas = self.items[indexPath.section]
        }
        cell?.selects = self.selectArray[indexPath.section]
        cell?.onClickAction(cellback: { (array) in
            self.selectArray[indexPath.section] = array
        })
        return cell!
    }
}
