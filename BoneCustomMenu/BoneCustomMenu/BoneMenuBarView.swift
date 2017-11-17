//
//  BoneMenuBarView.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/16.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneMenuBarDelegate {
    
    /// 获取总数量
    func getCount() -> Int
    
    func getTitle(_ index: Int) -> String
    
    func onClick(_ index: Int)
    
    func clean()
    
    func getSelectIndexPath(_ index: Int) -> BoneMenuIndexPath
    
    func state(_ barView: BoneMenuBarView)
}

class BoneMenuBarView: UIView {
    
    var delegate: BoneMenuBarDelegate?
    
    var isShow: Bool {
        get { return !self.isHidden }
        set {
            if (self.delegate?.getCount() ?? 0) > 0 {
                self.isHidden = newValue
            } else {
                self.isHidden = true
            }
        }
    }
    
    /// 默认高度
    private var defaultHeight: CGFloat = 45
    
    /// 清空按钮
    fileprivate var cleanButton: UIButton!
    
    fileprivate var scrollView: UIScrollView!
    
    convenience init(_ top: CGFloat) {
        self.init(frame: CGRect(x: 0, y: top, width: UIScreen.main.bounds.width, height: 0))
        self.frame.size.height = self.defaultHeight
        self.isHidden = true
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width - 80, height: self.frame.height))
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.alwaysBounceHorizontal = true
        self.addSubview(self.scrollView)
        
        let rightView = UIView(frame: CGRect(x: self.scrollView.frame.width, y: 0, width: self.frame.width - self.scrollView.frame.width, height: self.frame.height))
        self.addSubview(rightView)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: 0.5, height: rightView.frame.height))
        lineView.backgroundColor = UIColor.black.withAlphaComponent(0.09)
        rightView.addSubview(lineView)
        
        let cleanSize = CGSize(width: rightView.frame.width - 20, height: rightView.frame.height - 15)
        self.cleanButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: cleanSize))
        self.cleanButton.frame.origin.x = 10
        self.cleanButton.center.y = rightView.center.y
        self.cleanButton.setTitle("清空", for: UIControlState.normal)
        self.cleanButton.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: UIControlState.normal)
        self.cleanButton.addTarget(self, action: #selector(self.cleanAction), for: .touchUpInside)
        self.cleanButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.cleanButton.layer.masksToBounds = true
        self.cleanButton.layer.cornerRadius = 2
        self.cleanButton.layer.borderWidth = 0.5
        self.cleanButton.layer.borderColor = self.cleanButton.titleLabel?.textColor.cgColor
        rightView.addSubview(self.cleanButton)
    }
    
    @objc func cleanAction() {
        self.delegate?.clean()
    }
    
    @objc func delAction(button: UIButton) {
        self.delegate?.onClick(button.tag - 100)
    }
    
    func reloadData() {
        guard let delegate = self.delegate else {
            self.isHidden = true
            return
        }
        guard delegate.getCount() > 0 else {
            self.isHidden = true
            delegate.state(self)
            return
        }
        self.isHidden = false
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        
        var leftBtn: CGFloat = 10
        for i in 0..<delegate.getCount() {
            
            let button = ItemButton(delegate.getTitle(i), height: self.cleanButton.frame.height)
            button.delBtn.tag = i + 100
            button.delBtn.addTarget(self, action: #selector(self.delAction(button:)), for: UIControlEvents.touchUpInside)
            self.scrollView.addSubview(button)
            
            button.frame.origin.x = leftBtn
            button.center.y = self.scrollView.center.y
            leftBtn += button.frame.width + 5

            if i == delegate.getCount() - 1 {
                self.scrollView.contentSize.width = button.frame.origin.x + button.frame.width + 10
            }
        }
        delegate.state(self)
    }
}


extension BoneMenuBarView {
    
    class ItemButton: UIView {
        
        var delBtn: UIButton!
        private var textLabel: UILabel!
        
        private var font = UIFont.systemFont(ofSize: 12)
        
        convenience init(_ text: String, height: CGFloat) {
            self.init(frame: CGRect.zero)
            self.backgroundColor = UIColor.white
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 2
            self.layer.borderColor = UIColor.black.withAlphaComponent(0.07).cgColor
            self.layer.borderWidth = 0.5

            let textWidth = ItemButton.getTextWidth(text: text, font: self.font, height: height) + 10

            self.textLabel = UILabel(frame: CGRect(x: 5, y: 0, width: textWidth, height: height))
            self.textLabel.font = self.font
            self.textLabel.textColor = UIColor.gray
            self.textLabel.textAlignment = NSTextAlignment.center
            self.textLabel.text = text
            self.addSubview(self.textLabel)
            
            self.delBtn = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: height)))
            self.delBtn.frame.origin.x = self.textLabel.frame.maxX
            self.delBtn.setImage(UIImage(named: "BoneCustomIcon.bundle/del"), for: UIControlState.normal)
            self.addSubview(self.delBtn)
            
            self.frame.size = CGSize(width: self.delBtn.frame.maxX + 5, height: height)

        }
        
        class func getTextWidth(text: String,font: UIFont, height: CGFloat) -> CGFloat {
            let size = CGSize(width: 1000, height: height)
            let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
            let stringSize = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
            return stringSize.width
        }
    }
}
