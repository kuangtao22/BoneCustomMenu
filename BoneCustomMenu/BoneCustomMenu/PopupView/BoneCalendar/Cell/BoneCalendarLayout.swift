//
//  BoneCalendarLayout.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/10/25.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCalendarLayout: UICollectionViewFlowLayout {
    
    let colNum: CGFloat = 7
    let spacing: CGFloat = 5
    var width: CGFloat = UIScreen.main.bounds.width
    var cellSize: CGFloat = 0
    
    convenience init(_ width: CGFloat) {
        self.init()
        self.width = width
        self.setupLayout()
    }

    var leftOffset: CGFloat {
        get {
            let width = (self.width) - self.spacing * 2
            let offset = (width - self.cellSize * 7) + self.spacing * 2
            return round(offset / 2)
        }
    }
    
    var rightOffset: CGFloat {
        get {
            let width = (self.width) - self.spacing * 2
            let offset = (width - self.cellSize * 7) + self.spacing * 2
            return round(offset - self.leftOffset)
        }
    }
    
    //设置cell的大小
    func setupLayout(){
        self.minimumLineSpacing = 5 // 每行之间竖直之间的最小间距（可以大于）
        self.minimumInteritemSpacing = 0

        let width = (self.width) - self.spacing * 2
        
        self.cellSize = round(round(width - (self.colNum - 1) * self.minimumLineSpacing) / self.colNum)
        
        // 设置大小
        self.itemSize = CGSize(width: self.cellSize, height: self.cellSize)
        self.scrollDirection = .vertical    // 竖向滑动
        
        self.collectionView?.contentInset.left = self.leftOffset
        self.collectionView?.contentInset.right = self.rightOffset
    }
}

