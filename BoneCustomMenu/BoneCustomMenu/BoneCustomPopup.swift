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
    
    var isShow: Bool {
        get {
            return self.show
        }
        set {
            self.show = newValue
            self.popupAction(newValue)
        }
    }
    
    /// 格式
    struct IndexPath {
        var column: Int     // 一级列
        var section: Int    // 区
        var row: Int        // 行
    }
    
    /// 主菜单信息(名称/类型)
    struct ColumnInfo {
        var title: String
        var type: ColumnType
    }
    
    /// 主菜单触发类型
    enum ColumnType {
        case button         // 直接触发
        case list           // 列表菜单
        case filter         // 筛选菜单
    }
    
    /// 筛选类型
    enum FilterType {
        case only   // 单选
        case multi  // 多选
    }
    
    struct Color {
        /// 字体颜色
        static var font = UIColor(colorLiteralRed: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        
        static var fontSelect = UIColor(colorLiteralRed: 0/255, green: 139/255, blue: 254/255, alpha: 1)
        /// 一级分类底色
        static var section = UIColor(colorLiteralRed: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        /// 分割线颜色
        static var line = UIColor(colorLiteralRed: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    }
    
    struct Size {
        /// 行高
        static var rowHeight: CGFloat = 45
        /// list类型左边宽度
        static var listLeftWidth: CGFloat = UIScreen.main.bounds.width * 0.3
        /// 弹出框高度
        static var menuHeight: CGFloat = 300
        
        static var font: CGFloat = 14
    }
    
    struct Icon {
        static var select = UIImage(named: "BoneCustomIcon.bundle/select")?.color(to: Color.fontSelect)
    }
}

class BoneCustomPopup: UIView {
    
    var popupDelegate: BoneCustomPopupDelegate?
    
    
    
    private var screen_width = UIScreen.main.bounds.width
    private var screen_height = UIScreen.main.bounds.height
    
    fileprivate var show: Bool = false  // 是否显示
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var popupView: UIView = {
        let view = UIView(frame: CGRect(
            origin: CGPoint(x: 0, y: -self.menuView.frame.height),
            size: self.menuView.bounds.size)
        )
        view.backgroundColor = UIColor.white
        view.isHidden = !self.show
        return view
    }()
    
    /// 背景
    fileprivate lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: CGRect(
            origin: self.frame.origin,
            size: CGSize(
                width: self.frame.width,
                height: UIScreen.main.bounds.height - self.frame.origin.x
            )
        ))
        
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        backgroundView.alpha = 0
        backgroundView.isOpaque = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(BoneCustomPopup.backgroundTapped(sender:)))
        backgroundView.addGestureRecognizer(gesture)
        return backgroundView
    }()
    
    lazy var menuView: UIView = {
        let view = UIView(frame: CGRect(
            x: self.frame.origin.x, y: self.frame.origin.y + self.frame.height,
            width: self.bounds.width,
            height: Size.menuHeight)
        )
        view.layer.masksToBounds = true
        return view
    }()
    
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        self.isShow = false
    }
    
    /// 显示/隐藏动画
    ///
    /// - Parameter isShow: 是否显示
    fileprivate func popupAction(_ isShow: Bool) {
        self.popupView.isHidden = !isShow
        if isShow {
            self.superview?.addSubview(self.backgroundView)
            self.superview?.addSubview(self.menuView)
            self.menuView.addSubview(self.popupView)
            self.backgroundView.superview?.addSubview(self)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundView.alpha = 1
                self.popupView.transform = CGAffineTransform(translationX: 0, y: self.popupView.frame.height)
                
            }, completion: { (finished) in
                self.popupDelegate?.customPopup(isShow)
            })
            
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundView.alpha = 0
                self.popupView.transform = CGAffineTransform.identity
                
            }, completion: { (finished) in
                self.backgroundView.removeFromSuperview()
                self.popupView.removeFromSuperview()
                self.menuView.removeFromSuperview()

                self.popupDelegate?.customPopup(isShow)
            })
        }
    }
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
                if self.isSelected == true {
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
        
        private var type: ColumnType = .button
        
        typealias touchUpInside = (_ type: ColumnType, _ button: ColumnBtn) -> ()
        private var onClick: touchUpInside?
        
        convenience init(frame: CGRect, type: ColumnType) {
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
                let image = UIImage(named: "BoneCustomIcon.bundle/filter")?.color(to: color)
                return image
            case .list:
                let image = UIImage(named: "BoneCustomIcon.bundle/pointer")?.color(to: color)
                return image
            }
        }
    }
}
