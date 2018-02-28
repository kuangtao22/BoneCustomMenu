//
//  UIBotton+Extension.swift
//  Hawkeye
//
//  Created by 俞旭涛 on 2016/11/27.
//  Copyright © 2016年 俞旭涛. All rights reserved.
//

import UIKit

extension UIButton {
    
    enum ButtonEdgeInsetsStyle {
        case imageLeft
        case imageRight
        case imageTop
        case imageBottom
    }
    
    func layout(_ style: ButtonEdgeInsetsStyle, spacing: CGFloat) {
        
        var imageFrame = self.imageView?.frame ?? CGRect.zero
        var titleFrame = self.titleLabel?.frame ?? CGRect.zero
        if titleFrame.width == 0 {
            let titleFont = self.titleLabel?.font ?? UIFont.systemFont(ofSize: 15)
            let text = self.titleLabel?.text ?? ""
            titleFrame.width = text.size(attributes: [NSFontAttributeName: titleFont]).width
        }
        
        var imageInsetsTop: CGFloat = 0
        var imageInsetsLeft: CGFloat = 0
        var imageInsetsBottom: CGFloat = 0
        var imageInsetsRight: CGFloat = 0
        
        var titleInsetsTop: CGFloat = 0
        var titleInsetsLeft: CGFloat = 0
        var titleInsetsBottom: CGFloat = 0
        var titleInsetsRight: CGFloat = 0
        
        switch style {
        case .imageRight:
            var space = spacing * 0.5
            if (titleFrame.width + imageFrame.width + spacing) > self.frame.width {
                space = 0
            }
            imageInsetsLeft = titleFrame.width + space
            imageInsetsRight = -imageInsetsLeft
            
            titleInsetsLeft = -(imageFrame.width + space)
            titleInsetsRight = -titleInsetsLeft

        case .imageLeft:
            let spacing = spacing * 0.5;
            
            imageInsetsLeft = -spacing;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = spacing;
            titleInsetsRight = -titleInsetsLeft
            
        case .imageBottom:
            let boundsCentery: CGFloat = (imageFrame.height + spacing + titleFrame.height) * 0.5
            
            imageInsetsTop = self.frame.height - (self.frame.height * 0.5 - boundsCentery) - imageFrame.maxY
            imageInsetsLeft = self.bounds.center.x - imageFrame.center.x
            imageInsetsRight = -imageInsetsLeft
            imageInsetsBottom = -imageInsetsTop
            
            titleInsetsTop = (self.frame.height * 0.5 - boundsCentery) - titleFrame.minY
            titleInsetsLeft = -(titleFrame.center.x - self.bounds.center.x)
            titleInsetsRight = -titleInsetsLeft;
            titleInsetsBottom = -titleInsetsTop;
            
        case .imageTop:
            let boundsCentery = (imageFrame.height + spacing + titleFrame.height) * 0.5
            imageInsetsTop = (self.frame.height * 0.5 - boundsCentery) - imageFrame.minY
            imageInsetsLeft = self.bounds.center.x - imageFrame.center.x
            imageInsetsRight = -imageInsetsLeft
            imageInsetsBottom = -imageInsetsTop
            
            titleInsetsTop = self.frame.height - (self.frame.height * 0.5 - boundsCentery) - titleFrame.maxY
            titleInsetsLeft = -(titleFrame.center.x - self.bounds.center.x)
            titleInsetsRight = -titleInsetsLeft
            titleInsetsBottom = -titleInsetsTop
        }
        
        self.imageEdgeInsets = UIEdgeInsetsMake(imageInsetsTop, imageInsetsLeft, imageInsetsBottom, imageInsetsRight)
        self.titleEdgeInsets = UIEdgeInsetsMake(titleInsetsTop, titleInsetsLeft, titleInsetsBottom, titleInsetsRight)
    }
    
}
