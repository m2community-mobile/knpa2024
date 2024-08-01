//
//  PAG_NoticeButton.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit

class PAG_NoticeButton: UIButton {

    init() {
        super.init(frame: SCREEN.BOUND)
        
        self.addTarget(event: UIControl.Event.touchUpInside) { (button) in
            self.isHidden = true
        }
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let noticeInnerView = UIView(frame: self.frame)
        noticeInnerView.isUserInteractionEnabled = false
        self.addSubview(noticeInnerView)
        
        let noticeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: noticeInnerView.frame.size.width * 0.25, height: 0))
        noticeImageView.setImageWithFrameHeight(image: UIImage(named: "finger"))
        noticeImageView.center.x = noticeInnerView.frame.size.width / 2
        noticeInnerView.addSubview(noticeImageView)
        
        let noticeLabel = UILabel(frame: noticeInnerView.bounds)
        noticeLabel.frame.origin.y = noticeImageView.frame.maxY + 30
        noticeLabel.numberOfLines = 0
        noticeLabel.textColor = UIColor.white
        noticeLabel.textAlignment = .center
        noticeLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 20)
        noticeLabel.text = """
        세션을 터치하시면 세부 내용을
        확인할 수 있습니다.
        확대 / 축소 가능합니다.
        """
        noticeLabel.sizeToFit()
        noticeLabel.center.x = noticeInnerView.frame.size.width / 2
        noticeInnerView.addSubview(noticeLabel)
        
        noticeInnerView.frame.size.height = noticeLabel.frame.maxY
        noticeInnerView.center.y = self.frame.size.height / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
