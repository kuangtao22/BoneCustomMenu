//
//  BoneCalenadrDelegate.swift
//  BoneCalendar
//
//  Created by 俞旭涛 on 2017/10/26.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneCalenadrDelegate {
    
    /// 点击日历
    func calenadr(_ calenadrView: BoneCalendarView, didSelect dates: [Date], error: String?)
    
    
    /// 点击底部确认按钮
    func calenadr(_ calenadrView: BoneCalendarView, confirm dates: [Date])
}
