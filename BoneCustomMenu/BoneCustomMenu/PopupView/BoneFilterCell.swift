//
//  BoneFilterCell.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/7/15.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

extension BoneFilterCell {
    
    func onClickAction(cellback: @escaping touchUpInside) {
        self.onClick = cellback
    }
}

class BoneFilterCell: UITableViewCell {
    
    typealias Size = BoneCustomPopup.Size
    typealias Color = BoneCustomPopup.Color
    typealias touchUpInside = ([Int]) -> ()
    
    var datas: [Model]? {
        didSet {
            guard let datas = self.datas else {
                return
            }

            for view in self.contentView.subviews {
                view.removeFromSuperview()
            }
            
            guard datas.count > 0 else {
                BoneFilterCell.getHeight = BoneCustomPopup.Size.rowHeight
                return
            }
            
            let width = UIScreen.main.bounds.width / CGFloat(self.col)
            let height = BoneCustomPopup.Size.rowHeight
            for i in 0..<datas.count {
                let x = CGFloat(i % self.col) * width
                let y = CGFloat(i / self.col) * height
                let button = UIButton(frame: CGRect(
                    origin: CGPoint(x: x, y: y),
                    size: CGSize(width: width, height: height))
                )
                button.setTitle(datas[i].title, for: UIControlState.normal)
                button.setTitleColor(Color.font, for: UIControlState.normal)
                button.setTitleColor(UIColor.white, for: UIControlState.selected)
//                button.setImage(datas[i].icon, for: UIControlState.normal)
                button.setImage(BoneCustomPopup.Icon.select?.color(to: UIColor.white), for: UIControlState.selected)
                button.tag = i + 100
                button.titleLabel?.font = UIFont.systemFont(ofSize: Size.font)
                button.layer.borderColor = UIColor.clear.cgColor
                button.layer.borderWidth = 1
                button.addTarget(self, action: #selector(BoneFilterCell.action(button:)), for: UIControlEvents.touchUpInside)
                self.contentView.addSubview(button)
                
                if i == datas.count - 1 {
                    BoneFilterCell.getHeight = button.frame.origin.y + button.frame.height
                }
            }
            
            for i in 0..<Int(BoneFilterCell.getHeight)/Int(height) {
                let rowLine = UIView(frame: CGRect(x: 0, y: CGFloat(i) * height, width: UIScreen.main.bounds.width, height: 0.5))
                rowLine.backgroundColor = BoneCustomPopup.Color.line
                self.contentView.addSubview(rowLine)
            }
            
            if datas.count < 2 {
                let colLine = UIView(
                    frame: CGRect(x: width, y: 0, width: 0.5, height: BoneFilterCell.getHeight)
                )
                colLine.backgroundColor = BoneCustomPopup.Color.line
                self.contentView.addSubview(colLine)
            } else {
                for i in 0..<self.col {
                    let colLine = UIView(
                        frame: CGRect(x: CGFloat(i) * width, y: 0, width: 0.5, height: BoneFilterCell.getHeight)
                    )
                    colLine.backgroundColor = BoneCustomPopup.Color.line
                    self.contentView.addSubview(colLine)
                }
            }
        }
    }
    
    public var type: BoneCustomPopup.FilterType = .only
    
    var selects: [Int]? {
        didSet {
            guard let selects = self.selects else {
                return
            }
            self.selectArray = NSMutableArray(array: selects)
            for i in 0..<(self.datas?.count ?? 0) {
                let button = self.contentView.viewWithTag(i + 100) as? UIButton
                
                for y in selects {
                    if (y + 100) == button?.tag {
                        button?.isSelected = true
                    }
                    self.setButtonState(button)
                }
                
            }
        }
    }
    
    private var col = 3 // 每一列个数
    private var selectArray = NSMutableArray()
    fileprivate var onClick: touchUpInside?
    
    static var getHeight: CGFloat = BoneCustomPopup.Size.rowHeight

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func action(button: UIButton) {
        button.isSelected = !button.isSelected
        
        let row = button.tag - 100
        
        if self.type == .only {
            guard let datas = self.datas else {
                return
            }
            
            for i in 0..<datas.count {
                let btn = self.contentView.viewWithTag(i + 100) as? UIButton
                if button.tag != btn?.tag {
                    btn?.isSelected = false
                }
                self.setButtonState(btn)
            }
            
            self.selectArray = button.isSelected ? [row] : []
            
        } else {
            self.setButtonState(button)
            
            if button.isSelected {
                self.selectArray.add(row)
            } else {
                self.selectArray.remove(row)
            }
        }
        
        var items: [Int] = [Int]()
        for id in self.selectArray {
            items.append(id as! Int)
        }

        self.onClick?(items)
    }
    
    private func setButtonState(_ button: UIButton?) {
        if button?.isSelected == true {
            button?.backgroundColor = Color.fontSelect.withAlphaComponent(0.7)
        } else {
            button?.backgroundColor = UIColor.white
        }
    }
}


extension BoneFilterCell {
    
    struct Model {
        var icon: String?
        var title: String
    }
}
