//
//  BoneListsCell.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/12.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneListsCell: UITableViewCell {
    
    var openNum: Bool = false

    fileprivate var isLeft = true
    fileprivate var isSelect = true
    
    /// 设置cell样式
    ///
    /// - Parameters:
    ///   - isLeft: 是否是左边表格
    ///   - isSelect: 是否选中
    ///   - isTwo: 是否显示两列表格
    func set(isLeft: Bool, isSelect: Bool, isTwo: Bool) {
        self.isLeft = isLeft
        self.isSelect = isSelect
        self.textLabel?.textColor = isSelect ? Color.select : Color.font
        if isLeft {
            self.numLabel.textColor = self.textLabel?.textColor.withAlphaComponent(0.5)
            self.numLabel.layer.borderColor = self.numLabel.textColor.cgColor
            self.backgroundColor = isLeft ? Color.section : UIColor.white
            self.accessoryView = self.openNum ? self.numLabel : nil
            self.selectView1.isHidden = !isSelect
            self.backgroundColor = isSelect ? UIColor.white : Color.section
        } else {
            self.selectView2.isHidden = !isSelect
            self.accessoryView = self.selectView2
            self.selectView1.isHidden = isTwo ? true : !isSelect
        }
    }
    
    /// 数量
    var num: Int? {
        didSet {
            self.numLabel.text = String(self.num ?? 0)
        }
    }

    typealias Size = BoneCustomPopup.Size
    typealias Color = BoneCustomPopup.Color

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = UITableViewCellAccessoryType.none
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.textLabel?.textColor = Color.font
        self.textLabel?.numberOfLines = 2
        self.textLabel?.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(self.selectView1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 左边选中样式
    lazy var selectView1: UIView = {
        let selectView1 = UIView(frame: CGRect(
            origin: CGPoint(x: 0, y: 12),
            size: CGSize(width: 4, height: Size.rowHeight - 24))
        )
        selectView1.isHidden = true
        selectView1.backgroundColor = Color.select
        return selectView1
    }()
    
    
    /// 右边选中样式
    lazy var selectView2: UIImageView = {
        let selectView2 = UIImageView(image: UIImage(named: "BoneCustomIcon.bundle/select")?.color(Color.select))
        selectView2.isHidden = true
        return selectView2
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        numLabel.center.y = BoneCustomPopup.Size.rowHeight / 2
        numLabel.font = UIFont.systemFont(ofSize: 10)
        numLabel.textAlignment = NSTextAlignment.center
        numLabel.layer.masksToBounds = true
        numLabel.layer.cornerRadius = numLabel.frame.height / 2
        numLabel.layer.borderWidth = 1
        return numLabel
    }()
    

    override func draw(_ rect: CGRect) {
        if self.isLeft {
            Color.line.setStroke()
            if self.isSelect {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.close()
                path.stroke()
            } else {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.close()
                path.stroke()
            }
        }
        super.draw(rect)
    }
}
