//
//  PAGHeaderView.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit

@objc protocol PAGHeaderViewDelegate {
    @objc optional func pagHeaderView(pagHeaderView : PAGHeaderView, backButtonPressed backButton : UIButton)
//    @objc optional func pagHeaderView(pagHeaderView : PAGHeaderView, dayViewButtonPressed tab : String)
    
    @objc optional func pagHeaderView(pagHeaderView : PAGHeaderView, update tab : String)
}

class PAGHeaderView: UIView {
    
    var delegate : PAGHeaderViewDelegate?
    
    var dayViews = [DayViewButton]()
    var tapButtons = [TapButton]()
    
    init(infoDic : [String:Any]) {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: 0))
        
        self.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.9294117647, alpha: 1)
        
        guard let dayTypeString = infoDic["day_type"] as? String else { return }
        print("dayTypeString:\(dayTypeString)")

        if dayTypeString == "1" {
            
            let buttonBackView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: 45))
            self.addSubview(buttonBackView)
            
            guard let dayInfos = infoDic["day"] as? [[String:Any]] else { return }
            let buttonWidth = SCREEN.WIDTH / CGFloat(dayInfos.count)
            
            for i in 0..<dayInfos.count {
                
                let dayinfo = dayInfos[i]
                
                let button = TapButton(frame: CGRect(x: CGFloat(i) * buttonWidth, y: 0, width: buttonWidth, height: buttonBackView.frame.size.height))
                buttonBackView.addSubview(button)
                
                self.frame.size.height = buttonBackView.frame.maxY
                
                if let menu_bg = infoDic["menu_bg"] as? String {
                    let menu_bgColor = UIColor(colorWithHexString: menu_bg)
                    button.nonSelectedBackgroundColor = menu_bgColor
                }
                if let menu_bg_on = infoDic["menu_bg_on"] as? String {
                    let menu_bg_onColor = UIColor(colorWithHexString: menu_bg_on)
                    button.selectedBackgroundColor = menu_bg_onColor
                }
                
                if let name = dayinfo["name"] as? String {
                    button.setTitle(name, for: UIControl.State.normal)
                }
                
                if let menu_font = infoDic["menu_font"] as? String {
                    let menu_fontColor = UIColor(colorWithHexString: menu_font)
                    button.setTitleColor(menu_fontColor, for: .normal)
                }
                if let menu_font_on = infoDic["menu_font_on"] as? String {
                    let menu_font_onColor = UIColor(colorWithHexString: menu_font_on)
                    button.setTitleColor(menu_font_onColor, for: .selected)
                }
                if let tab = dayinfo["tab"] as? String {
                    button.tabString = tab
                }
                tapButtons.append(button)
                
                
//                button.isSelected = false
//                if let tab = dayinfo["tab"] as? String {
//                    button.tabString = tab
//                    if tab != "-1" {
//                        if isFirstCheck == false {
//                            print("여기가뜰텐데")
//                            button.isSelected = true
//                            self.delegate?.pagHeaderView?(pagHeaderView: self, dayViewButtonPressed: tab)
//                        }
//                        isFirstCheck = true
//                    }
//                }
                
                button.addTarget(self, action: #selector(tapButtonPressed(tapButton:)), for: .touchUpInside)
//                button.addTarget(event: .touchUpInside) { (kbutton) in
//                    for j in 0..<self.tapButtons.count {
//                        if button == self.tapButtons[j] {
//                            self.tapButtons[j].isSelected = true
//                            if button.tabString != "" {
//                                self.delegate?.pagHeaderView?(pagHeaderView: self, dayViewButtonPressed: button.tabString)
//                            }
//                        }else{
//                            self.tapButtons[j].isSelected = false
//                        }
//                    }
//                }
            }
        }else if dayTypeString == "2"{
            
            let monthLabel = UILabel(frame: CGRect(x: 0, y: 5, width: SCREEN.WIDTH, height: 30))
            monthLabel.textColor = #colorLiteral(red: 0.2039215686, green: 0.231372549, blue: 0.337254902, alpha: 1)
            monthLabel.text = infoDic["mon"] as? String
            monthLabel.textAlignment = .center
            monthLabel.font = UIFont.boldSystemFont(ofSize: 14)
            self.addSubview(monthLabel)
            
            let dayBackView = UIView(frame: CGRect(x: 0, y: monthLabel.frame.maxY, width: SCREEN.WIDTH, height: DayViewButton.Height))
            self.addSubview(dayBackView)
            self.frame.size.height = dayBackView.frame.maxY + 10
            
            var maxX : CGFloat = 0
            guard let dayInfos = infoDic["day"] as? [[String:Any]] else { return }
            
            for i in 0..<dayInfos.count {
                
                let dayView = DayViewButton(infoDic: infoDic, index : i)
                dayView.frame.origin.x = CGFloat(i) * DayViewButton.Width
                dayBackView.addSubview(dayView)
                
                dayViews.append(dayView)
                
                maxX = dayView.frame.maxX
                dayView.addTarget(self, action: #selector(dayViewButtonPressed(dayView:)), for: .touchUpInside)
            }
            
            dayBackView.frame.size.width = maxX
            dayBackView.center.x = SCREEN.WIDTH / 2
        }
    }
    
    
    @objc func dayViewButtonPressed(dayView : DayViewButton){
        print("dayViewButtonPressed")
        if dayView.tabString != "" {
            print("dayView.tabString:\(dayView.tabString)")
            self.delegate?.pagHeaderView?(pagHeaderView: self, update: dayView.tabString)
            
            for i in 0..<self.dayViews.count {
                if self.dayViews[i].tab != nil {
                    if dayView == self.dayViews[i] {
                        self.dayViews[i].isSelected = true
                    }else{
                        self.dayViews[i].isSelected = false
                    }
                    
                }
            }
            
        }
        
    }
    
    @objc func tapButtonPressed(tapButton : TapButton){
        print("tapButtonPressed")
        for j in 0..<self.tapButtons.count {
            if tapButton == self.tapButtons[j] {
                self.tapButtons[j].isSelected = true
                if tapButton.tabString != "" {
                    print("tapButton.tabString:\(tapButton.tabString)")
                    self.delegate?.pagHeaderView?(pagHeaderView: self, update: tapButton.tabString)
                }
            }else{
                self.tapButtons[j].isSelected = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TapButton: UIButton {
    
    var selectedBackgroundColor = UIColor.white
    var nonSelectedBackgroundColor = UIColor.white
    
    var tabString = ""
    
    override var isSelected : Bool {
        willSet(newIsSelected){
            if newIsSelected {
                self.backgroundColor = selectedBackgroundColor
            }else{
                self.backgroundColor = nonSelectedBackgroundColor
            }
        }
    }
}

class DayViewButton: UIButton {
    
    static let Width : CGFloat = 40
    static let Height : CGFloat = 45
    
    var weekLabel : UILabel!
    var dayLabel : UILabel!
    
    var tab : Int? = 0
    var tabString = ""
    
    override var isEnabled : Bool {
        willSet(newIsEnabled) {
            self.stateUpdate(enabled: newIsEnabled, select: self.isSelected)
        }
    }
    
    override var isSelected : Bool {
        willSet(newIsSelected){
            self.stateUpdate(enabled: self.isEnabled, select: newIsSelected)
        }
    }
    
    func stateUpdate( enabled : Bool, select : Bool) {
        if !enabled {
            self.dayLabel.textColor = #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.662745098, alpha: 1)
            self.dayLabel.backgroundColor = UIColor.clear
        }else{
            if select {
                self.dayLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.dayLabel.backgroundColor = selectedBGColor
            }else{
                self.dayLabel.textColor = #colorLiteral(red: 0.2039215686, green: 0.231372549, blue: 0.337254902, alpha: 1)
                self.dayLabel.backgroundColor = UIColor.clear
            }
        }
    }
    
    var selectedBGColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.7333333333, alpha: 1)
    
    init(infoDic : [String:Any], index : Int) {

        super.init(frame: CGRect(x: 0, y: 0, width: DayViewButton.Width, height: DayViewButton.Height))

        guard let dayInfos = infoDic["day"] as? [[String:Any]] else { return }
        
        selectedBGColor = UIColor(colorWithHexString: infoDic["session_day_bg"] as? String ?? "2d63bb")
        
        weekLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height : 18))
        weekLabel.textColor = #colorLiteral(red: 0.2039215686, green: 0.231372549, blue: 0.337254902, alpha: 1)
        weekLabel.textAlignment = .center
        weekLabel.font = UIFont.boldSystemFont(ofSize: 13)
        weekLabel.isUserInteractionEnabled = false
        weekLabel.text = dayInfos[index]["week"] as? String
        self.addSubview(weekLabel)
        
        let dayLabelBackView = UIView(frame: CGRect(x: 0, y: weekLabel.frame.maxY, width: self.frame.size.width, height: self.frame.size.height - weekLabel.frame.maxY))
        dayLabelBackView.isUserInteractionEnabled = false
        self.addSubview(dayLabelBackView)
        
        let dayLabelSide : CGFloat = min(dayLabelBackView.frame.size.width, dayLabelBackView.frame.size.height)
        dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dayLabelSide, height: dayLabelSide))
        dayLabel.center = dayLabelBackView.center
        dayLabel.textColor = #colorLiteral(red: 0.2039215686, green: 0.231372549, blue: 0.337254902, alpha: 1)
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.systemFont(ofSize: 13)
        dayLabel.text = dayInfos[index]["day"] as? String
        dayLabel.layer.cornerRadius = dayLabelSide / 2
        dayLabel.clipsToBounds = true
        dayLabel.isUserInteractionEnabled = false
        self.addSubview(dayLabel)
        
        if let tab = dayInfos[index]["tab"] as? Int, tab == -1 {
            self.isEnabled = false
        }else{
            self.isEnabled = true
            if let tab = dayInfos[index]["tab"] as? String {
                self.tabString = tab
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
