//
//  BoneFilterReusableView.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/8.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneFilterReusableView: UICollectionReusableView {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.label = UILabel(frame: CGRect(x: 15, y: 0, width: self.frame.width - 30, height: self.frame.height))
        self.label.font = UIFont.systemFont(ofSize: 12)
        self.label.textColor = UIColor.lightGray
        self.addSubview(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
