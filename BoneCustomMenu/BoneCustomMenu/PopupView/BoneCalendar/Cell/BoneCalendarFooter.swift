//
//  BoneCalendarFooter.swift
//  BoneCalendar
//
//  Created by 俞旭涛 on 2017/10/26.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

extension BoneCalendarFooter {
    
    func onClickAction(_ cellbeck: @escaping OnClick) {
        self.onclick = cellbeck
    }
}

class BoneCalendarFooter: UIView {

    fileprivate var calendarArray = ["清除", "回到今日", "确定"]
    fileprivate var timeArray = ["默认时间", "当前时间", "确定"]
    
    typealias OnClick = (_ type: BoneCalenadrDataSource.ButtonType) -> ()
    fileprivate var onclick: OnClick?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        
        let width: CGFloat = self.frame.width / CGFloat(self.calendarArray.count)
        for i in 0..<self.calendarArray.count {
            let origin = CGPoint(x: CGFloat(i) * width, y: 0)
            let btn = UIButton(frame: CGRect(origin: origin, size: CGSize(width: width, height: self.frame.height)))
            btn.setTitle(self.calendarArray[i], for: UIControlState.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.tag = i
            if i == self.calendarArray.count - 1 {
                btn.setTitleColor(UIColor.white, for: UIControlState.normal)
                btn.backgroundColor = BoneCustomPopup.Color.select
            } else {
                btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            btn.addTarget(self, action: #selector(self.action(button:)), for: UIControlEvents.touchUpInside)
            self.addSubview(btn)
        }
    }
    
    @objc private func action(button: UIButton) {
        if let type = BoneCalenadrDataSource.ButtonType(rawValue: button.tag) {
            self.onclick?(type)
        }
    }
    
    func reloadData(isSelect: Bool) {
        for i in 0..<self.subviews.count {
            if let btn = self.subviews[i] as? UIButton {
                if isSelect {
                    btn.setTitle(self.timeArray[i], for: UIControlState.normal)
                } else {
                    btn.setTitle(self.calendarArray[i], for: UIControlState.normal)
                }
                if btn.tag == self.calendarArray.count - 1 {
                    btn.backgroundColor = BoneCustomPopup.Color.select
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        BoneCustomPopup.Color.line.setStroke()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.close()
        path.stroke()
        super.draw(rect)
    }
}

