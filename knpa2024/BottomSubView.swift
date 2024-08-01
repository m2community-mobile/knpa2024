
import UIKit

protocol BottomSubPopUpViewDelegate {
    func bottomSubViewButtonPressed( index : Int )
}


class BottomSubView: UIView {

    var popUpView : PopUpView!
    var closeButton : BottomSubViewCloseButton!
    var programButton : BottomIconButton!
    var bottomProgramButton : BottomIconButton?
    var flipView : UIView!
    
    init(delegate kDelegate : BottomSubPopUpViewDelegate, programButton kProgramButton : BottomIconButton) {
        super.init(frame: SCREEN.BOUND)
        
        bottomProgramButton = kProgramButton
        
//        let grayView = UIView(frame: self.bounds)
//        grayView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7)
//        self.addSubview(grayView)
        
        let grayCloseButton = UIButton(frame: self.bounds)
        self.addSubview(grayCloseButton)
        grayCloseButton.addTarget(event: .touchUpInside) { (button) in
            self.close{}
        }
        
        popUpView = PopUpView(delegate: kDelegate)
        popUpView.alpha = 0
        self.addSubview(popUpView)

        
        
        let closeButtonWidth = SCREEN.WIDTH / 5
        let closeButtonX = SCREEN.WIDTH / 5
        let closeButtonY = SCREEN.HEIGHT - SAFE_AREA - BottomViewInnerViewSizeHeight
        
        flipView = UIView(frame: CGRect(x: closeButtonX, y: closeButtonY, width: closeButtonWidth, height: BottomViewInnerViewSizeHeight))
//        flipView.backgroundColor = UIColor.black
        self.addSubview(flipView)
        
        self.closeButton = BottomSubViewCloseButton(frame: CGRect(x: 0, y: 0, width: closeButtonWidth, height: BottomViewInnerViewSizeHeight))
//        self.flipView.addSubview(self.closeButton)

        self.closeButton.actionButton.addTarget(event: .touchUpInside) { (button) in
            self.close{}
        }

        programButton = BottomIconButton(frame: CGRect(x: 0, y: 0, width: closeButtonWidth, height: BottomViewInnerViewSizeHeight), name: "프로그램", imageName: "footIco2")
//        programButton.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        flipView.addSubview(programButton)


//        closeButton.imageView.transform = CGAffineTransform.identity.rotated(by: (2 * CGFloat.pi) * (45 / 360))
        
        
    }
    
    func open(){
        
        print("open")
        
        
        self.bottomProgramButton?.isHidden = true
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { (timer) in
//        DispatchQueue.main.async {
            UIView.transition(with: self.flipView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                self.programButton.removeFromSuperview()
                self.flipView.addSubview(self.closeButton)
                self.popUpView.alpha = 1
            }) { (fi) in
                
            }
        }
        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.closeButton.imageView.transform = CGAffineTransform.identity.rotated(by: (2 * CGFloat.pi) * (0 / 360))
//        }) { (fi) in
//
//        }

        
        
        
    }
    
    func close(complete:@escaping() -> Void){
        DispatchQueue.main.async {
            UIView.transition(with: self.flipView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                self.closeButton.removeFromSuperview()
                self.flipView.addSubview(self.programButton)
                self.popUpView.alpha = 0
            }) { (fi) in
                self.removeFromSuperview()
                self.bottomProgramButton?.isHidden = false
                complete()
            }
        }
        
        //        UIView.animate(withDuration: 0.3, animations: {
//            self.closeButton.imageView.transform = CGAffineTransform.identity.rotated(by: (2 * CGFloat.pi) * (45 / 360))
//            self.alpha = 0
//        }) { (fi) in
//            self.removeFromSuperview()
//        }
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class BottomSubViewCloseButton: UIView {
        var actionButton : UIButton!
        var imageView : UIImageView!
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.2431372549, blue: 0.4549019608, alpha: 1)
            
            let imageRatio : CGFloat = 0.3
            let imageSize = min(self.frame.size.width, self.frame.size.height)
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize * imageRatio, height: imageSize * imageRatio))
            imageView.image = UIImage(named: "BottomSubViewCloseImage")
            imageView.center = self.frame.center
            self.addSubview(imageView)
            
            self.actionButton = UIButton(frame: self.bounds)
            self.addSubview(actionButton)
            
//            self.imageView.alpha = 0
        }

        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class PopUpView: UIView {
        
        
        let titles = [
            "4월 18일(목)",
            "4월 19일(금)",
            "Program at a Glance",
            
        ]
        
        var delegate : BottomSubPopUpViewDelegate?
        
        init(delegate kDelegate : BottomSubPopUpViewDelegate) {
            super.init(frame: SCREEN.BOUND)
            
//            self.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.2431372549, blue: 0.4549019608, alpha: 1)
            
            self.clipsToBounds = true
            
            self.delegate = kDelegate
            
            self.frame.size.width = SCREEN.WIDTH * 0.65
//            if IS_IPHONE_SE {
//                self.frame.size.width = SCREEN.WIDTH * 0.6
//            }
            
            let innerView = UIView(frame: self.bounds)
//            innerView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1607843137, blue: 0.2509803922, alpha: 0.95)
            innerView.backgroundColor =  #colorLiteral(red: 0.274779439, green: 0.294846952, blue: 0.3334107399, alpha: 1)
            self.addSubview(innerView)
            
            var contentViewHeight : CGFloat = 45
            if IS_IPHONE_SE {
                contentViewHeight = 40
            }
            innerView.clipsToBounds = true
            innerView.layer.cornerRadius = 10
            
            for i in 0..<titles.count {
                let contentView = ContentView(
                    frame: CGRect(x: 30, y: 10 + CGFloat(i) * contentViewHeight, width: self.frame.size.width - 15, height: contentViewHeight), title: titles[i])
                contentView.actionButton.addTarget(event: .touchUpInside) { (button) in
                    self.delegate?.bottomSubViewButtonPressed(index: i)
                }
                innerView.addSubview(contentView)
            }
            
            innerView.frame.size.height = (contentViewHeight * CGFloat(titles.count)) + 10 + 10
            
            
            let triangleHeight : CGFloat = 15
            let triangleWidth : CGFloat = 30
            let triangleCenterX : CGFloat = (SCREEN.WIDTH / 5 / 2)
            let triangleLayer = CAShapeLayer()
            triangleLayer.lineCap = CAShapeLayerLineCap.round
            triangleLayer.lineJoin = CAShapeLayerLineJoin.round
            triangleLayer.fillColor = innerView.backgroundColor!.cgColor
            triangleLayer.lineWidth = 0
            triangleLayer.strokeColor = UIColor.clear.cgColor
            //            triangleLayer.lineDashPattern = [1,7]
            self.layer.addSublayer(triangleLayer)

            let trianglePath = UIBezierPath()
            trianglePath.move(to: CGPoint(x: triangleCenterX - (triangleWidth / 2), y: innerView.frame.size.height))
            trianglePath.addLine(to: CGPoint(x: triangleCenterX + (triangleWidth / 2), y: innerView.frame.size.height))
            trianglePath.addLine(to: CGPoint(x: triangleCenterX, y: innerView.frame.size.height + triangleHeight))
            trianglePath.addLine(to: CGPoint(x: triangleCenterX - (triangleWidth / 2), y: innerView.frame.size.height))
            triangleLayer.path = trianglePath.cgPath
            
            self.frame.size.height = innerView.frame.size.height + triangleHeight * 2
            
            self.frame.origin.x = SCREEN.WIDTH / 5
            self.frame.origin.y = SCREEN.HEIGHT - SAFE_AREA - BottomViewInnerViewSizeHeight - self.frame.size.height
            
            
//            self.setCornerRadius(cornerRadius: 10, byRoundingCorners: [.topLeft,.topRight])
            
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        class ContentView: UIView {
            
            var actionButton : UIButton!
            
            var fontSize : CGFloat {
                return IS_IPHONE_SE ? 13 : 16
            }
            lazy var dotSize : CGFloat = self.fontSize + 2
            
            init(frame: CGRect, title : String) {
                super.init(frame: frame)
                
                let label = UILabel(frame: self.bounds)
                label.text = "- \(title)"
//                label.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 16)
//                if IS_IPHONE_SE {
//                    label.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 13)
//                }
//                label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    
                label.attributedText = NSMutableAttributedString(
                    stringsInfos:
                        [("· ",[
                            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8941176471, blue: 0, alpha: 1),
                            NSAttributedString.Key.font: UIFont(name: NotoSansCJKkr_Bold, size: dotSize)!]),
                         (title,[
                            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                            NSAttributedString.Key.font: UIFont(name: NotoSansCJKkr_Regular, size: fontSize)!])
                        ])
                
                label.sizeToFit()
                label.center.y = self.frame.size.height / 2
                self.addSubview(label)
                
                actionButton = UIButton(frame: self.bounds)
                self.addSubview(actionButton)
                
            }
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
    }
}
