//
//  BoneListsCell.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/12.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneListsCell: UITableViewCell {
    
    var selectView1: UIView!        // 左边选中样式
    var selectView2: UIImageView!   // 右边选中样式
    var selectColor = UIColor.gray {
        didSet {
            self.selectView2.image = self.selectView2.image?.color(self.selectColor)
            self.selectView1.backgroundColor = self.selectColor
        }
    }
    var fontColor = UIColor.gray
    var listLeftWidth: CGFloat? {
        didSet {
            guard let width = self.listLeftWidth else {
                return
            }
            self.selectView2.frame.origin.x = (UIScreen.main.bounds.width - width) - self.selectView2.frame.width
        }
    }
    typealias Size = BoneCustomPopup.Size
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initiali()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initiali() {
        self.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.selectView1 = UIView(frame: CGRect(
            origin: CGPoint(x: 0, y: 12),
            size: CGSize(width: 4, height: Size.rowHeight - 24))
        )
        self.contentView.addSubview(self.selectView1)
        
        self.selectView2 = UIImageView(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: 30, height: Size.rowHeight))
        )
        self.selectView2.contentMode = .center
        let image = UIImage(named: "BoneCustomIcon.bundle/select")?.color(self.selectColor)
        self.selectView2.image = image
        self.contentView.addSubview(self.selectView2)
    }
}
