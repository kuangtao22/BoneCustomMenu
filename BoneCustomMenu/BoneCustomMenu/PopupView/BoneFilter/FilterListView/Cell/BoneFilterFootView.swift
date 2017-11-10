//
//  BoneFilterFootView.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/10.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneFilterFootView: UIView {
    
    var fontColor: UIColor? {
        didSet {
            self.cleanBtn.setTitleColor(self.fontColor, for: UIControlState.normal)
        }
    }
    
    var selectColor: UIColor? {
        didSet {
            self.confirmBtn.backgroundColor = self.selectColor
        }
    }
    
    var line: UIColor? {
        didSet {
            self.cleanBtn.layer.borderColor = self.line?.cgColor
        }
    }
    
    typealias touchUpInside = (_ type: Type) -> ()
    var onClick: touchUpInside?
    var cleanBtn: UIButton!     // 清除按钮
    var confirmBtn: UIButton!   // 确认按钮

    convenience init(_ top: CGFloat, width: CGFloat) {
        self.init(frame: CGRect(x: 0, y: top, width: width, height: 45))
        
        self.cleanBtn = self.getFootBtn(left: 0)
        self.cleanBtn.setTitle("清除", for: UIControlState.normal)
        self.cleanBtn.backgroundColor = UIColor.white
        
        self.cleanBtn.layer.borderWidth = 0.5
        self.cleanBtn.addTarget(self, action: #selector(self.cleanAction), for: UIControlEvents.touchUpInside)
        
        self.addSubview(self.cleanBtn)
        
        self.confirmBtn = self.getFootBtn(left: self.frame.width / 2)
        self.confirmBtn.setTitle("确认", for: UIControlState.normal)
        
        self.confirmBtn.addTarget(self, action: #selector(self.confirmAction), for: UIControlEvents.touchUpInside)
        self.addSubview(self.confirmBtn)
    }
    

    
    /// 获取底部按钮样式
    private func getFootBtn(left: CGFloat) -> UIButton {
        let button = UIButton(frame: CGRect(x: left, y: 0, width: self.frame.width / 2, height: self.frame.height))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }
    
    /// 清除事件
    @objc private func cleanAction() {
        let type = Type.clean
        self.onClick?(type)
    }
    
    
    /// 确认事件
    @objc private func confirmAction() {
        let type = Type.confirm
        self.onClick?(type)
    }
    
    enum `Type` {
        case clean
        case confirm
    }
}
