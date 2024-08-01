import UIKit
import UserNotifications

let settingVCBackgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
let settingVCContentBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let settingVCSeparatorColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)

let baseViewControllerColor1 = #colorLiteral(red: 0.1215686275, green: 0.1960784314, blue: 0.5568627451, alpha: 1)

class SettingViewController: BaseViewController {
    
    var pushSettingView : ViewSwitchType!
    
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subTitleLabel.text = "설정"
        
        self.view.backgroundColor = settingVCBackgroundColor
        
        let separatorView1 = UIView(frame: CGRect(x: 0, y: self.subTitleView.frame.maxY, width: SCREEN.WIDTH, height: 1))
        separatorView1.backgroundColor = settingVCSeparatorColor
        self.view.addSubview(separatorView1)
        
        ////
        var viewTextTypeFontSize : CGFloat = 17
        if IS_IPHONE_X {
            viewTextTypeFontSize = 16
        }
        if IS_IPHONE_N_PLUS {
            viewTextTypeFontSize = 16
        }
        if IS_IPHONE_N {
            viewTextTypeFontSize = 16
        }
        if IS_IPHONE_SE {
            viewTextTypeFontSize = 16
        }
        ////
        let noticeView1Text = "모바일 앱 Push알림을 통해 대한신경정신의학회 APP 행사정보 및 실시간 Push알림을 받아 보실 수 있습니다."
        var noticeView2Text = "IOS사용자는 PUSH알림이 오지 않을 경우 아이폰 > 설정> 알림> 대한신경정신의학회 APP알림 허용을 “ON”으로 변경해 주십시오"
        
        let noticeView1 = ViewTextType(frame: CGRect(x: 0, y: separatorView1.frame.maxY, width: SCREEN.WIDTH, height: 300), text: noticeView1Text, fontSize: viewTextTypeFontSize)
        self.view.addSubview(noticeView1)
        
        let separatorView2 = UIView(frame: CGRect(x: 0, y: noticeView1.frame.maxY, width: SCREEN.WIDTH, height: 1))
        separatorView2.backgroundColor = settingVCSeparatorColor
        self.view.addSubview(separatorView2)
        
        pushSettingView = ViewSwitchType(itemName: "PUSH", tintColor:baseViewControllerColor1)
        pushSettingView.frame.origin.y = separatorView2.frame.maxY
        pushSettingView.backgroundColor = settingVCContentBackgroundColor
        pushSettingView.onOffButton.addTarget(self, action: #selector(pushChange), for: .valueChanged)
        self.view.addSubview(pushSettingView)
        
        let separatorView3 = UIView(frame: CGRect(x: 0, y: pushSettingView.frame.maxY, width: SCREEN.WIDTH, height: 1))
        separatorView3.backgroundColor = settingVCSeparatorColor
        self.view.addSubview(separatorView3)
        
        
        let noticeView2 = ViewTextType(frame: CGRect(x: 0, y: separatorView3.frame.maxY, width: SCREEN.WIDTH, height: 500), text: noticeView2Text, fontSize: viewTextTypeFontSize)
        self.view.addSubview(noticeView2)
        
        let separatorView4 = UIView(frame: CGRect(x: 0, y: noticeView2.frame.maxY, width: SCREEN.WIDTH, height: 1))
        separatorView4.backgroundColor = settingVCSeparatorColor
        self.view.addSubview(separatorView4)
        
        let appVersionView = ViewAppVersionType(itemName: "App Version", tintColor: baseViewControllerColor1)
        appVersionView.frame.origin.y = separatorView4.frame.maxY
        self.view.addSubview(appVersionView)
        
        let separatorView5 = UIView(frame: CGRect(x: 0, y: appVersionView.frame.maxY, width: SCREEN.WIDTH, height: 1))
        separatorView5.backgroundColor = settingVCSeparatorColor
        self.view.addSubview(separatorView5)
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { (noti : Notification) in
            self.pushInfoUpdate()
        }
        
        let hiddenView = UIView(frame: CGRect(x: 0, y: 0, width: appVersionView.currentVersionLabel.frame.size.width, height: appVersionView.frame.size.height))
        hiddenView.center = appVersionView.currentVersionLabel.center
//        hiddenView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        appVersionView.addSubview(hiddenView)
        
        let hiddenGesture = UITapGestureRecognizer(target: self, action: #selector(hiddenGestureFunc))
        hiddenGesture.numberOfTapsRequired = 10
        hiddenView.addGestureRecognizer(hiddenGesture)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
      }
    
    @objc func hiddenGestureFunc(){
        print("hiddenGestureFunc")
        goHiddenVC()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pushInfoUpdate()
    }
    
    @objc func pushChange(){
        
        NotiCenter.shared.notiCenter.getNotificationSettings { (settings : UNNotificationSettings) in
            
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    let value = self.pushSettingView.onOffButton.isOn ? "Y":"N"
                    print("newValue : \(value)")
                    
                    Server.postData(urlString: "https://ezv.kr:4447/voting/php/bbs/set_push.php?code=\(code)&val=\(value)&deviceid=\(deviceID)") { (kData : Data?) in
                        if let data = kData {
                            print("pushChange : \(data.toString())")
                            self.pushInfoUpdate()
                        }else{
                            DispatchQueue.main.async {
                                toastShow(message: "통신이 원활하지 않습니다.\n잠시 후 다시 시도해주세요.")
                                self.pushSettingView.onOffButton.isOn = false
                            }
                        }
                        
                    }
                }
            }else{
                //안내
                DispatchQueue.main.async {
                    self.pushSettingView.onOffButton.isOn = false
                }
                let alertCon = UIAlertController(title: "알림 설정", message: "Push 알림이 꺼져있습니다.\n설정에서 Push 알림을 켜주세요.", preferredStyle: UIAlertController.Style.alert)
                alertCon.addAction(UIAlertAction(title: "닫기", style: .default, handler: { (action) in
                    
                }))
                alertCon.addAction(UIAlertAction(title: "설정하기", style: .default, handler: { (action) in
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: { (fi) in
                            
                        })
                    }
                }))
                
                DispatchQueue.main.async {
                    appDel.topVC?.present(alertCon, animated: true, completion: {
                        
                    })
                }
            }
        }
        
        
        
    }
    
    func pushInfoUpdate(){
        
        NotiCenter.shared.notiCenter.getNotificationSettings { (settings : UNNotificationSettings) in
            print("settings : \(settings)")
            if settings.authorizationStatus == .authorized {
                print("허용됨")
                
                NotiCenter.shared.authorizationCheck()
                
                
                let urlString = "https://ezv.kr:4447/voting/php/bbs/get_push.php?code=\(code)&deviceid=\(deviceID)"
                Server.postData(urlString: urlString, otherInfo: [:]) { (kData : Data?) in
                    if let data = kData {
                        if let dataString = data.toString() {
                            print("pushInfoUpdate:\(dataString)")
                            self.pushSettingView.onOffButton.isOn = dataString == "Y"
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            toastShow(message: "통신이 원활하지 않습니다.\n잠시 후 다시 시도해주세요.")
                            self.pushSettingView.onOffButton.isOn = false
                        }
                    }
                }
            }else{
                print("허용안됨")
                DispatchQueue.main.async {
                    self.pushSettingView.onOffButton.isOn = false
                    
                }
            }
        }
    }
    
}

class ViewTextType: UIView {
    
    //    var textLabel : KRWordWrapLabel!
    var textLabel : UILabel!
    
    
    init(frame: CGRect, text : String, fontSize : CGFloat) {
        super.init(frame: frame)
        
        textLabel = UILabel(frame: self.bounds)
        textLabel.frame.size.width -= 40
        textLabel.numberOfLines = 0
        textLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 17)!
        textLabel.textColor = UIColor.black
        textLabel.text = text
        self.addSubview(textLabel)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .justified
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        textLabel.attributedText = NSAttributedString(string: text, attributes:
            [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3882352941, green: 0.3882352941, blue: 0.3882352941, alpha: 1),
             NSAttributedString.Key.font : UIFont(name: Nanum_Barun_Gothic_OTF, size: fontSize)!,
             NSAttributedString.Key.paragraphStyle:paragraphStyle])
        
        textLabel.sizeToFit()
        textLabel.frame.size.width = self.bounds.size.width - 40
        self.frame.size.height = textLabel.frame.size.height + 40
        textLabel.center = self.frame.center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewSwitchType: UIView {
    
    var isOn : Bool = false {
        willSet(newIsOn){
            self.onOffButton.isOn = isOn
        }
    }
    
    var onOffButton : UISwitch!
    
    init(itemName : String, tintColor : UIColor) {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: 50))
        self.backgroundColor = UIColor.white
        
        let itemLabel = UILabel(frame: CGRect(x: 20, y: 0, width: SCREEN.WIDTH - 20, height: self.frame.size.height))
        itemLabel.text = itemName
        itemLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 15)
        itemLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.addSubview(itemLabel)
        
        onOffButton = UISwitch(frame: CGRect(x: SCREEN.WIDTH - 40 - 30, y: 0, width: 40, height: 30))
        onOffButton.center.y = self.frame.size.height / 2
        onOffButton.onTintColor = tintColor
        self.addSubview(onOffButton)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

class ViewAppVersionType: UIView {
    
    var isOn : Bool = false {
        willSet(newIsOn){
            self.onOffButton.isOn = isOn
        }
    }
    var onOffButton : UISwitch!
    
    var currentVersionLabel : UILabel!
    
    init(itemName : String, tintColor : UIColor) {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: 50))
        self.backgroundColor = UIColor.white
        
        let itemLabel = UILabel(frame: CGRect(x: 20, y: 0, width: SCREEN.WIDTH - 20, height: self.frame.size.height))
        itemLabel.text = itemName
        itemLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 15)
        itemLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.addSubview(itemLabel)
        
        currentVersionLabel = UILabel(frame: CGRect(x: SCREEN.WIDTH - 50 - 20, y: 0, width: 100, height: 30))
        currentVersionLabel.center.y = self.frame.size.height / 2
        currentVersionLabel.textColor = tintColor
        currentVersionLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 15)
        self.addSubview(currentVersionLabel)
        
        
        let infoDic = Bundle.main.infoDictionary
        if let versionString = infoDic!["CFBundleShortVersionString"] as? String {
            currentVersionLabel.text = "V \(versionString)"
        }
        
        currentVersionLabel.sizeToFit()
        currentVersionLabel.center.y = self.frame.size.height / 2
        currentVersionLabel.frame.origin.x = SCREEN.WIDTH - currentVersionLabel.frame.size.width - 15
        
        let updateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        updateButton.frame.origin.x = currentVersionLabel.frame.minX - updateButton.frame.size.width - 15
        updateButton.center.y = self.frame.size.height / 2
        updateButton.layer.borderColor = baseViewControllerColor1.cgColor
        updateButton.layer.borderWidth = 1
        updateButton.setTitle("Loding..", for: .normal)
        updateButton.setTitleColor(tintColor, for: .normal)
        self.addSubview(updateButton)
        
        newVersionCheck { (isNew : Bool, urlString : String?) in
            if isNew, let downLoadUrlStirng = urlString {
                updateButton.setTitle("Update", for: .normal)
                
                updateButton.setTarget(event: .touchUpInside, buttonAction: { (button) in
                    if let url = URL(string: downLoadUrlStirng) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: { (fi) in })
                        }
                    }
                })
            }else{
                updateButton.setTitle("Latest", for: .normal)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
