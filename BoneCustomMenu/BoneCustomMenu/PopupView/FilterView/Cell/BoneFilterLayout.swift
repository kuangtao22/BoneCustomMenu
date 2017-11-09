//
//  BoneFilterLayout.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/8.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneFilterLayout: UICollectionViewFlowLayout {

    private let colNum: CGFloat = 3
    private let spacing: CGFloat = 0
    private var width: CGFloat = UIScreen.main.bounds.width
    private var rowHeight: CGFloat = 45
    
    override init() {
        super.init()
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置cell的大小
    func setupLayout(){
        self.minimumLineSpacing = 0 // 每行之间竖直之间的最小间距（可以大于）
        self.minimumInteritemSpacing = 0
        
        let rowWidth = self.width / self.colNum

        // 设置大小
        self.itemSize = CGSize(width: rowWidth, height: self.rowHeight)
        self.scrollDirection = .vertical    // 竖向滑动
    }
}
