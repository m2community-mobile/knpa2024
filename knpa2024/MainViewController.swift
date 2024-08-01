//
//  ViewController.swift
//  knpa2021f
//
//  Created by JinGu's iMac on 2021/09/29.
//

import UIKit
import FontAwesome_swift
import Alamofire

class MainViewController: UIViewController {
    
    var allBackView : UIView!
    
    var bottomView : BottomView!
    var mainButtonBackView : UIView!
    var mainButtonBackView2 : UIView!

    var noticeView : LatestNoticeView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let isOpen = appDel.leftView?.isOpen, isOpen {
            return .lightContent
        }else{
            return .default
        }
    }
    
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.noticeView.noticeUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        versionCheck()
        
        self.view.backgroundColor = UIColor.white
        
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: STATUS_BAR_HEIGHT))
        self.view.addSubview(statusBar)
        
        let naviBar = UIView(frame: CGRect(x: 0, y: statusBar.frame.maxY, width: SCREEN.WIDTH, height: NAVIGATION_BAR_HEIGHT))
        self.view.addSubview(naviBar)
                
        let menuButton = ImageButton(frame: CGRect(x: 5, y: 0, width: NAVIGATION_BAR_HEIGHT, height: NAVIGATION_BAR_HEIGHT), image: UIImage(named: "menu"), ratio: 0.5)
        menuButton.addTarget(event: .touchUpInside) { (button) in
            appDel.leftView?.open(currentVC: self)
            
            
        }
        naviBar.addSubview(menuButton)

        
        allBackView = UIView(frame: CGRect(x: 0, y: naviBar.maxY, width: SCREEN.WIDTH, height: 255))
        allBackView.backgroundColor = .white
        self.view.addSubview(allBackView)
        
//        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: naviBar.frame.size.height * 0.6))
//        logoImageView.setImageWithFrameWidth(image: UIImage(named: "topLogo"))
//        logoImageView.frame.size.width = naviBar.frame.width / 4
//        
//        logoImageView.center.y = naviBar.frame.size.height / 2
//        logoImageView.frame.origin.x = SCREEN.WIDTH - logoImageView.frame.size.width - (SCREEN.WIDTH * (20.5/360))
//        naviBar.addSubview(logoImageView)
        
        bottomView = BottomView()
        self.view.addSubview(bottomView)
        
        let mainButtonBackViewHeight : CGFloat = (SCREEN.HEIGHT - bottomView.frame.size.height) * 0.5
        mainButtonBackView = UIView(frame: CGRect(x: 0, y: SCREEN.HEIGHT - mainButtonBackViewHeight - bottomView.frame.height - 40, width: SCREEN.WIDTH, height: mainButtonBackViewHeight))
        mainButtonBackView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.view.addSubview(mainButtonBackView)
        
        mainButtonBackView2 = UIView(frame: mainButtonBackView.bounds)
                mainButtonBackView2.frame.size.width *= 0.9
        mainButtonBackView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mainButtonBackView2.center = mainButtonBackView.frame.center
        mainButtonBackView.addSubview(mainButtonBackView2)
        
        //2020.05.11
        let gap : CGFloat = 10
        mainButtonBackView.frame.origin.y -= gap * 2
        mainButtonBackView.frame.size.height += gap * 2
        mainButtonBackView2.center = mainButtonBackView.frame.center
        
        let buttonWidthGap : CGFloat = 10
        let buttonHeightGap : CGFloat = 10
        let buttonWidth : CGFloat = (mainButtonBackView2.frame.size.width - (buttonWidthGap * 2)) / 3
        let buttonHeight : CGFloat = (mainButtonBackView2.frame.size.height - (buttonHeightGap * 4)) / 3
        for i in 0..<9{
            let buttonX : CGFloat = (buttonWidth + buttonWidthGap) * CGFloat(i % 3)
            let buttonY : CGFloat = (buttonHeight + buttonHeightGap) * CGFloat(i / 3) + 10
                    
            let titleString = INFO.MAIN_INFO[i][INFO.KEY.TITLE] ?? ""
            
            var button = MainButton(frame: CGRect(
                x: buttonX + 20,
                y: buttonY,
                width: buttonWidth * 0.65,
                height: buttonHeight * 0.65), imageName: "ico\(i+1)", name: titleString)
            
            if IS_IPHONE_N_PLUS {
                button = MainButton(frame: CGRect(x: buttonX + 20,
                                                  y: buttonY,
                                                  width: (buttonWidth - 10) * 0.65,
                                                  height: buttonHeight * 0.65), imageName: "ico\(i+1)", name: titleString)
            }
            
            button.backgroundColor = #colorLiteral(red: 0.9549385905, green: 0.9649967551, blue: 0.9691624045, alpha: 1)
            button.layer.cornerRadius = button.frame.size.width * 0.5
            button.addTarget(event: .touchUpInside) { (button) in
                let infoDic = INFO.MAIN_INFO[i]
                contentShow(dataDic: infoDic as [String:Any])
                
                
             
                
                
//                switch i {
//                case 0:
//                    
//                    break
//                case 1:
//                    if !isLogin {
//                        showLoginAlert()
//                        
////
//                       
//                        return
//                    } else {
//                        
//                        
//                    
//                        return
//                    }
//                    
////                    goPAG()//popAnimation: false, pushAnimation: false)
//
//                    break
//                case 2:
//                    
//                    
//                    if !isLogin {
//                        showLoginAlert()
//
//                       
//                        return
//                    }
//                    
////                    goURL(urlString: INFO.KEY.IS_REQUIRED_LOGIN)//, popAnimation: false, pushAnimation: false)
//                    
//                    break
//                case 3:
//
//                    if !isLogin {
//                        showLoginAlert()
//
//                       
//                        return
//                    }
////                    goURL(urlString: URL_KEY.search)//, popAnimation: false, pushAnimation: false)
//                    break
//                case 4:
//                    
//                    if !isLogin {
//                        showLoginAlert()
//
//                       
//                        return
//                    }
////                    goURL(urlString: URL_KEY.mySchedule)//, popAnimation: false, pushAnimation: false)
//                    break
//                case 5:
//                    if !isLogin {
//                        showLoginAlert()
//
//                       
//                        return
//                    }
//                    break
//                case 6:
//                    
//                    break
//                case 7:
//                    
//                    break
//                case 8:
//                    
//                    break
//               
//                default:
//                    break
//                }
                
                
                
            }
            mainButtonBackView2.addSubview(button)
            
            
               
            
            
            
            
        }
        
        var noticeViewHeight : CGFloat = 50
        if IS_IPHONE_N_PLUS { noticeViewHeight = 45 }
        if IS_IPHONE_N { noticeViewHeight = 40 }
        if IS_IPHONE_SE { noticeViewHeight = 35 }
        
        noticeView = LatestNoticeView(frame: CGRect(x: 0, y: bottomView.frame.minY - noticeViewHeight + 1, width: SCREEN.WIDTH, height: noticeViewHeight))
        
        self.view.addSubview(noticeView)
        
        
//        let mainTopView = UIView(frame: CGRect(x: 0, y: naviBar.maxY, width: SCREEN.WIDTH, height: noticeView.minY - naviBar.maxY))
//        self.view.addSubview(mainTopView)
//
//        let mainSymboleImageView = UIImageView(frame: mainTopView.bounds)
//
//        mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "mainSymbol"))
//        mainSymboleImageView.frame.origin.x = SCREEN.WIDTH - mainSymboleImageView.width + 15
//        mainSymboleImageView.frame.size.height *= 1.15
//
//        mainTopView.addSubview(mainSymboleImageView)
//
//        let mainTitleImageView = UIImageView(frame: mainTopView.bounds)
//        mainTitleImageView.setImageWithFrameWidth(image: UIImage(named: "mainTitle"))
//        mainTitleImageView.frame.size.height *= 0.8
//        mainTitleImageView.frame.size.width  *= 0.64
//        mainTitleImageView.frame.origin.x = SCREEN.WIDTH * 0.034
//
//        mainTitleImageView.center.y = mainTopView.height / 2 + 10
//        mainTopView.addSubview(mainTitleImageView)
        
        
        if IS_IPHONE_X {
            let mainTopView = UIView(frame: CGRect(x: -23, y: 10, width: SCREEN.WIDTH, height: noticeView.minY - naviBar.maxY - mainButtonBackView.frame.height))
            
            allBackView.addSubview(mainTopView)
            
            let mainSymboleImageView = UIImageView(frame: CGRect(x: 20, y: -30, width: SCREEN.WIDTH, height: noticeView.minY - naviBar.maxY - mainButtonBackView.frame.height))
            
//            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "mainSymbol"))
            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "main2024"))
//            mainSymboleImageView.frame.origin.x = SCREEN.WIDTH - mainSymboleImageView.width
//            mainSymboleImageView.frame.origin.x = SCREEN.WIDTH - mainSymboleImageView.width
            
            mainSymboleImageView.frame.size.width  *= 1.275
            mainSymboleImageView.frame.size.height *= 1.2
            
            mainTopView.addSubview(mainSymboleImageView)
            
            
            let mainTitleImageView = UIImageView(frame: mainTopView.bounds)
            mainTitleImageView.setImageWithFrameWidth(image: UIImage(named: "mainTitle"))
            mainTitleImageView.frame.size.height *= 0.8
            mainTitleImageView.frame.size.width  *= 0.8
            mainTitleImageView.frame.origin.x = SCREEN.WIDTH * 0.034
            
            mainTitleImageView.center.y = mainTopView.height / 2
//            mainTopView.addSubview(mainTitleImageView)
            
            let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: naviBar.frame.size.height * 0.6))
            logoImageView.setImageWithFrameWidth(image: UIImage(named: "topLogo"))
            logoImageView.frame.size.width = naviBar.frame.width / 4
            
            logoImageView.center.y = naviBar.frame.size.height / 2
            logoImageView.frame.origin.x = SCREEN.WIDTH - logoImageView.frame.size.width - (SCREEN.WIDTH * (20.5/360)) + 5
            naviBar.addSubview(logoImageView)
        } else if IS_IPHONE_N {
            let mainTopView = UIView(frame: CGRect(x: 0, y: -30, width: SCREEN.WIDTH, height: noticeView.minY - naviBar.maxY - mainButtonBackView.frame.height))
            allBackView.addSubview(mainTopView)
            
            let mainSymboleImageView = UIImageView(frame: mainTopView.bounds)
            
//            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "mainSymbol"))
            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "main2024"))
            mainSymboleImageView.frame.origin.x = SCREEN.WIDTH - mainSymboleImageView.width - 100
            mainSymboleImageView.frame.size.height *= 1.2
            mainSymboleImageView.frame.size.width *= 1.36
            
            mainTopView.addSubview(mainSymboleImageView)
            
            let mainTitleImageView = UIImageView(frame: mainTopView.bounds)
            mainTitleImageView.setImageWithFrameWidth(image: UIImage(named: "mainTitle"))
            mainTitleImageView.frame.size.height *= 1
            mainTitleImageView.frame.size.width  *= 1
            mainTitleImageView.frame.origin.x = SCREEN.WIDTH
            
            mainTitleImageView.center.y = mainTopView.height / 2
//            mainTopView.addSubview(mainTitleImageView)
            
            let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: naviBar.frame.size.height * 0.6))
            logoImageView.setImageWithFrameWidth(image: UIImage(named: "topLogo"))
            logoImageView.frame.size.width = naviBar.frame.width / 4
            
            logoImageView.center.y = naviBar.frame.size.height / 2
            logoImageView.frame.origin.x = SCREEN.WIDTH - logoImageView.frame.size.width - (SCREEN.WIDTH * (20.5/360)) + 5
            mainTopView.addSubview(logoImageView)
        } else if IS_IPHONE_SE {
            
            let mainTopView = UIView(frame: CGRect(x: 0, y: 10, width: SCREEN.WIDTH, height: noticeView.minY - naviBar.maxY - mainButtonBackView.frame.height))
            allBackView.addSubview(mainTopView)
            
            let mainSymboleImageView = UIImageView(frame: mainTopView.bounds)
            
//            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "mainSymbol"))
            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "main2024"))
            mainSymboleImageView.frame.origin.x = SCREEN.WIDTH - mainSymboleImageView.width + 15
            mainSymboleImageView.frame.size.height *= 1
            
            mainTopView.addSubview(mainSymboleImageView)
            
            let mainTitleImageView = UIImageView(frame: mainTopView.bounds)
            mainTitleImageView.setImageWithFrameWidth(image: UIImage(named: "mainTitle"))
            mainTitleImageView.frame.size.height *= 0.8
            mainTitleImageView.frame.size.width  *= 0.8
            mainTitleImageView.frame.origin.x = SCREEN.WIDTH * 0.034
        
            
            mainTitleImageView.center.y = mainTopView.height / 2
//            mainTopView.addSubview(mainTitleImageView)
            let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: naviBar.frame.size.height * 0.6))
            logoImageView.setImageWithFrameWidth(image: UIImage(named: "topLogo"))
            logoImageView.frame.size.width = naviBar.frame.width / 4
            
            logoImageView.center.y = naviBar.frame.size.height / 2
            logoImageView.frame.origin.x = SCREEN.WIDTH - logoImageView.frame.size.width - (SCREEN.WIDTH * (20.5/360)) - 15
            mainTopView.addSubview(logoImageView)
            
            
        } else if IS_IPHONE_N_PLUS {
            
            let mainTopView = UIView(frame: CGRect(x: 20, y: -30, width: SCREEN.WIDTH - 20, height: noticeView.minY - naviBar.maxY - mainButtonBackView.frame.height))
                    allBackView.addSubview(mainTopView)
            
                    let mainSymboleImageView = UIImageView(frame: mainTopView.bounds)
            
//                    mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "mainSymbol"))
            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "main2024"))
                    mainSymboleImageView.frame.origin.x = -25
//            mainSymboleImageView.layer.borderWidth = 1
            mainSymboleImageView.frame.size.width *= 1.325
            mainSymboleImageView.frame.size.height *= 1
            mainSymboleImageView.contentMode = .scaleAspectFill
                    mainTopView.addSubview(mainSymboleImageView)
            
                    let mainTitleImageView = UIImageView(frame: mainTopView.bounds)
                    mainTitleImageView.setImageWithFrameWidth(image: UIImage(named: "mainTitle"))
                    mainTitleImageView.frame.size.height *= 0.8
                    mainTitleImageView.frame.size.width  *= 0.64
                    mainTitleImageView.frame.origin.x = SCREEN.WIDTH * 0.034
            
                    mainTitleImageView.center.y = mainTopView.height / 2
//                    mainTopView.addSubview(mainTitleImageView)
            let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: naviBar.frame.size.height * 0.6))
            logoImageView.setImageWithFrameWidth(image: UIImage(named: "topLogo"))
            logoImageView.frame.size.width = naviBar.frame.width / 4
            
            logoImageView.center.y = naviBar.frame.size.height / 5
            logoImageView.frame.origin.x = SCREEN.WIDTH - logoImageView.frame.size.width - (SCREEN.WIDTH * (20.5/360)) - 10
            mainTopView.addSubview(logoImageView)
            

        } else if IS_IPHONE_12PRO_MAX {
            let mainTopView = UIView(frame: CGRect(x: -5, y: -40, width: SCREEN.WIDTH, height: noticeView.minY - naviBar.maxY - mainButtonBackView.frame.height))
                    allBackView.addSubview(mainTopView)
            
                    let mainSymboleImageView = UIImageView(frame: mainTopView.bounds)
            
//                    mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "mainSymbol"))
            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "main2024"))
//                    mainSymboleImageView.frame.origin.x = SCREEN.WIDTH - mainSymboleImageView.width + 15
            mainSymboleImageView.frame.size.width *= 1.15
            mainSymboleImageView.frame.size.height *= 1.2
//            mainSymboleImageView.contentMode = .scaleAspectFill
            
                    mainTopView.addSubview(mainSymboleImageView)
            
                    let mainTitleImageView = UIImageView(frame: mainTopView.bounds)
                    mainTitleImageView.setImageWithFrameWidth(image: UIImage(named: "mainTitle"))
                    mainTitleImageView.frame.size.height *= 0.8
                    mainTitleImageView.frame.size.width  *= 0.64
                    mainTitleImageView.frame.origin.x = SCREEN.WIDTH * 0.034

                    mainTitleImageView.center.y = mainTopView.height / 2
//                    mainTopView.addSubview(mainTitleImageView)
            
            let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: naviBar.frame.size.height * 0.6))
            logoImageView.setImageWithFrameWidth(image: UIImage(named: "topLogo"))
            logoImageView.frame.size.width = naviBar.frame.width / 4
            
            logoImageView.center.y = naviBar.frame.size.height / 2
            logoImageView.frame.origin.x = SCREEN.WIDTH - logoImageView.frame.size.width - (SCREEN.WIDTH * (20.5/360)) + 5
            mainTopView.addSubview(logoImageView)
            
        } else if IS_IPHONE_15PRO_MAX{
            let mainTopView = UIView(frame: CGRect(x: -5, y: -40, width: SCREEN.WIDTH, height: noticeView.minY - naviBar.maxY - mainButtonBackView.frame.height))
                    allBackView.addSubview(mainTopView)
            
                    let mainSymboleImageView = UIImageView(frame: mainTopView.bounds)
            
//                    mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "mainSymbol"))
            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "main2024"))
//                    mainSymboleImageView.frame.origin.x = SCREEN.WIDTH - mainSymboleImageView.width + 15
            mainSymboleImageView.frame.size.width *= 1.2
            mainSymboleImageView.frame.size.height *= 1.2
//            mainSymboleImageView.contentMode = .scaleAspectFill
            
                    mainTopView.addSubview(mainSymboleImageView)
            
                    let mainTitleImageView = UIImageView(frame: mainTopView.bounds)
                    mainTitleImageView.setImageWithFrameWidth(image: UIImage(named: "mainTitle"))
                    mainTitleImageView.frame.size.height *= 0.8
                    mainTitleImageView.frame.size.width  *= 0.64
                    mainTitleImageView.frame.origin.x = SCREEN.WIDTH * 0.034

                    mainTitleImageView.center.y = mainTopView.height / 2
//                    mainTopView.addSubview(mainTitleImageView)
            
            let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: naviBar.frame.size.height * 0.6))
            logoImageView.setImageWithFrameWidth(image: UIImage(named: "topLogo"))
            logoImageView.frame.size.width = naviBar.frame.width / 4
            
            logoImageView.center.y = naviBar.frame.size.height / 2
            logoImageView.frame.origin.x = SCREEN.WIDTH - logoImageView.frame.size.width - (SCREEN.WIDTH * (20.5/360)) + 5
            mainTopView.addSubview(logoImageView)
        } else if IS_IPHONE_15PRO {
            let mainTopView = UIView(frame: CGRect(x: -5, y: -40, width: SCREEN.WIDTH, height: noticeView.minY - naviBar.maxY - mainButtonBackView.frame.height))
                    allBackView.addSubview(mainTopView)
            
                    let mainSymboleImageView = UIImageView(frame: mainTopView.bounds)
            
//                    mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "mainSymbol"))
            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "main2024"))
//                    mainSymboleImageView.frame.origin.x = SCREEN.WIDTH - mainSymboleImageView.width + 15
            mainSymboleImageView.frame.size.width *= 1.32
            mainSymboleImageView.frame.size.height *= 1.2
//            mainSymboleImageView.contentMode = .scaleAspectFill
            
                    mainTopView.addSubview(mainSymboleImageView)
            
                    let mainTitleImageView = UIImageView(frame: mainTopView.bounds)
                    mainTitleImageView.setImageWithFrameWidth(image: UIImage(named: "mainTitle"))
                    mainTitleImageView.frame.size.height *= 0.8
                    mainTitleImageView.frame.size.width  *= 0.64
                    mainTitleImageView.frame.origin.x = SCREEN.WIDTH * 0.034

                    mainTitleImageView.center.y = mainTopView.height / 2
//                    mainTopView.addSubview(mainTitleImageView)
            
            let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: naviBar.frame.size.height * 0.6))
            logoImageView.setImageWithFrameWidth(image: UIImage(named: "topLogo"))
            logoImageView.frame.size.width = naviBar.frame.width / 4
            
            logoImageView.center.y = naviBar.frame.size.height / 2
            logoImageView.frame.origin.x = SCREEN.WIDTH - logoImageView.frame.size.width - (SCREEN.WIDTH * (20.5/360)) + 5
            mainTopView.addSubview(logoImageView)
        } else {
            let mainTopView = UIView(frame: CGRect(x: -5, y: -40, width: SCREEN.WIDTH, height: noticeView.minY - naviBar.maxY - mainButtonBackView.frame.height))
                    allBackView.addSubview(mainTopView)
            
                    let mainSymboleImageView = UIImageView(frame: mainTopView.bounds)
            
//                    mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "mainSymbol"))
            mainSymboleImageView.setImageWithFrameWidth(image: UIImage(named: "main2024"))
//                    mainSymboleImageView.frame.origin.x = SCREEN.WIDTH - mainSymboleImageView.width + 15
            mainSymboleImageView.frame.size.width *= 1.2
            mainSymboleImageView.frame.size.height *= 1.2
//            mainSymboleImageView.contentMode = .scaleAspectFill
            
                    mainTopView.addSubview(mainSymboleImageView)
            
                    let mainTitleImageView = UIImageView(frame: mainTopView.bounds)
                    mainTitleImageView.setImageWithFrameWidth(image: UIImage(named: "mainTitle"))
                    mainTitleImageView.frame.size.height *= 0.8
                    mainTitleImageView.frame.size.width  *= 0.64
                    mainTitleImageView.frame.origin.x = SCREEN.WIDTH * 0.034

                    mainTitleImageView.center.y = mainTopView.height / 2
//                    mainTopView.addSubview(mainTitleImageView)
            
            let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: naviBar.frame.size.height * 0.6))
            logoImageView.setImageWithFrameWidth(image: UIImage(named: "topLogo"))
            logoImageView.frame.size.width = naviBar.frame.width / 4
            
            logoImageView.center.y = naviBar.frame.size.height / 2
            logoImageView.frame.origin.x = SCREEN.WIDTH - logoImageView.frame.size.width - (SCREEN.WIDTH * (20.5/360)) + 5
            mainTopView.addSubview(logoImageView)
        }
        
        
        
//        mainTitleImageBackView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
//        mainTitleImageBackView2.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        
        
        
        
        
    }
    
}

class MainButton: UIButton {
    
    var innerView : UIView!
    var iconImageView : UIImageView!
    var nameLabel : UILabel!

    init(frame: CGRect, imageName : String, name : String) {
        super.init(frame: frame)
        
        
        innerView = UIView(frame: self.bounds)
        innerView.isUserInteractionEnabled = false
        self.addSubview(innerView)
        
        
        
        var iconImageBackViewRatio : CGFloat = 0.6
        if IS_IPHONE_N_PLUS {
            iconImageBackViewRatio = 0.55
        }
        if IS_IPHONE_N {
            iconImageBackViewRatio = 0.5
        }
        if IS_IPHONE_SE {
            iconImageBackViewRatio = 0.5
        } else {
            iconImageBackViewRatio = 0.5
        }
        let iconImageBackView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width * iconImageBackViewRatio, height: self.frame.size.width * iconImageBackViewRatio))
        iconImageBackView.center.x = innerView.frame.size.width / 2
        
        if IS_IPHONE_X {
            iconImageBackView.center.y = innerView.frame.size.height / 4.5
        }
        //        iconImageBackView.layer.cornerRadius = iconImageBackView.frame.size.width * 0.5
        
        innerView.addSubview(iconImageBackView)
        
        let iconImageViewRatio : CGFloat = 0.8
        iconImageView  = UIImageView(frame: iconImageBackView.bounds)
        iconImageView.frame.size.width *= iconImageViewRatio
        
        iconImageView.frame.size.height *= iconImageViewRatio
        
        if IS_IPHONE_X {
            iconImageView.frame.size.width *= 0.9
            
            iconImageView.frame.size.height *= 0.9
        }
//        
//        if nameLabel.text == "초록보기" {
//            iconImageView.frame.size.height *= 1.2
//        }
        
        
        
        iconImageBackView.addSubview(iconImageView)

        if let iconImage = UIImage(named: imageName) {
            if iconImage.size.width > iconImage.size.height {
                iconImageView.setImageWithFrameHeight(image: iconImage)
            }else{
                iconImageView.setImageWithFrameWidth(image: iconImage)
            }
        }
        iconImageView.center = iconImageBackView.frame.center
        if IS_IPHONE_N_PLUS {
            iconImageView.frame.origin.y = 60
        } else {
            iconImageView.frame.origin.y = 65
        }
//        iconImageView.frame.origin.y = 65
        nameLabel = UILabel(frame: CGRect(x: 0, y: iconImageBackView.frame.maxY, width: self.frame.size.width * 2, height: 50))
        nameLabel.textColor = #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: NotoSansCJKkr_Medium, size: nameLabel.frame.size.height * 0.35)

        if IS_IPHONE_X {
           nameLabel.font = UIFont(name: NotoSansCJKkr_Medium, size: nameLabel.frame.size.height * 0.35)
        }
        if IS_IPHONE_N {
            nameLabel.font = UIFont(name: NotoSansCJKkr_Medium, size: nameLabel.frame.size.height * 0.35)
        }
        if IS_IPHONE_SE {
            nameLabel.font = UIFont(name: NotoSansCJKkr_Medium, size: nameLabel.frame.size.height * 0.3)
        }
        nameLabel.numberOfLines = 0
        innerView.addSubview(nameLabel)
        
//        nameLabel.frame.origin.y = iconImageBackView.frame.maxY + 5
//        let test = 5 / self.height
//        print("test:\(test)")
        let nameLabelGap : CGFloat = self.height * 0.045
//        print("nameLabelGap:-\(nameLabelGap)")
        nameLabel.frame.origin.y = iconImageBackView.frame.maxY - nameLabelGap
//        if !IS_NORCH {
//            nameLabel.frame.origin.y = iconImageBackView.frame.maxY
//        }
        nameLabel.center.x = innerView.frame.size.width / 2
        nameLabel.text = name
        if !name.contains("\n") {
            nameLabel.text = "\(name)\n"
        }
        nameLabel.sizeToFit()
        nameLabel.text = name
        nameLabel.center.x = self.frame.size.width / 2
        nameLabel.frame.origin.y = self.frame.size.height + 25

        innerView.frame.size.height = nameLabel.frame.maxY
        innerView.center.y = self.frame.size.height * 0.5


        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 1, height: 1)
//        self.layer.shadowRadius = 3
//        self.layer.shadowOpacity = 0.3
//        self.layer.shadowOpacity = 0.1

        
//        nameLabel.backgroundColor         = UIColor.random.withAlphaComponent(0.3)
//        self.backgroundColor              = UIColor.random.withAlphaComponent(0.3)
//        iconImageBackView.backgroundColor = UIColor.random.withAlphaComponent(0.3)
//        innerView.backgroundColor         = UIColor.random.withAlphaComponent(0.3)

    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//    var iconImageView : UIImageView!
//    var nameLabel : UILabel!
//
//    init(frame: CGRect, name : String, imageName : String) {
//        super.init(frame: frame)
//
//        self.backgroundColor = UIColor.clear
//
//        let innerView = UIView(frame: self.bounds)
//        innerView.isUserInteractionEnabled = false
//        self.addSubview(innerView)
//
//        let iconImageBackViewRatio : CGFloat = 0.6
//        let iconImageBackView = UIView(frame: self.bounds)
//        iconImageBackView.frame.size.width *= iconImageBackViewRatio
////        iconImageBackView.frame.size.height *= iconImageBackViewRatio
//        iconImageBackView.frame.size.height = iconImageBackView.frame.size.width
//        iconImageBackView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
////        iconImageBackView.layer.cornerRadius = iconImageBackView.frame.size.width * 0.5
//        iconImageBackView.clipsToBounds = true
//        iconImageBackView.center.x = self.frame.size.width / 2
//        innerView.addSubview(iconImageBackView)
//
//        iconImageView  = UIImageView(frame: iconImageBackView.bounds)
//        iconImageView.frame.size.width *= 0.75
//        iconImageView.frame.size.height *= 0.75
//        iconImageBackView.addSubview(iconImageView)
//
//        let iconImage = UIImage(named: imageName)!
//        if iconImage.size.width > iconImage.size.height {
//            iconImageView.setImageWithFrameHeight(image: iconImage)
//        }else{
//            iconImageView.setImageWithFrameWidth(image: iconImage)
//        }
//        iconImageView.center = iconImageBackView.frame.center
//
//        nameLabel = UILabel(frame: CGRect(x: 0, y: iconImageBackView.frame.maxY, width: self.frame.size.width * 2, height: 50))
//        nameLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1725490196, blue: 0.2862745098, alpha: 1)
//        nameLabel.textAlignment = .center
//        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 16)
//        if IS_IPHONE_SE {
//            nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 14)
//        }
//        nameLabel.numberOfLines = 0
//        innerView.addSubview(nameLabel)
//
//        nameLabel.frame.origin.y = iconImageBackView.frame.maxY + 10
//        nameLabel.center.x = innerView.frame.size.width / 2
//        nameLabel.text = name
////        if !name.contains("\n") {
////            nameLabel.text = "\(name)\n"
////        }
//        nameLabel.sizeToFit()
////        nameLabel.text = name
//        nameLabel.center.x = self.frame.size.width / 2
//
//        innerView.frame.size.height = nameLabel.frame.maxY
//        innerView.center.y = self.frame.size.height * 0.5
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}

