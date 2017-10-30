//
//  BoneCalenadrReusableView.swift
//  BoneCalendar
//
//  Created by 俞旭涛 on 2017/10/26.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCalenadrReusableView: UICollectionReusableView {
    
    var label: UILabel!
    let weekArray = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height * 0.7))
        self.label.font = UIFont.boldSystemFont(ofSize: 18)
        self.label.textColor = UIColor.black
        self.label.textAlignment = NSTextAlignment.center
        self.addSubview(self.label)
        
        let weekWidth = self.frame.size.width / CGFloat(self.weekArray.count)
        let weekHeight = self.frame.size.height - self.label.frame.height
        let weekTop = self.label.frame.origin.y + self.label.frame.height
        
        for i in 0..<self.weekArray.count {
            let weekLabel = UILabel(frame: CGRect(x: CGFloat(i) * weekWidth, y: weekTop, width: weekWidth, height: weekHeight))
            weekLabel.font = UIFont.boldSystemFont(ofSize: 13)
            weekLabel.textAlignment = NSTextAlignment.center
            weekLabel.textColor = UIColor.gray
            weekLabel.text = self.weekArray[i]
            self.addSubview(weekLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
