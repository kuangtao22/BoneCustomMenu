//
//  BoneDayCell.swift
//  BoneCalendar
//
//  Created by 俞旭涛 on 2017/10/26.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneDayCell: UICollectionViewCell {
    
    var dayLabel: RoundBackgroundLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.dayLabel = RoundBackgroundLabel(frame: self.bounds)
        
        self.contentView.addSubview(self.dayLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

