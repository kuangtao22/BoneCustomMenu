//
//  BoneCalendarTimePicker.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2018/1/10.
//  Copyright © 2018年 鱼骨头. All rights reserved.
//

import UIKit

extension BoneCalendarTimePicker {
    
    func selectTimeAction(_ callback: @escaping valueChanged) {
        self.onClick = callback
    }
    
    /// 默认时间
    func clean() {
        self.timeData = TimeMode(start: TimeMode.Mode(hour: 00, minute: 00), end: TimeMode.Mode(hour: 23, minute: 59))
    }
    
    /// 回到当前时间
    func today() {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.hour,.minute], from: Date())
        self.timeData.start.hour = dateComponents.hour ?? 0
        self.timeData.start.minute = dateComponents.minute ?? 0
    }
}

class BoneCalendarTimePicker: UIView {
    
    /// 开始时间
    var startDate: Date {
        get {
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.hour,.minute], from: Date())
            dateComponents.hour = self.timeData.start.hour
            dateComponents.minute = self.timeData.start.minute
            return calendar.date(from: dateComponents) ?? Date()
        }
    }
    
    
    /// 结束时间
    var endDate: Date {
        get {
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.hour,.minute], from: Date())
            dateComponents.hour = self.timeData.end.hour
            dateComponents.minute = self.timeData.end.minute
            return calendar.date(from: dateComponents) ?? Date()
        }
    }
    
    typealias TimeMode = BoneCalenadrDataSource.TimeMode
    typealias valueChanged = (_ timeData: TimeMode) -> Void

    fileprivate var startPicker: UIDatePicker!

    fileprivate var endPicker: UIDatePicker!
    fileprivate var onClick: valueChanged?
    
    var setHeight: CGFloat? {
        didSet {
            guard let height = self.setHeight else {
                return
            }
            self.frame.size.height = height
            self.startPicker.frame.size.height = self.frame.height - startTitle.frame.maxY
            self.endPicker.frame.size.height = self.startPicker.frame.height
        }
    }
    
    fileprivate var startTitle: UILabel!
    fileprivate var endTitle: UILabel!
    
    var timeData: TimeMode! {
        didSet {
            self.startPicker.setDate(self.startDate, animated: true)
            self.endPicker.setDate(self.endDate, animated: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white


        self.startTitle = self.getTitle(CGPoint(x: 0, y: 15), text: "开始时间")
        self.addSubview(startTitle)
        
        let pickerWidth = (self.frame.width - 15 * 3) / 2
        self.startPicker = UIDatePicker(frame: CGRect(x: 15, y: startTitle.frame.maxY, width: pickerWidth, height: self.frame.height - startTitle.frame.maxY))
        self.startPicker.addTarget(self, action: #selector(self.selectTime(picker:)), for:UIControlEvents.valueChanged)
        self.startPicker.datePickerMode = .time
        self.addSubview(self.startPicker)
        
        let endTitle = self.getTitle(CGPoint(x: startTitle.frame.maxX, y: startTitle.frame.minY), text: "结束时间")
        self.addSubview(endTitle)
        
        self.endPicker = UIDatePicker(frame: CGRect(x: 15 + self.startPicker.frame.maxX, y: self.startPicker.frame.minY, width: pickerWidth, height: self.startPicker.frame.height))
        self.endPicker.datePickerMode = .time
        self.endPicker.addTarget(self, action: #selector(self.selectTime(picker:)), for:UIControlEvents.valueChanged)
        self.addSubview(self.endPicker)
    }

    @objc private func selectTime(picker: UIDatePicker) {
        let dateComponents = picker.calendar.dateComponents([.hour,.minute], from: picker.date)
        if picker == self.startPicker {
            self.timeData.start.hour = dateComponents.hour ?? 00
            self.timeData.start.minute = dateComponents.minute ?? 00
        } else {
            self.timeData.end.hour = dateComponents.hour ?? 00
            self.timeData.end.minute = dateComponents.minute ?? 00
        }
        self.onClick?(self.timeData)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getTitle(_ origin: CGPoint, text: String) -> UILabel {
        let label = UILabel(frame: CGRect(origin: origin, size: CGSize(width: self.frame.width / 2, height: 20)))
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        label.textAlignment = NSTextAlignment.center
        label.text = text
        return label
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        BoneCustomPopup.Color.line.setStroke()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.center.x, y: self.startPicker.frame.minY))
        path.addLine(to: CGPoint(x: self.center.x, y: rect.maxY))
        path.close()
        path.stroke()
    }
 
}
