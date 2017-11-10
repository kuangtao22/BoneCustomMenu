//
//  BoneCustomListsDelegate.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/11.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneCustomDelegate: NSObjectProtocol {
    
    func numberOfSection() -> Int
    
    func customList(numberOfRowsInSections section: Int) -> Int
    
    func customList(titleInSection section: Int) -> String
    
    func customList(titleForSectionInRow section: Int, row: Int) -> String
    
    func customList(didSelectRowAt section: Int, row: Int)
    
    func getSelectData() -> BoneCustomListsView.SelectData
    
    func isRight() -> Bool
    
    func customList(filterDidForSectionAt section: Int) -> BoneCustomPopup.FilterType
    
    func customList(didSelect filterDatas: [[Int]], isConfirm: Bool)
    
    func customFilter() -> [[Int]]
}
