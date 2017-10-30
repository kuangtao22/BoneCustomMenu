//
//  RoundBackgroundLabel.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/10/26.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class RoundBackgroundLabel: UILabel {

    typealias RoundType = BoneCalenadrDataSource.RoundType
    
    var backRoundColor: UIColor = UIColor.lightGray
    var roundType: RoundType = .single
        
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        var newRect = rect
        if rect.origin.x < 0 {
            newRect.origin.x = 0
            let width = rect.origin.x * 2 + rect.size.width
            newRect.size.width = CGFloat(Int(width))
        }
        if rect.origin.y < 0 {
            newRect.origin.y = 0
            newRect.size.height = newRect.size.width
        }

        switch roundType {
        case .single:
            context?.addEllipse(in: newRect)
            backRoundColor.set()
            context?.drawPath(using: CGPathDrawingMode.fill)
            
        case .middle:
            
            context?.addRect(newRect)
            backRoundColor.set()
            context?.drawPath(using: CGPathDrawingMode.fill)
            
        case .start:
            context?.addArc(center: CGPoint(x: newRect.width/2,y: newRect.height/2), radius: newRect.width/2, startAngle: .pi/2, endAngle: .pi/2*3, clockwise: false)
            
            context?.addRect(CGRect(x: newRect.width/2, y: 0, width: newRect.width/2, height: newRect.height))
            backRoundColor.set()
            context?.drawPath(using: CGPathDrawingMode.fillStroke)
            
        case.end:
            context?.addArc(center: CGPoint(x:newRect.width/2,y:newRect.height/2), radius: newRect.width/2, startAngle: -.pi/2, endAngle: .pi/2, clockwise: false)
            context?.addRect(CGRect(x: 0, y: 0, width: newRect.width/2, height: newRect.height))
            backRoundColor.set()
            context?.drawPath(using: CGPathDrawingMode.fill)
            
        case .none:
            break
        }
        super.draw(newRect)
    }
}
