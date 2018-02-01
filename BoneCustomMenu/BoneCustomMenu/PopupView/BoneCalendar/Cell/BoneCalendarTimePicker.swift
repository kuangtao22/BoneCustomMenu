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
        self.timeData = TimeMode(start: HMSMode(hour: 00, minute: 00, second: 00), end: HMSMode(hour: 23, minute: 59, second: 59))
        self.onClick?(self.timeData)
    }
    
    /// 回到当前时间
    func today() {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.hour,.minute,.second], from: Date())
        self.timeData.start.hour = dateComponents.hour ?? 0
        self.timeData.start.minute = dateComponents.minute ?? 0
        self.timeData.start.second = dateComponents.second ?? 0
        self.timeData.end.hour = dateComponents.hour ?? 0
        self.timeData.end.minute = dateComponents.minute ?? 0
        self.timeData.end.second = dateComponents.second ?? 0
        self.onClick?(self.timeData)
    }
}

class BoneCalendarTimePicker: UIView {
    
    typealias TimeMode = BoneCalenadrDataSource.TimeMode
    typealias HMSMode = BoneCalendarTimePicker.HMSTimePicker.Mode
    typealias valueChanged = (_ timeData: TimeMode) -> Void

    fileprivate var startPicker: HMSTimePicker!
    fileprivate var endPicker: HMSTimePicker!
    fileprivate var onClick: valueChanged?
    
    var setHeight: CGFloat? {
        didSet {
            guard let height = self.setHeight else {
                return
            }
            self.frame.size.height = height
            self.startPicker.frame.size.height = height - self.startTitle.frame.maxY
            self.endPicker.frame.size.height = self.startPicker.frame.height
            self.startPicker.center.y = (height - self.startTitle.frame.maxY) / 2 + self.startTitle.frame.maxY
            self.endPicker.center.y = self.startPicker.center.y
        }
    }
    
    fileprivate var startTitle: UILabel!
    fileprivate var endTitle: UILabel!
    
    var timeData: TimeMode! {
        didSet {
            self.startPicker.selectRow(self.timeData.start, animated: true)
            self.endPicker.selectRow(self.timeData.end, animated: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        self.startTitle = self.getTitle(CGPoint(x: 0, y: 15), text: "开始时间")
        self.addSubview(startTitle)
        
        self.startPicker = HMSTimePicker(frame: CGRect(x: 0, y: startTitle.frame.maxY, width: self.frame.width / 2, height: self.frame.height - startTitle.frame.maxY))
        self.startPicker.selectTime = { time in
            self.timeData.start = time
            self.onClick?(self.timeData)
        }
        self.addSubview(self.startPicker)

        let endTitle = self.getTitle(CGPoint(x: startTitle.frame.maxX, y: startTitle.frame.minY), text: "结束时间")
        self.addSubview(endTitle)
        
        self.endPicker = HMSTimePicker(frame: CGRect(x: self.startPicker.frame.maxX, y: self.startPicker.frame.minY, width: self.startPicker.frame.width, height: self.startPicker.frame.height))
        self.endPicker.selectTime = { time in
            self.timeData.end = time
            self.onClick?(self.timeData)
        }
        self.addSubview(self.endPicker)
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
        path.addLine(to: CGPoint(x: self.center.x, y: self.startPicker.frame.maxY))
        path.lineWidth = 1 / UIScreen.main.scale
        path.close()
        path.stroke()

    }
 
}

extension BoneCalendarTimePicker {
    
    class HMSTimePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
        typealias valueChanged = (_ timeData: Mode) -> Void
        
        var date: Mode = Mode(hour: 00, minute: 00, second: 00)
        
        var selectTime: valueChanged?
        
        private var timeKey = "HMSTimePicker_timeKey"
        
        /// 时
        private var hourArray = [Int]()
        /// 分
        private var minuteArray = [Int]()
        /// 秒
        private var secondArray = [Int]()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.hourArray = (0...23).map {$0}
            self.minuteArray = (0...59).map {$0}
            self.secondArray = (0...59).map {$0}
            
            self.delegate = self
            self.dataSource = self
        }
        
        
        /// 设置选中列
        func selectRow(_ data: Mode, animated: Bool) {
            self.date = data
            if let hourRow = self.hourArray.index(of: data.hour) {
                self.selectRow(hourRow, inComponent: 0, animated: animated)
            }
            if let minuteRow = self.minuteArray.index(of: data.minute) {
                self.selectRow(minuteRow, inComponent: 1, animated: animated)
            }
            if let secondRow = self.secondArray.index(of: data.second) {
                self.selectRow(secondRow, inComponent: 2, animated: animated)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return self.hourArray.count
            } else if component == 1 {
                return self.minuteArray.count
            }
            return self.secondArray.count
        }
        
//        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//            if component == 0 {
//                return String(format: "%d时", self.hourArray[row])
//            } else if component == 1 {
//                return String(format: "%d分", self.minuteArray[row])
//            }
//            return String(format: "%d秒", self.secondArray[row])
//        }

        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 40
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17)
            if component == 0 {
                label.text = String(format: "%d时", self.hourArray[row])
            } else if component == 1 {
                label.text = String(format: "%d分", self.minuteArray[row])
            } else if component == 2 {
                label.text = String(format: "%d秒", self.secondArray[row])
            }
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor.darkText
            label.adjustsFontSizeToFitWidth = true
            return label
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 {
                self.date.hour = self.hourArray[row]
            } else if component == 1 {
                self.date.minute = self.minuteArray[row]
            } else if component == 2 {
                self.date.second = self.secondArray[row]
            }
            self.selectTime?(self.date)
        }
        
        /// 时间模型
        struct Mode {
            var hour: Int
            var minute: Int
            var second: Int
        }
    }
}
