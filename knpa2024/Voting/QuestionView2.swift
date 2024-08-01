//
//  QuestionView1.swift
//  CosoptTransformSymposium2019
//
//  Created by m2comm on 25/03/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit
import FontAwesome_swift

class QuestionView2: UIView {

    var mainVC : UIViewController?
    var titleLabel : UILabel!

    var questionTextView : UITextView!
    
    var selectNameLabel : UILabel!
    
    var selectQuestionIndexPath : IndexPath?
    var questionSelectView : QuestionSelectView?
    var questionDataArray = [[String:Any]]()
    
    //post할때 같이 보내야함
    var session = "" //부모
    var sub = "" //자식
    
    var room = ""
    
    init(frame: CGRect, titleName : String, mainVC kMainVC : UIViewController) {
        super.init(frame: frame)
        
        self.mainVC = kMainVC
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: STATUS_BAR_HEIGHT, width: SCREEN.WIDTH, height: SCREEN.WIDTH * 60 / 320))
        titleLabel.font = UIFont(name: MyriadPro_Bold, size: 30)
        if IS_IPHONE_N {
            titleLabel.frame.size.height = SCREEN.WIDTH * 40 / 320
            titleLabel.font = UIFont(name: MyriadPro_Bold, size: 25)
        }
        if IS_IPHONE_SE {
            titleLabel.frame.size.height = SCREEN.WIDTH * 40 / 320
            titleLabel.font = UIFont(name: MyriadPro_Bold, size: 25)
        }
        titleLabel.textAlignment = .center
        self.titleLabel.text = titleName
        self.addSubview(titleLabel)
        
        var normalColors = [UIColor]()
        var normalColors2 = [UIColor]()
        for i in 0..<5 {
            normalColors.append(questionSelectedColor.removeBrightness(val: 0.05 * CGFloat(i)))
            normalColors2.append(questionSelectedColor.removeBrightness(val: 0.05 * CGFloat(i + 2)))
        }
        
        let sendBackImageView = UIImageView(frame: CGRect(x: 15, y: titleLabel.frame.maxY, width: SCREEN.WIDTH - 30, height: 0))
        sendBackImageView.backgroundColor = questionSelectedColor
        sendBackImageView.frame.size.height = sendBackImageView.frame.size.width * (100 / 580)
        sendBackImageView.isUserInteractionEnabled = true
        self.addSubview(sendBackImageView)
        sendBackImageView.setCornerRadius(cornerRadius: 10, byRoundingCorners: [.topLeft, .topRight])
        sendBackImageView.setGradientColorImage(colors: normalColors)
        
        let sendButtonImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: sendBackImageView.frame.size.height * 0.6))
        sendButtonImageView.frame.size.width = sendButtonImageView.frame.size.height * (110 / 62)
//        sendButtonImageView.backgroundColor = questionNonSelectedColor
        sendButtonImageView.center.y = sendBackImageView.frame.size.height / 2
        sendButtonImageView.frame.origin.x = sendBackImageView.frame.size.width - sendButtonImageView.frame.size.width - 10
        sendButtonImageView.isUserInteractionEnabled = false
        sendButtonImageView.layer.cornerRadius = 10
        sendButtonImageView.layer.borderColor = UIColor(colorWithHexValue: 0xB2B2B2).cgColor
        sendButtonImageView.layer.borderWidth = 1
        sendButtonImageView.clipsToBounds = true
        sendButtonImageView.backgroundColor = UIColor.white
        
//        sendButtonImageView.setGradientColorImage(colors: normalColors2)
        
        
        let sendButton = UIButton(frame: sendButtonImageView.frame)
        sendButton.setTitle("SEND", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.setTitleColor(questionSelectedColor, for: .normal)
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
        
        let selectBackView = UIView(frame: CGRect(x: 0, y: questionTextLabel.frame.maxY, width: SCREEN.WIDTH * 0.8, height: 60))
        if IS_IPHONE_SE {
            selectBackView.frame.size.height = 55
        }
        selectBackView.center.x = SCREEN.WIDTH / 2
        self.addSubview(selectBackView)
        
        //강의자 이름
        let selectViewNameLabelWidth : CGFloat = 70
        let selectViewNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: selectViewNameLabelWidth, height: selectBackView.frame.size.height))
        selectViewNameLabel.text = "연자명"
        selectViewNameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 20)
        if IS_IPHONE_SE {
            selectViewNameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 17)
        }
        selectViewNameLabel.textAlignment = .center
        selectBackView.addSubview(selectViewNameLabel)
        
        let selectNameButton = UIButton(frame: CGRect(x: selectViewNameLabel.frame.maxX + 5, y: 0, width: selectBackView.frame.size.width - (selectViewNameLabel.frame.maxX + 5), height: selectBackView.frame.size.height))
        selectBackView.addSubview(selectNameButton)
        
        let selectNameLabelBackView = UIView(frame: selectNameButton.bounds)
        selectNameLabelBackView.isUserInteractionEnabled = false
        selectNameLabelBackView.frame.size.height = 40
        selectNameLabelBackView.center = selectNameButton.frame.center
        selectNameLabelBackView.backgroundColor = UIColor(colorWithHexValue: 0xEBEBEB)
        selectNameLabelBackView.layer.cornerRadius = 10
        selectNameLabelBackView.layer.borderColor = UIColor(colorWithHexValue: 0xD4D4D4).cgColor
        selectNameLabelBackView.layer.borderWidth = 1
        selectNameButton.addSubview(selectNameLabelBackView)
        
        selectNameLabel = UILabel(frame: selectNameLabelBackView.bounds)
        selectNameLabel.frame.size.width -= 15
        selectNameLabel.center = selectNameLabelBackView.frame.center
        selectNameLabel.textAlignment = .center
        selectNameLabel.text = "선택하여 주시기 바랍니다."
        selectNameLabel.textColor = UIColor.black
        selectNameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 17)
        if IS_IPHONE_SE {
            selectNameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 15)
        }
        selectNameLabel.clipsToBounds = true
        selectNameLabel.isUserInteractionEnabled = false
        selectNameLabelBackView.addSubview(selectNameLabel)
        
        self.questionUpdate()
        
        let separaterView1 = UIView(frame: CGRect(x: 0, y: questionTextLabel.frame.maxY, width: SCREEN.WIDTH * 0.8, height: 0.5))
        separaterView1.center.x = SCREEN.WIDTH / 2
        separaterView1.backgroundColor = UIColor.black
        self.addSubview(separaterView1)
        
//        let separaterView2 = UIView(frame: CGRect(x: 0, y: selectBackView.frame.maxY, width: SCREEN.WIDTH * 0.8, height: 0.5))
//        separaterView2.center.x = SCREEN.WIDTH / 2
//        separaterView2.backgroundColor = UIColor.black
//        self.addSubview(separaterView2)
        
        let box3ImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: SCREEN.WIDTH - 30, height: 0))
        box3ImageView.setImageWithFrameHeight(image: UIImage(named: "box_bg3"))
        box3ImageView.frame.origin.y = self.frame.size.height - box3ImageView.frame.size.height - 10
        self.addSubview(box3ImageView)
        
        let box2ImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: SCREEN.WIDTH - 30, height: 0))
        box2ImageView.image = UIImage(named: "box_bg2")
        box2ImageView.frame.origin.y = sendBackImageView.frame.origin.y + (sendBackImageView.frame.size.height / 2)
        box2ImageView.frame.size.height = box3ImageView.frame.origin.y - box2ImageView.frame.origin.y
        self.insertSubview(box2ImageView, at: 0)

        let textViewBackView = UIView(frame: CGRect(x: 30, y: (selectBackView.frame.maxY + 10), width: SCREEN.WIDTH - 60, height: box3ImageView.frame.origin.y + (box3ImageView.frame.size.height * 0.5) - (selectBackView.frame.maxY + 10)))
        textViewBackView.backgroundColor = UIColor(colorWithHexValue: 0xEBEBEB)
        textViewBackView.layer.cornerRadius = 10
        textViewBackView.layer.borderColor = UIColor(colorWithHexValue: 0xD4D4D4).cgColor
        textViewBackView.layer.borderWidth = 1
        self.addSubview(textViewBackView)
        
        questionTextView = UITextView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: textViewBackView.frame.size.width - 10, height: textViewBackView.frame.size.height - 10)))
        questionTextView.backgroundColor = UIColor.clear
        questionTextView.center = CGPoint(x: textViewBackView.frame.size.width / 2, y: textViewBackView.frame.size.height / 2)
        questionTextView.font = UIFont.systemFont(ofSize: 14)
//        questionTextView.delegate = self.mainVC
        questionTextView.addDoneCancelToolbar(doneString: "Done")
        textViewBackView.addSubview(questionTextView)
        
        sendButton.addTarget(event: .touchUpInside) { [weak self] (button) in
            self?.requestQuestion()
        }
        
        selectNameButton.addTarget(event: .touchUpInside) { [weak self] (button) in
            guard let self = self else {return}
            
            self.questionTextView.resignFirstResponder()
            
            if self.questionDataArray.count == 0 {
                appDel.showAlert(title: "Notice", message: "통신상태가 원활하지 않습니다.\n잠시 후 다시 시도해주세요.")
//                UIAlertController.showAlert(message: "통신상태가 원활하지 않습니다.\n잠시 후 다시 시도해주세요.", title: "Notice")
                self.questionUpdate()
                return
            }
            
            if self.questionSelectView == nil {
                self.questionSelectView = QuestionSelectView(questionDataArray: self.questionDataArray)
                self.questionSelectView?.questionView = self
                appDel.window?.addSubview(self.questionSelectView!)
            }
            
            self.questionSelectView?.isHidden = false
            self.questionSelectView?.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.questionSelectView?.alpha = 1
            }) { (fi) in
                
            }
            
            
        }
    }

    
    func questionUpdate(){
        let urlString = "https://ezv.kr:4447/voting/php/session/get_session.php?code=\(code)"
        
        print("questionUpdate:\(urlString)")
        Server.postData(urlString: urlString) { [weak self] (kData : Data?) in
            if let data = kData {
                if let dataArray = data.toJson() as? [[String:Any]] {
                    print("dataArray : \(dataArray)")
                    self?.questionDataArray = dataArray
                }
            }
        }
    }
    
    func selectQuestionUpdate(indexPath : IndexPath){
        print("selectQuestionUpdate:\(indexPath)")
        
        
        self.selectQuestionIndexPath = indexPath
        
        if indexPath.section < self.questionDataArray.count {
            
            let dataDic = self.questionDataArray[indexPath.section]
            
            if let sessionSid = dataDic["sid"] as? String {
                self.session = sessionSid
            }
            
            self.room = dataDic["room"] as? String ?? ""
            
            if let subArray = dataDic["sub"] as? [[String:Any]] {
                if indexPath.row < subArray.count {
                    let subDic = subArray[indexPath.row]
                    if let subSid = subDic["sid"] as? String {
                        self.sub = subSid
                    }
                    if let title = subDic["title"] as? String {
                        self.selectNameLabel.text = title
                    }
                }
            }
        }
        
    }
    
    
    func requestQuestion(){
        
        if self.questionTextView.text == "" {
            let alertCon = UIAlertController(title: "안내", message: "질문을 입력해주세요.", preferredStyle: .alert)
            alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
            self.mainVC?.present(alertCon, animated: true, completion: {
                
            })
            
            return
        }

        if self.selectNameLabel.text == "선택하여 주시기 바랍니다." {
            let alertCon = UIAlertController(title: "안내", message: "연자명을 선택해주세요.", preferredStyle: .alert)
            alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
            self.mainVC?.present(alertCon, animated: true, completion: {
                
            })
            
            return
        }
        
        
        let para = [
            "code" : code,
            "question":self.questionTextView.text!,
            "deviceid":deviceID,
            "device":"IOS",
            "lecture":self.selectNameLabel.text!,
            "session" : self.session,
            "sub":self.sub,
            "room":self.room,
            "mobile":"mobile"
        ]
        print("para:\(para)")
        Server.postData(urlString: QUESTION_URL, otherInfo: para) { (kData : Data?) in
            if let data = kData {
                if let dataString = data.toString() {
                    print("question dataString:\(dataString)")
                    if dataString == "Y" {
                        DispatchQueue.main.async {
                            let alertCon = UIAlertController(title: "안내", message: "질문이 등록되었습니다.", preferredStyle: .alert)
                            alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
                            self.mainVC?.present(alertCon, animated: true, completion: {
                                self.questionTextView.text = ""
                            })
                        }
                    }else{
                        DispatchQueue.main.async {
                            let alertCon = UIAlertController(title: "안내", message: "네트워크 오류\n 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                            alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
                            self.mainVC?.present(alertCon, animated: true, completion: { })
                        }
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                let alertCon = UIAlertController(title: "안내", message: "네트워크 오류\n 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
                self.mainVC?.present(alertCon, animated: true, completion: {
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
