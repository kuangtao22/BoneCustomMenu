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
    override var text: String? {
        didSet {
            self.selectView.text = self.text
        }
    }
    
//    override var textColor: UIColor! {
//        didSet {
//            self.selectView.textColor = self.textColor
//        }
//    }
    
    fileprivate var selectView: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.numberOfLines = 1
        self.textAlignment = NSTextAlignment.center
        self.font = UIFont.systemFont(ofSize: 15)
        
        let selectSize = CGSize(width: self.frame.width * 0.8, height: self.frame.height * 0.8)
        self.selectView = UILabel(frame: CGRect(origin: CGPoint.zero, size: selectSize))
        self.selectView.center = self.center
        self.selectView.textAlignment = self.textAlignment
        self.selectView.numberOfLines = self.numberOfLines
        self.selectView.font = self.font
        self.selectView.textColor = UIColor.white
        self.selectView.layer.masksToBounds = true
        self.selectView.layer.cornerRadius = self.selectView.frame.height / 2
        
        self.addSubview(self.selectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        self.selectView.backgroundColor = self.backRoundColor
        self.selectView.isHidden = true
        
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
            self.selectView.isHidden = false
            context?.addEllipse(in: newRect)
            backRoundColor.withAlphaComponent(0.1).set()
            context?.drawPath(using: CGPathDrawingMode.fill)
            
        case .middle:
            context?.addRect(newRect)
            backRoundColor.withAlphaComponent(0.1).set()
            context?.drawPath(using: CGPathDrawingMode.fill)
            
        case .start:
            self.selectView.isHidden = false
            context?.addArc(center: CGPoint(x: newRect.width/2,y: newRect.height/2), radius: newRect.width/2, startAngle: .pi/2, endAngle: .pi/2*3, clockwise: false)
            context?.addRect(CGRect(x: newRect.width/2, y: 0, width: newRect.width/2, height: newRect.height))
            backRoundColor.withAlphaComponent(0.1).set()
            context?.drawPath(using: CGPathDrawingMode.fill)
            
        case.end:
            self.selectView.isHidden = false
            context?.addArc(center: CGPoint(x: newRect.width/2,y: newRect.height/2), radius: newRect.width/2, startAngle: -.pi/2, endAngle: .pi/2, clockwise: false)
            context?.addRect(CGRect(x: 0, y: 0, width: newRect.width/2, height: newRect.height))
            backRoundColor.withAlphaComponent(0.1).set()
            context?.drawPath(using: CGPathDrawingMode.fill)
            
        case .none:
            break
        }
        super.draw(newRect)
    }
}

