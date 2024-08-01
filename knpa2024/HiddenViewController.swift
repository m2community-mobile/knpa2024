import UIKit

func goHiddenVC(popAnimation : Bool = false, pushAnimation : Bool = true){
    let vc = HiddenViewController()
    
    appDel.leftView?.close()
    appDel.topVC?.present(vc, animated: true, completion: {})
    
}
class HiddenViewController: UIViewController {
    
    let hiddenVC_MainColor = #colorLiteral(red: 0.1697613895, green: 0.2778494358, blue: 0.7842060924, alpha: 1)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: STATUS_BAR_HEIGHT))
        statusBar.backgroundColor = hiddenVC_MainColor
        self.view.addSubview(statusBar)
        
        let naviBar = UIView(frame: CGRect(x: 0, y: statusBar.frame.maxY, width: SCREEN.WIDTH, height: NAVIGATION_BAR_HEIGHT))
        naviBar.backgroundColor = hiddenVC_MainColor
        self.view.addSubview(naviBar)
        
        
        
        let closeButton = UIButton(frame: CGRect(x: SCREEN.WIDTH - naviBar.frame.size.height, y: 0, width: naviBar.frame.size.height, height: naviBar.frame.size.height))
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.setTitle("닫기", for: .normal)
        closeButton.addTarget(event: .touchUpInside) { (button) in
            self.dismiss(animated: true) { }
        }
        closeButton.titleLabel?.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 17.5)
        if IS_IPHONE_SE {
            closeButton.titleLabel?.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 15)
        }
        naviBar.addSubview(closeButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: naviBar.frame.size.height))
        titleLabel.text = "정보"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 17.5)
        if IS_IPHONE_SE {
            titleLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 15)
        }
        titleLabel.textAlignment = .center
        naviBar.addSubview(titleLabel)
        
        self.view.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        
        let separatorView1 = UIView(frame: CGRect(x: 0, y: naviBar.frame.maxY, width: SCREEN.WIDTH, height: 1))
        separatorView1.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        self.view.addSubview(separatorView1)
        
//        let codeView = InfoView(title: "code", value: code, tintColor: hiddenVC_MainColor)
//        codeView.frame.origin.y = separatorView1.frame.maxY
//        self.view.addSubview(codeView)
        
        let deviceIDView = InfoView(title: "deviceID", value: deviceID, tintColor: hiddenVC_MainColor)
        deviceIDView.frame.origin.y = separatorView1.frame.maxY
        self.view.addSubview(deviceIDView)
        
        let tokenView = InfoView(title: "token", value: token_id, tintColor: hiddenVC_MainColor)
        tokenView.frame.origin.y = deviceIDView.frame.maxY
        self.view.addSubview(tokenView)
        
        
        
        
        //
        let hiddenView = UIView(frame: CGRect(x: 0, y: 0, width: tokenView.valueLabel!.width, height: tokenView.valueLabel!.height))
        hiddenView.center = tokenView.valueLabel!.center
//        hiddenView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        tokenView.addSubview(hiddenView)
        
        let hiddenGesture = UITapGestureRecognizer(target: self, action: #selector(crashTestFunc))
        hiddenGesture.numberOfTapsRequired = 10
        hiddenView.addGestureRecognizer(hiddenGesture)
        
    }
    
    @objc func crashTestFunc(){
        print("crashTestFunc")
        let values = ["A"]
        print(values[3])
    }
    
    class InfoView: UIView {
        
        var valueLabel : UILabel?
        
        init(title titleString : String, value valueString: String, tintColor : UIColor) {
            super.init(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: 70))
            self.backgroundColor = UIColor.white
            
            let copyButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
            copyButton.frame.origin.x = self.frame.size.width - copyButton.frame.size.width - 15
            copyButton.layer.borderColor = #colorLiteral(red: 0.1215686275, green: 0.1960784314, blue: 0.5568627451, alpha: 1).cgColor
            copyButton.layer.borderWidth = 1
            copyButton.setTitle("Copy", for: .normal)
            copyButton.setTitleColor(tintColor, for: .normal)
            self.addSubview(copyButton)
            
            copyButton.addTarget(event: .touchUpInside) { (button) in
                UIPasteboard.general.string = valueString
                toastShow(message: "복사되었습니다.")
            }
            
            ////////////////////////////
            
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 15, width: copyButton.frame.minX - 10, height: 100))
            titleLabel.text = titleString
            titleLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 15)
            titleLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            titleLabel.sizeToFit()
            self.addSubview(titleLabel)
            
            valueLabel = UILabel(frame: CGRect(x: 10, y: titleLabel.frame.maxY + 5, width: copyButton.frame.minX - 20, height: 500))
            valueLabel?.text = valueString
            valueLabel?.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 18)
            valueLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            valueLabel?.numberOfLines = 0
            valueLabel?.sizeToFit()
            self.addSubview(valueLabel!)
            
            ////////////////////////////
            self.frame.size.height = valueLabel!.frame.maxY + 16
            copyButton.center.y = self.frame.size.height / 2

            let separatorView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
            separatorView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
            self.addSubview(separatorView)
            
            
        
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
    

}

