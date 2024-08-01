//
//  LatestNoticeView.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit

class LatestNoticeView: UIView {
    
    var iconImageView : UIImageView!
    var valueLabel : UILabel!
    var button : UIButton!
    var urlString = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let backView = UIView(frame: self.bounds)
        backView.backgroundColor = #colorLiteral(red: 0.2018063664, green: 0.1636839807, blue: 0.5171515942, alpha: 1)
        self.addSubview(backView)
        
        let iconImageBackView = UIView(frame: CGRect(x: 10, y: 0, width: self.frame.size.height, height: self.frame.size.height))
        self.addSubview(iconImageBackView)
        
        iconImageView = UIImageView(frame: iconImageBackView.bounds)
        iconImageView.frame.size.height *= 0.45
        iconImageView.setImageWithFrameWidth(image: UIImage(named: "notice"))
        iconImageView.center = iconImageBackView.frame.center
        iconImageBackView.addSubview(iconImageView)
        
        valueLabel = UILabel(frame: CGRect(x: iconImageBackView.frame.maxX, y: 0, width: self.frame.size.width - iconImageBackView.frame.maxX, height: self.frame.size.height))
        valueLabel.font = UIFont(name: NotoSansCJKkr_Regular, size: valueLabel.frame.size.height * 0.33)
        valueLabel.textColor = UIColor.white
        self.addSubview(valueLabel)
        
        button = UIButton(frame: self.bounds)
        self.addSubview(button)
        
        self.button.addTarget(event: .touchUpInside, buttonAction: { (button) in
            if !self.urlString.isEmpty {
                goURL(urlString: self.urlString)
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func noticeUpdate(){
        Server.postData(urlString: URL_KEY.noticeList) { (kData : Data?) in
            if let data = kData {
                if let dataArray = data.toJson() as? [[String:Any]] {
                    if let latestNotice = dataArray.first {
                        print("latestNotice:\(latestNotice.showValue())")
                        if let sid = latestNotice["sid"] {
                            let subject = latestNotice["subject"] as? String ?? ""
                            self.valueLabel.text = subject
                            self.urlString = "\(URL_KEY.noticeView)&sid=\(sid)"
                            return
                        }
                    }
                }
            }
            self.valueLabel.text = ""
            self.urlString = ""
        }
    }
}
