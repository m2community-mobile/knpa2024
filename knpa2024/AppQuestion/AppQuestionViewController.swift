//
//  appQuestionViewController.swift
//  IDEN2019
//
//  Created by m2comm on 08/05/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import Foundation
import FontAwesome_swift

let QUESTION_URL = "https://ezv.kr:4447/voting/php/question/post.php"

class AppQuestionViewController: UIViewController {
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    
    var titleLabel : UILabel!
    var questionTextView : UITextView!
    var selectNameLabel : UILabel!
    
    var selectQuestionIndexPath : IndexPath?
    var questionSelectView : AppQuestionSelectView?
    var questionDataArray = [[String:Any]]()
    
    var selectNameLabelDefaultString = "선택해 주십시오    ▼"
    
    //웹뷰로부터 전달받음
    var session_sid = ""
    
    //post할때 같이 보내야함
    var session = "" //부모
    var sub = "" //자식
    
    var room = ""
    var name = ""
    
   
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.white
        
        let naviBar = UIView(frame: CGRect(x: 0, y: STATUS_BAR_HEIGHT, width: SCREEN.WIDTH, height: 50))
        self.view.addSubview(naviBar)
        
        
        let closeButton = ImageButton(frame: CGRect(x: SCREEN.WIDTH - NAVIGATION_BAR_HEIGHT - 10, y: STATUS_BAR_HEIGHT, width: NAVIGATION_BAR_HEIGHT, height: NAVIGATION_BAR_HEIGHT), image: UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), ratio: 0.45)
        closeButton.buttonImageView.tintColor = UIColor.black
        closeButton.setTarget(event: UIControl.Event.touchUpInside) { [weak self] (button) in
            self?.dismiss(animated: true) {}
        }
        self.view.addSubview(closeButton)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH - (naviBar.frame.size.height * 2), height: naviBar.frame.size.height))
        titleLabel.center.x = SCREEN.WIDTH / 2
        titleLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: titleLabel.frame.size.height * 0.45)
        titleLabel.textColor = #colorLiteral(red: 0.1215686275, green: 0.1960784314, blue: 0.5568627451, alpha: 1)
        titleLabel.textAlignment = .center
        self.titleLabel.text = "Question"
        naviBar.addSubview(titleLabel)
        
        let innerView1 = UIView(frame: CGRect(x: 0, y: naviBar.frame.maxY, width: SCREEN.WIDTH, height: SCREEN.HEIGHT - SAFE_AREA - naviBar.frame.maxY))
        self.view.addSubview(innerView1)
//
        let innerView2 = UIView(frame: innerView1.bounds)
        innerView2.frame.size.width -= 30
//        innerView2.frame.size.height -= 30
        innerView2.center = innerView1.frame.center
        if !IS_NORCH {
            innerView2.frame.size.height -= 10
        }
        innerView2.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9529411765, blue: 0.9882352941, alpha: 1)
        innerView1.addSubview(innerView2)
        
        let innerView3 = UIView(frame: innerView2.bounds)
        innerView3.frame.size.width -= 30
        innerView3.frame.size.height -= 30
        innerView3.center = innerView2.frame.center
        innerView2.addSubview(innerView3)
        
        ////
        
        let subTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: innerView3.frame.size.width, height: 60))
        if IS_IPHONE_SE {
            subTitleLabel.frame.size.height = 50
        }
        subTitleLabel.text = "강의중 궁금하신 내용을 질문해 주십시오"
        subTitleLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Light, size: subTitleLabel.frame.size.height * 0.32)
        subTitleLabel.textAlignment = .center
        innerView3.addSubview(subTitleLabel)
        
        ////

        let sendButton = UIButton(frame: CGRect(x: 0, y: subTitleLabel.frame.maxY + 10, width: innerView3.frame.size.width, height: 50))
        innerView3.addSubview(sendButton)
        
        let sendButtonGradientView = UIView(frame: sendButton.bounds)
//            GradientView(frame: sendButton.bounds, colorA: #colorLiteral(red: 0.1607843137, green: 0.4705882353, blue: 0.2078431373, alpha: 1), colorB: #colorLiteral(red: 0.03137254902, green: 0.4039215686, blue: 0.4666666667, alpha: 1))
        sendButtonGradientView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1960784314, blue: 0.5568627451, alpha: 1)
        sendButtonGradientView.isUserInteractionEnabled = false
        sendButton.addSubview(sendButtonGradientView)
        
        let sendButtonRightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 0))
        sendButtonRightImageView.setImageWithFrameHeight(image: UIImage(named: "btn_d_next1"))
        sendButtonRightImageView.center.y = sendButton.frame.size.height / 2
        sendButtonRightImageView.frame.origin.x = sendButton.frame.size.width - (sendButtonRightImageView.frame.size.width + 10)
        sendButtonRightImageView.isUserInteractionEnabled = false
        sendButton.addSubview(sendButtonRightImageView)
        
        let sendButtonLabel = UILabel(frame: sendButton.bounds)
        sendButtonLabel.text = "전송"
        sendButtonLabel.textAlignment = .center
        sendButtonLabel.textColor = UIColor.white
        sendButtonLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: sendButtonLabel.frame.size.height * 0.35)
        sendButton.addSubview(sendButtonLabel)
        
        let sendRightImageBackView = UIView(frame: CGRect(x: sendButtonLabel.frame.size.width - sendButtonLabel.frame.size.height, y: 0, width: sendButtonLabel.frame.size.height, height: sendButtonLabel.frame.size.height))
        sendRightImageBackView.isUserInteractionEnabled = false
        sendButtonLabel.addSubview(sendRightImageBackView)
        
        let sendRightImageView = UIImageView(frame: sendRightImageBackView.bounds)
        sendRightImageView.frame.size.height *= 0.6
        sendRightImageView.setImageWithFrameWidth(image: UIImage(named: "btn_d_next2"))
        sendRightImageView.center = sendRightImageBackView.frame.center
        sendRightImageBackView.addSubview(sendRightImageView)
        
        ////
        
        let selectButton = UIButton(frame: CGRect(x: 0, y: sendButton.frame.maxY + 10, width: innerView3.frame.size.width, height: 50))
        selectButton.layer.borderColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
        selectButton.layer.borderWidth = 0.5
        selectButton.backgroundColor = UIColor.white
        innerView3.addSubview(selectButton)
        
        selectNameLabel = UILabel(frame: selectButton.bounds)
        selectNameLabel.frame.size.width -= 20
        selectNameLabel.center.x = selectButton.frame.size.width / 2
        selectNameLabel.text = self.selectNameLabelDefaultString
        selectNameLabel.textAlignment = .center
        selectNameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: selectNameLabel.frame.size.height * 0.35)
        selectNameLabel.textColor = UIColor.black
        selectNameLabel.backgroundColor = UIColor.clear
        selectNameLabel.isUserInteractionEnabled = false
        selectButton.addSubview(selectNameLabel)
        ////
        
        let textViewBackView = UIView(frame: CGRect(x: 0, y: selectButton.frame.maxY + 10, width: innerView3.frame.size.width, height: innerView3.frame.size.height - (selectButton.frame.maxY + 10)))
        textViewBackView.layer.borderColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
        textViewBackView.layer.borderWidth = 0.5
        textViewBackView.backgroundColor = UIColor.white
        innerView3.addSubview(textViewBackView)
        
        questionTextView = UITextView(frame: textViewBackView.bounds)
        questionTextView.frame.size.width -= 20
        questionTextView.frame.size.height -= 20
        questionTextView.center = textViewBackView.frame.center
        questionTextView.backgroundColor = UIColor.clear
        questionTextView.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 15)
        textViewBackView.addSubview(questionTextView)
        
        
        self.questionUpdate()
        
        sendButton.setTarget(event: .touchUpInside) { [weak self] (button) in
            guard let self = self else { return }
            self.questionTextView.resignFirstResponder()
            self.requestQuestion()
        }
        
        selectButton.setTarget(event: .touchUpInside) { [weak self] (butotn) in
            guard let self = self else { return }
            
            self.questionTextView.resignFirstResponder()
            
            if self.questionDataArray.count == 0 {
                toastShow(message: "준비중입니다.")
                self.questionUpdate()
                return
            }
            
            if self.questionSelectView == nil {
                self.questionSelectView = AppQuestionSelectView(questionDataArray: self.questionDataArray)
                self.questionSelectView?.questionViewCon = self
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
        let urlString = "https://ezv.kr:4447/voting/php/session/get_session.php?code=\(code)&session_sid=\(session_sid)"
        
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
        
        self.selectQuestionIndexPath = indexPath
        print("self.questionDataArray : \(self.questionDataArray)")
        
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
                    if let speaker = subDic["speaker"] as? String {
                        self.name = speaker
                    }
                    if let title = subDic["title"] as? String {
                        self.selectNameLabel.text = title
                    }
                }
            }
        }
    }
    
    
    func requestQuestion(){
        
        if self.questionDataArray.count == 0 {
            toastShow(message: "준비중입니다.")
            return
        }
        
        if self.questionTextView.text == "" {
            toastShow(message: "질문을 입력해주세요.")
            return
        }
        
        
        if self.selectNameLabel.text == selectNameLabelDefaultString {
            toastShow(message: "강의를 선택해주세요.")
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
            "name":self.name,
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
                            self.present(alertCon, animated: true, completion: {
                                self.questionTextView.text = ""
                            })
                        }
                    }else{
                        DispatchQueue.main.async {
                            let alertCon = UIAlertController(title: "안내", message: "통신이 원활하지 않습니다.\n잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                            alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
                            self.present(alertCon, animated: true, completion: { })
                        }
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                let alertCon = UIAlertController(title: "안내", message: "통신이 원활하지 않습니다.\n잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in }))
                self.present(alertCon, animated: true, completion: {
                    
                })
            }
        }
    }
}


class GradientView: UIView {
    
    init(frame: CGRect, colorA : UIColor, colorB : UIColor) {
        super.init(frame: frame)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorA.cgColor, colorB.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.addSublayer(gradientLayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
