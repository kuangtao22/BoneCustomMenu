//
//  BoneListsCell.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/12.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneListsCell: UITableViewCell {

    var view: UIView!
    
    var selectView1: UIView!
    var selectView2: UIImageView!
    
    typealias Color = BoneCustomPopup.Color
    typealias Size = BoneCustomPopup.Size
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.font = UIFont.systemFont(ofSize: Size.font)
        
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
        self.selectedBackgroundView = self.view
        
        self.selectView1 = UIView(frame: CGRect(
            origin: CGPoint(x: 0, y: 12),
            size: CGSize(width: 4, height: Size.rowHeight - 24))
        )
        self.view.addSubview(self.selectView1)
        
        self.selectView2 = UIImageView(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: 30, height: Size.rowHeight))
        )
        self.selectView2.contentMode = .center
        self.selectView2.image = BoneCustomPopup.Icon.select
        self.view.addSubview(self.selectView2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(_ isSelect: Bool, isLeft: Bool, tableView: UITableView) {
        if isLeft {
            self.backgroundColor = Color.section
            self.selectView1.backgroundColor = Color.fontSelect
            
        } else {
            self.backgroundColor = UIColor.white
            self.selectView2.frame.origin.x = tableView.frame.width - self.selectView2.frame.width
        }
        self.selectView2.isHidden = isLeft
        self.selectView1.isHidden = !self.selectView2.isHidden
        
        if isSelect {
            self.textLabel?.textColor = Color.fontSelect
        } else {
            self.textLabel?.textColor = Color.font
        }
    }
}
