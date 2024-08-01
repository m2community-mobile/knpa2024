//
//  LoginViewController.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 21/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var isGo = false
    
    var nameComponentView : loginComponnentView!
    var numberComponentView : loginComponnentView!
    
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isGo = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let loginTopRightImage = UIImage(named: "loginTopRight")
        let loginTopRightImageView = UIImageView(frame: SCREEN.BOUND)
        
        if IS_IPHONE_N_PLUS {
            loginTopRightImageView.frame.size.width *= 1.2
            loginTopRightImageView.contentMode = .scaleAspectFit
        } else if IS_IPHONE_X {
            loginTopRightImageView.frame.size.width *= 1.1
            loginTopRightImageView.contentMode = .scaleAspectFit
        } else if IS_IPHONE_12PRO_MAX {
            loginTopRightImageView.frame.size.width *= 1.2
            loginTopRightImageView.contentMode = .scaleAspectFit
        } else {
            loginTopRightImageView.frame.size.width *= 1
            loginTopRightImageView.contentMode = .scaleAspectFit
        }
        
        
        //        loginTopRightImageView.frame.size.height *= 0.7
        
        if IS_IPHONE_N_PLUS {
            loginTopRightImageView.frame.origin.y = 60
        } else {
            loginTopRightImageView.frame.origin.y = SCREEN.HEIGHT * 0.15
        }
        loginTopRightImageView.setImageWithFrameHeight(image: loginTopRightImage)
        loginTopRightImageView.frame.size.height *= 0.7
        
        if IS_IPHONE_N_PLUS {
            loginTopRightImageView.frame.origin.x = 20
        } else if IS_IPHONE_X {
            loginTopRightImageView.frame.origin.x = 5
        } else if IS_IPHONE_12PRO_MAX {
            loginTopRightImageView.frame.origin.x = 20
        } else {
            loginTopRightImageView.frame.origin.x = SCREEN.WIDTH - loginTopRightImageView.width + 20
        }
        loginTopRightImageView.frame.size.width = SCREEN.WIDTH - 40
        self.view.addSubview(loginTopRightImageView)
      
        if IS_IPHONE_N_PLUS {
            
            let loginMainTxtImageView = UIImageView(frame: SCREEN.BOUND)
            loginMainTxtImageView.frame.size.width *= 1
            loginMainTxtImageView.contentMode = .scaleAspectFit
            loginMainTxtImageView.setImageWithFrameHeight(image: UIImage(named: "loginMainTitle"))
            loginMainTxtImageView.frame.size.height *= 0.9
            loginMainTxtImageView.frame.origin.x = (SCREEN.WIDTH * 0.05) + 40
            loginMainTxtImageView.center.y = (SCREEN.HEIGHT / 1.4)
            self.view.addSubview(loginMainTxtImageView)
            
        } else if IS_IPHONE_X {
            let loginMainTxtImageView = UIImageView(frame: SCREEN.BOUND)
            loginMainTxtImageView.frame.size.width *= 1
            loginMainTxtImageView.setImageWithFrameHeight(image: UIImage(named: "loginMainTitle"))
            loginMainTxtImageView.frame.size.height *= 1
            loginMainTxtImageView.frame.origin.x = (SCREEN.WIDTH * 0.05) + 20
            loginMainTxtImageView.center.y = (SCREEN.HEIGHT / 1.45)
            self.view.addSubview(loginMainTxtImageView)
        } else if IS_IPHONE_12PRO_MAX {
            let loginMainTxtImageView = UIImageView(frame: SCREEN.BOUND)
            loginMainTxtImageView.frame.size.width *= 1
            loginMainTxtImageView.setImageWithFrameHeight(image: UIImage(named: "loginMainTitle"))
            loginMainTxtImageView.frame.size.height *= 1.3
            loginMainTxtImageView.frame.origin.x = (SCREEN.WIDTH * 0.05) + 20
            loginMainTxtImageView.center.y = (SCREEN.HEIGHT / 1.45)
            self.view.addSubview(loginMainTxtImageView)
        } else {
            let loginMainTxtImageView = UIImageView(frame: SCREEN.BOUND)
            loginMainTxtImageView.frame.size.width *= 1
            loginMainTxtImageView.setImageWithFrameHeight(image: UIImage(named: "loginMainTitle"))
            loginMainTxtImageView.frame.size.height *= 1
            loginMainTxtImageView.frame.origin.x = (SCREEN.WIDTH * 0.05) + 20
            loginMainTxtImageView.center.y = (SCREEN.HEIGHT / 1.4) + 10
            self.view.addSubview(loginMainTxtImageView)
        }
        
        
        let closeButton = ImageButton(
            frame: CGRect(x: SCREEN.WIDTH - (NAVIGATION_BAR_HEIGHT), y: STATUS_BAR_HEIGHT, width: NAVIGATION_BAR_HEIGHT, height: NAVIGATION_BAR_HEIGHT),
            image: UIImage(named: "btnX2")?.withRenderingMode(.alwaysTemplate), ratio: 0.5)
        closeButton.buttonImageView.tintColor = UIColor.black
        closeButton.addTarget(event: UIControl.Event.touchUpInside) { [weak self] (button) in
            
            
            
            self?.dismiss(animated: true, completion: {

            })
        }
        self.view.addSubview(closeButton)
        
//        0.62228261
        
        var loginBox = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH * 0.85, height: 0))

        loginBox.center.x = SCREEN.WIDTH / 2
        self.view.addSubview(loginBox)
        
        nameComponentView = loginComponnentView(frame: CGRect(x: 0, y: 0, width: loginBox.frame.width, height: 100), placeholder: "성함을 입력하여 주세요.", isSecureTextEntry: false)
        nameComponentView.textField.textField.delegate = self
        loginBox.addSubview(nameComponentView)
        
        numberComponentView = loginComponnentView(frame: CGRect(x: 0, y: nameComponentView.frame.maxY + 15, width: loginBox.frame.width, height: 100), placeholder: "면허번호를 입력하여 주세요.", isSecureTextEntry: false)
        numberComponentView.textField.textField.delegate = self
        numberComponentView.textField.textField.keyboardType = .numberPad
        loginBox.addSubview(numberComponentView)
        
        var loginButtonHeight : CGFloat = 60
        if IS_IPHONE_SE {
            loginButtonHeight = 50
        } else if IS_IPHONE_N_PLUS {
            loginButtonHeight = 50
        } else if IS_IPHONE_X {
            loginButtonHeight = 40
        }
        
        let loginButton = UIButton(frame: CGRect(x: 0, y: numberComponentView.frame.maxY + 15, width: loginBox.frame.width, height: loginButtonHeight))
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 23)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = #colorLiteral(red: 0.1460702121, green: 0.111360766, blue: 0.4651629329, alpha: 1)
        //rgb 72 119 45
        loginBox.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        loginBox.frame.size.height = loginButton.frame.maxY
        loginBox.center.y = SCREEN.HEIGHT * 0.6
        if !IS_NORCH {
            loginBox.center.y = SCREEN.HEIGHT * 0.63
        }
        
         
        //loginBottom
        let loginBottomLogoImage = UIImage(named: "loginBottomLogo")
        let loginBottomLogoImageView = UIImageView(frame: SCREEN.BOUND)
        loginBottomLogoImageView.frame.size.width *= 0.4
        loginBottomLogoImageView.contentMode = .scaleAspectFit
        loginBottomLogoImageView.setImageWithFrameHeight(image: loginBottomLogoImage)
        loginBottomLogoImageView.frame.size.height *= 0.7
//        loginBottomLogoImageView.center.x = SCREEN.WIDTH / 2
        if IS_IPHONE_N_PLUS {
            loginBottomLogoImageView.frame.origin.x = 0
        } else if IS_IPHONE_X {
            loginBottomLogoImageView.frame.origin.x = 10
            
        } else if IS_IPHONE_12PRO_MAX {
            loginBottomLogoImageView.frame.origin.x = 20
        } else {
            loginBottomLogoImageView.frame.origin.x = 30
        }
        
        if IS_IPHONE_X {
            loginBottomLogoImageView.frame.origin.y = SCREEN.HEIGHT - loginBottomLogoImageView.height - 75
        } else if IS_IPHONE_15PRO_MAX {
            loginBottomLogoImageView.frame.origin.y = SCREEN.HEIGHT - loginBottomLogoImageView.height - 55
        } else if IS_IPHONE_15PRO {
            loginBottomLogoImageView.frame.origin.y = SCREEN.HEIGHT - loginBottomLogoImageView.height - 55
        } else {
            loginBottomLogoImageView.frame.origin.y = SCREEN.HEIGHT - loginBottomLogoImageView.height - 55
        }
        self.view.addSubview(loginBottomLogoImageView)
    }
    
    @objc func loginButtonPressed(){
        
        if isGo { return }
        isGo = true
        
        if nameComponentView.textField.textField.text == "" {
            appDel.showAlert(title: "안내.", message: "성함을 입력해주세요.")
            return
        }
        
        if numberComponentView.textField.textField.text == "" {
            appDel.showAlert(title: "안내.", message: "면허번호를 입력해주세요.")
            return
        }
        
        //https://ezv.kr:4447/voting/php/login/knpa2019f.php?name=이름&license_number=면허번호
        let license_number = numberComponentView.textField.textField.text!
        let para = [
            "name" : nameComponentView.textField.textField.text!,
            "license_number":license_number,
            "deviceid":deviceID
        ]
//        let urlString = "https://ezv.kr:4447/voting/php/login/knpa2023s.php"
//        let urlString = "http://ezv.kr/voting/php/login/knpa2023f.php"
                let urlString = "https://ezv.kr:4447/voting/php/login/knpa2024s.php"
    
        
        Server.postData(urlString: urlString, method: .get, otherInfo: para, completion: { (kData : Data?) in
            //                    성공 : [{"rows":"1","data":[{"regist_sid":"2486","name":"\uc774\uad11\uc2dd"}]}]
            //                    실패 : [{"rows":"0"}]
            if let data = kData, let dataString = data.toString() {
                print("dataString:\(dataString)")
            }
            if let data = kData {
                if let dataDic = data.toJson() as? [String:Any],
                   let firstData = dataDic["data"] as? [String:Any],
                   let kRegist_sid = firstData["regist_sid"] as? String,
                   let kName = firstData["name"] as? String
                {
                    userD.set(kRegist_sid, forKey: REGIST_ID)
                    userD.set(kName, forKey: NAME_ID)
                    userD.set(license_number, forKey: LICENSE_ID)
                    
                    userD.synchronize()
                    
                    self.dismiss(animated: true, completion: {
                        toastShow(message: "로그인 되었습니다.")
                    })
                    
                    return
                }else{
                    toastShow(message: "성함 또는 면허번호를 확인해주세요.")
                    self.isGo = false
                }
            }
            self.isGo = false
        })
        
    
    }

    class loginComponnentView: UIView {
        
        var textField : CustomTextField!
        
        init(frame: CGRect, placeholder : String, isSecureTextEntry : Bool) {
            super.init(frame: frame)
            
            var textFieldHeight : CGFloat = 60
            if IS_IPHONE_SE {
                textFieldHeight = 50
            } else if IS_IPHONE_N_PLUS {
                textFieldHeight = 50
            } else if IS_IPHONE_X {
                textFieldHeight = 40
            }
            
            let innerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0))
            self.addSubview(innerView)
            
            textField = CustomTextField(frame: CGRect(x: 0, y: 0, width: innerView.frame.size.width, height: textFieldHeight), placeholder: placeholder, isSecureTextEntry: isSecureTextEntry)
            innerView.addSubview(textField)
            
            innerView.frame.size.height = textField.frame.maxY
            
            self.frame.size.height = innerView.frame.maxY
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class CustomTextField: UIButton {
        
        var motherVC : UIViewController?
        
        var textField : UITextField!
        
        private override init(frame: CGRect) {
            super.init(frame:frame)
        }
        
        convenience init(frame : CGRect, placeholder : String = "", isSecureTextEntry : Bool = false) {
            self.init(frame: frame)
            
            
            self.backgroundColor = UIColor.white
            self.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1).cgColor
            self.layer.borderWidth = 0.5
            
            //?/
            
            textField = UITextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width - 30, height: self.frame.size.height))
            textField.center.x = self.frame.size.width / 2
            textField.font = UIFont(name: NotoSansCJKkr_Regular, size: 18)
            textField.textColor = #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2196078431, alpha: 1)
            textField.addDoneCancelToolbar()
            textField.isSecureTextEntry = isSecureTextEntry
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            
            let idTextFieldAttributedPlaceholder : [NSAttributedString.Key : NSObject] = [
                .font : UIFont(name: NotoSansCJKkr_Regular, size: 18)!,
                .foregroundColor : #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2196078431, alpha: 1)
            ]
            textField.attributedPlaceholder = NSMutableAttributedString(stringsInfos: [(placeholder,idTextFieldAttributedPlaceholder)])
            
            self.addSubview(textField)
            
            self.addTarget(event: .touchUpInside) { (button) in self.textField.becomeFirstResponder() }
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
