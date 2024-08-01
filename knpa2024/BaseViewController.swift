//
//  BaseViewController.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//


import UIKit
import FontAwesome_swift

let mainColor = #colorLiteral(red: 0.2018971443, green: 0.1664702594, blue: 0.5201563239, alpha: 1)

class BaseViewController: UIViewController {
    
    var naviBar : UIView!
    
    var subTitleString = ""
    
    var subTitleView : UIView!
    var subTitleLabel : UILabel!
    
    var backButtonimageView : UIImageView!
    var underBar : UIView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    
        
        return [.portrait]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("open")

        self.view.backgroundColor = UIColor.white

        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: STATUS_BAR_HEIGHT))
        statusBar.backgroundColor = mainColor
        self.view.addSubview(statusBar)
        
        naviBar = UIView(frame: CGRect(x: 0, y: statusBar.frame.maxY, width: SCREEN.WIDTH, height: NAVIGATION_BAR_HEIGHT))
        naviBar.backgroundColor = mainColor
        self.view.addSubview(naviBar)
        
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: naviBar.frame.size.height, height: naviBar.frame.size.height))
        menuButton.addTarget(event: .touchUpInside) { (button) in
            appDel.leftView?.open(currentVC: self)
        }
        naviBar.addSubview(menuButton)
        
        let menuButtonimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: naviBar.frame.size.height * 0.5, height: naviBar.frame.size.height * 0.5))
        menuButtonimageView.image = UIImage(named: "btnDMenu1")
//            UIImage.fontAwesomeIcon(name: FontAwesome.bars, style: .solid, textColor: UIColor.white, size: menuButtonimageView.frame.size)
        menuButtonimageView.isUserInteractionEnabled = false
        menuButtonimageView.center = CGPoint(x: menuButton.frame.size.width / 2, y: menuButton.frame.size.height / 2)
        menuButton.addSubview(menuButtonimageView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH - (menuButton.frame.size.width * 2), height: naviBar.frame.size.height))
        titleLabel.center.x = SCREEN.WIDTH / 2
        titleLabel.text = "2024 춘계학술대회"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 17.5)
        if IS_IPHONE_SE {
            
            titleLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 15)
        }
        titleLabel.textAlignment = .center
        naviBar.addSubview(titleLabel)
        
        let homeButton = UIButton(frame: titleLabel.frame)
        homeButton.addTarget(event: .touchUpInside) { (button) in
            appDel.naviCon?.popToRootViewController(animated: true)
        }
        naviBar.addSubview(homeButton)
        
        
        subTitleView = UIView(frame: CGRect(x: 0, y: naviBar.frame.maxY, width: SCREEN.WIDTH, height: 40))
        
        subTitleView.backgroundColor = #colorLiteral(red: 0.2018971443, green: 0.1664702594, blue: 0.5201563239, alpha: 1)
        
        self.view.addSubview(subTitleView)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: subTitleView.frame.size.height, height: subTitleView.frame.size.height))
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.addTarget(event: .touchUpInside) { (button) in
            
        }
        subTitleView.addSubview(backButton)
        
        backButtonimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: subTitleView.frame.size.height * 0.5, height: subTitleView.frame.size.height * 0.5))
        backButtonimageView.image = UIImage.fontAwesomeIcon(name: FontAwesome.arrowLeft, style: .solid, textColor: UIColor.white, size: backButtonimageView.frame.size)
        backButtonimageView.center.x = backButton.frame.size.width / 2
        backButtonimageView.tintColor = .white
        backButtonimageView.isUserInteractionEnabled = false
        backButtonimageView.center = CGPoint(x: backButton.frame.size.width / 2, y: backButton.frame.size.height / 2)
        backButton.addSubview(backButtonimageView)
        
        subTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH - (backButton.frame.size.width * 2), height: subTitleView.frame.size.height))
        subTitleLabel.center.x = SCREEN.WIDTH / 2
        subTitleLabel.text = subTitleString
        subTitleLabel.textColor = UIColor.white
        subTitleLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 15)
        subTitleLabel.textAlignment = .center
        subTitleView.addSubview(subTitleLabel)
        
        underBar = UIView(frame: CGRect(x: 0, y: subTitleView.frame.minY, width: SCREEN.WIDTH, height: 0.5))
        underBar.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1).withAlphaComponent(0.5)
        self.view.addSubview(underBar)
        
        
    }
    
    @objc func backButtonPressed(){
        appDel.naviCon?.popViewController(animated: true)
    }
    
}
