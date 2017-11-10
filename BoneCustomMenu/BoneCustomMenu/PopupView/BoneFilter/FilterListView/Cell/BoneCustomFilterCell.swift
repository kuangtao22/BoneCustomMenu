//
//  BoneCustomFilterCell.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/10.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCustomFilterCell: BoneListsCell {

    var numLabel: UILabel!
    var rowHeight: CGFloat = 45 {
        didSet {
            self.numLabel.center.y = self.rowHeight / 2
        }
    }
    
    var num: Int? {
        didSet {
            if let num = self.num {
                self.numLabel.text = String(num)
                if num > 0 {
                    let color = self.selectColor.withAlphaComponent(0.5)
                    self.numLabel.layer.borderColor = color.cgColor
                    self.numLabel.textColor = color
                } else {
                    let color = self.fontColor.withAlphaComponent(0.5)
                    self.numLabel.layer.borderColor = color.cgColor
                    self.numLabel.textColor = color
                }
            }
        }
    }
 
    convenience init(_ identifier: String, listLeftWidth: CGFloat) {
        self.init(style: .default, reuseIdentifier: identifier)

        self.numLabel = UILabel(frame: CGRect(x: listLeftWidth - 20 - 15, y: 0, width: 20, height: 15))
        self.numLabel.font = UIFont.systemFont(ofSize: 10)
        self.numLabel.textAlignment = NSTextAlignment.center
        self.numLabel.layer.masksToBounds = true
        self.numLabel.layer.cornerRadius = self.numLabel.frame.height / 2
        self.numLabel.layer.borderWidth = 1
        self.contentView.addSubview(self.numLabel)
    }

}
