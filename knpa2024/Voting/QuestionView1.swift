//
//  QuestionView1.swift
//  CosoptTransformSymposium2019
//
//  Created by m2comm on 25/03/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class QuestionView1: UIView {

    var motherVC : UIViewController?
    var titleLabel : UILabel!

    var questionTextView : UITextView!
    
    init(frame: CGRect, titleName : String, motherVC kMotherVC : UIViewController) {
        super.init(frame: frame)
        
        motherVC = kMotherVC
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: STATUS_BAR_HEIGHT, width: SCREEN.WIDTH, height: SCREEN.WIDTH * 60 / 320))
        titleLabel.font = UIFont(name: MyriadPro_Bold, size: 33)
        titleLabel.textAlignment = .center
        self.titleLabel.text = titleName
        self.addSubview(titleLabel)
        
        let homeButton = UIButton(frame: CGRect(x: 0, y: titleLabel.frame.origin.y, width: titleLabel.frame.size.height, height: titleLabel.frame.size.height))
        self.addSubview(homeButton)
        
        let homeButtonImageView = UIImageView(frame: homeButton.bounds)
        homeButtonImageView.frame.size.width *= 0.75
        homeButtonImageView.frame.size.height *= 0.75
        homeButtonImageView.center = homeButton.frame.center
        homeButtonImageView.image = UIImage(named: "btn_d_home1")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        homeButtonImageView.tintColor = UIColor.black
        homeButtonImageView.isUserInteractionEnabled = false
        homeButton.addSubview(homeButtonImageView)
        
        homeButton.addTarget(event: .touchUpInside) { (button) in
            appDel.naviCon?.popViewController(animated: true)
        }
        
        var normalColors = [UIColor]()
        var normalColors2 = [UIColor]()
        for i in 0..<5 {
            normalColors.append(questionSelectedColor.removeBrightness(val: 0.05 * CGFloat(i)))
            normalColors2.append(questionSelectedColor.removeBrightness(val: 0.05 * CGFloat(i + 2)))
        }
        
        let sendBackImageView = UIImageView(frame: CGRect(x: 15, y: self.titleLabel.frame.maxY, width: SCREEN.WIDTH - 30, height: 0))
        sendBackImageView.backgroundColor = questionSelectedColor
        sendBackImageView.frame.size.height = sendBackImageView.frame.size.width * (100 / 580)
        sendBackImageView.isUserInteractionEnabled = true
        self.addSubview(sendBackImageView)
        sendBackImageView.setCornerRadius(cornerRadius: 10, byRoundingCorners: [.topLeft, .topRight])
        sendBackImageView.setGradientColorImage(colors: normalColors)
        
        let sendButtonImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: sendBackImageView.frame.size.height * 0.6))
        sendButtonImageView.frame.size.width = sendButtonImageView.frame.size.height * (110 / 62)
        sendButtonImageView.backgroundColor = questionNonSelectedColor
        sendButtonImageView.center.y = sendBackImageView.frame.size.height / 2
        sendButtonImageView.frame.origin.x = sendBackImageView.frame.size.width - sendButtonImageView.frame.size.width - 10
        sendButtonImageView.isUserInteractionEnabled = false
        sendButtonImageView.layer.cornerRadius = 10
        sendButtonImageView.clipsToBounds = true
        sendButtonImageView.setGradientColorImage(colors: normalColors2)
        
        
        let sendButton = UIButton(frame: sendButtonImageView.frame)
        sendButton.setTitle("SEND", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendBackImageView.addSubview(sendButtonImageView)
        sendBackImageView.addSubview(sendButton)
        
        let sendTitleLabel = UILabel(frame: sendBackImageView.frame)
        sendTitleLabel.textAlignment = .center
        sendTitleLabel.font = UIFont.boldSystemFont(ofSize: sendTitleLabel.frame.size.height * 0.4)
        sendTitleLabel.text = "질문 보내기"
        sendTitleLabel.textColor = UIColor.white
        self.addSubview(sendTitleLabel)
        
        let questionTextLabel = UILabel(frame: CGRect(
            x: 0,
            y: sendBackImageView.frame.maxY + 10,
            width: SCREEN.WIDTH * 0.8,
            height: 40))
        questionTextLabel.center.x = SCREEN.WIDTH / 2
        questionTextLabel.text = "강의 내용 중 궁금하신 점을 질문해 주세요"
        questionTextLabel.textColor = UIColor(colorWithHexValue: 0x737373)
        questionTextLabel.adjustsFontSizeToFitWidth = true
        questionTextLabel.textAlignment = .center
        self.addSubview(questionTextLabel)
        
        let box3ImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: SCREEN.WIDTH - 30, height: 0))
        box3ImageView.setImageWithFrameHeight(image: UIImage(named: "box_bg3"))
        box3ImageView.frame.origin.y = self.frame.size.height - box3ImageView.frame.size.height - 10
        self.addSubview(box3ImageView)
        
        let box2ImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: SCREEN.WIDTH - 30, height: 0))
        box2ImageView.image = UIImage(named: "box_bg2")
        box2ImageView.frame.origin.y = sendBackImageView.frame.origin.y + (sendBackImageView.frame.size.height / 2)
        box2ImageView.frame.size.height = box3ImageView.frame.origin.y - box2ImageView.frame.origin.y
        self.insertSubview(box2ImageView, at: 0)
        
        let textViewBackView = UIView(frame: CGRect(x: 30, y: (questionTextLabel.frame.maxY + 10), width: SCREEN.WIDTH - 60, height: box3ImageView.frame.origin.y + (box3ImageView.frame.size.height * 0.5) - (questionTextLabel.frame.maxY + 10)))
        textViewBackView.backgroundColor = UIColor(colorWithHexValue: 0xEBEBEB)
        textViewBackView.layer.cornerRadius = 10
        textViewBackView.layer.borderColor = UIColor(colorWithHexValue: 0xD4D4D4).cgColor
        textViewBackView.layer.borderWidth = 1
        self.addSubview(textViewBackView)
        
        questionTextView = UITextView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: textViewBackView.frame.size.width - 10, height: textViewBackView.frame.size.height - 10)))
        questionTextView.backgroundColor = UIColor.clear
        questionTextView.center = CGPoint(x: textViewBackView.frame.size.width / 2, y: textViewBackView.frame.size.height / 2)
        questionTextView.font = UIFont.systemFont(ofSize: 14)
        questionTextView.delegate = self.motherVC
        questionTextView.addDoneCancelToolbar(doneString: "Done")
        textViewBackView.addSubview(questionTextView)
        
        sendButton.addTarget(event: .touchUpInside) { [weak self] (button) in
            self?.requestQuestion()
        }
    }

    func requestQuestion(){
        
        if self.questionTextView.text == "" {
            let alertCon = UIAlertController(title: "안내", message: "질문을 입력해주세요.", preferredStyle: .alert)
            alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
            self.motherVC?.present(alertCon, animated: true, completion: {
                
            })
            return
        }
        
        let para = [
            "code" : code,
            "deviceid":deviceID,
            "device":"IOS",
            "question":self.questionTextView.text!,
            
            "mobile":"mobile",
            
        ]
        
        Server.postData(urlString: QUESTION_URL, otherInfo: para) { (kData : Data?) in
            if let data = kData {
                if let dataString = data.toString() {
                    print("question dataString:\(dataString)")
                    if dataString == "Y" {
                        DispatchQueue.main.async {
                            let alertCon = UIAlertController(title: "안내", message: "질문이 등록되었습니다.", preferredStyle: .alert)
                            alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
                            self.motherVC?.present(alertCon, animated: true, completion: {
                                self.questionTextView.text = ""
                            })
                        }
                    }else{
                        DispatchQueue.main.async {
                            let alertCon = UIAlertController(title: "안내", message: "네트워크 오류\n 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                            alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
                            self.motherVC?.present(alertCon, animated: true, completion: { })
                        }
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                
                let alertCon = UIAlertController(title: "안내", message: "네트워크 오류\n 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
                self.motherVC?.present(alertCon, animated: true, completion: {
                    self.questionTextView.text = ""
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
