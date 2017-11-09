//
//  BoneCustomListsDelegate.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/11.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneCustomDelegate: NSObjectProtocol {
    
    func numberOfSection(_ view: UIView) -> Int
    
    func customList(_ view: UIView, numberOfRowsInSections section: Int) -> Int
    
    func customList(_ view: UIView, titleInSection section: Int) -> String
    
    func customList(_ view: UIView, titleForSectionInRow section: Int, row: Int) -> String
    
    func customList(_ view: UIView, didSelectRowAt section: Int, row: Int)
    
    func customList(currentSelectRowAt view: UIView) -> BoneCustomListsView.SelectData
    
    func isRight() -> Bool
    
    func customList(_ view: UIView,  filterDidForSectionAt section: Int) -> BoneCustomPopup.FilterType
    
    func customList(_ view: UIView, didSelect filterDatas: [[Int]], isConfirm: Bool)
    
    func customFilter(_ view: UIView) -> [[Int]]
}
