//
//  BoneCustomView.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/7.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneCustomPopupDelegate {
    
    func customPopup(_ isShow: Bool)
}

extension BoneCustomPopup {
    
//    var isShow: Bool {
//        get {
//            return self.show
//        }
//    }
    
    
    
    
//    struct Color {
//        /// 字体颜色
//        static var font = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
//        
////        static var fontSelect = UIColor(red: 0/255, green: 139/255, blue: 254/255, alpha: 1)
//        /// 一级分类底色
//        static var section = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
//        /// 分割线颜色
//        static var line = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
//    }
    
    struct Size {
        /// 行高
        static var rowHeight: CGFloat = 45
        /// list类型左边宽度
        static var listLeftWidth: CGFloat = UIScreen.main.bounds.width * 0.3
        static var font: CGFloat = 14
    }
    
//    struct Icon {
//        static var select = UIImage(named: "BoneCustomIcon.bundle/select")?.color(Color.fontSelect)
//    }
}

class BoneCustomPopup: UIView {
    
    var popupDelegate: BoneCustomPopupDelegate?

    private var screen_width = UIScreen.main.bounds.width
    private var screen_height = UIScreen.main.bounds.height
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 背景
     lazy var backgroundView: UIView = {
        let origin = CGPoint(x: 0, y: self.frame.origin.y + self.frame.height)
        let size = CGSize(width: self.frame.width, height: UIScreen.main.bounds.height - self.frame.origin.y)
        let backgroundView = UIView(frame: CGRect(origin: origin, size: size))
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        backgroundView.alpha = 0
        backgroundView.isOpaque = false
        return backgroundView
    }()
    
    lazy var menuView: UIView = {
        let view = UIView(frame: self.backgroundView.bounds)
        view.frame.origin.y = self.frame.origin.y + self.frame.height
        view.layer.masksToBounds = true
        return view
    }()
}



extension BoneCustomPopup {

    class ColumnBtn: UIButton {
        
        var normalColor: UIColor? {
            didSet {
                self.setTitleColor(self.normalColor, for: UIControlState.normal)
                self.setImage(self.getIcon(self.normalColor), for: UIControlState.normal)
            }
        }
        
        var selectColor: UIColor? {
            didSet {
                self.setTitleColor(self.selectColor, for: UIControlState.selected)
                self.setImage(self.getIcon(self.selectColor), for: UIControlState.selected)
            }
        }
        
        var title: String? {
            didSet {
                self.setTitle(self.title, for: UIControlState.normal)
                if self.type != .button {
                    
                    guard let font = self.titleLabel?.font else {
                        return
                    }
                    let titleWidth = BoneTools.shared.getTextWidth(text: self.title ?? "", font: font, height: self.frame.height)
                    self.titleEdgeInsets.left = -(self.imageView?.frame.width ?? 0) * 2 - 5
                    self.imageEdgeInsets.right = -titleWidth * 2 - 5
                }
            }
        }
        
        override var isSelected: Bool {
            didSet {
                if self.isSelected {
                    self.titleLabel?.font = UIFont.boldSystemFont(ofSize: Size.font)
                } else {
                    self.titleLabel?.font = UIFont.systemFont(ofSize: Size.font)
                }
                if self.type == .list {
                    self.animateAction(self.isSelected)
                }
            }
        }
        
        func onClickAction(cellback: @escaping touchUpInside) {
            self.onClick = cellback
        }
        
        private var type: BoneCustomMenuSource.ColumnType = .button
        
        typealias touchUpInside = (_ type: BoneCustomMenuSource.ColumnType, _ button: ColumnBtn) -> ()
        private var onClick: touchUpInside?
        
        convenience init(frame: CGRect, type: BoneCustomMenuSource.ColumnType) {
            self.init(frame: frame)
            self.type = type
            self.titleLabel?.font = UIFont.systemFont(ofSize: Size.font)
            self.addTarget(self, action: #selector(ColumnBtn.action(button:)), for: UIControlEvents.touchUpInside)
        }
        
        @objc fileprivate func action(button: ColumnBtn) {
            self.onClick?(self.type, button)
        }
        
        /// 箭头图片旋转动画180°
        @objc fileprivate func animateAction(_ isSelected: Bool) {
            guard let imageView = self.imageView else {
                return
            }
            UIView.animate(withDuration: 0.2) { () -> Void in
                if isSelected {
                    imageView.transform = imageView.transform.rotated(by: CGFloat.pi)
                } else {
                    imageView.transform = CGAffineTransform.identity
                }
            }
        }
        
        /// 获取图标
        private func getIcon(_ color: UIColor?) -> UIImage? {
            guard let color = color else { return nil }
            switch self.type {
            case .button:
                return nil
            case .filter:
                let image = UIImage(named: "BoneCustomIcon.bundle/filter")?.color(color)
                return image
            case .list, .filterList:
                let image = UIImage(named: "BoneCustomIcon.bundle/pointer")?.color(color)
                return image
            case .calendar:
                let image = UIImage(named: "BoneCustomIcon.bundle/pointer")?.color(color)
                return image
            }
        }
    }
}
