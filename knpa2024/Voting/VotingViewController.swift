//
//  MainViewController.swift
//  CosoptTransformSymposium2019
//
//  Created by m2comm on 25/03/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class VotingViewController: UIViewController {
    
    var bottomButtons = [UIButton]()
    
    var mainViews = [UIView]()
    
    var startIndex = 1
    
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let bottomHeight : CGFloat = 60
        let bottomView = UIView(frame: CGRect(x: 0, y: SCREEN.HEIGHT - bottomHeight - SAFE_AREA, width: SCREEN.WIDTH, height: bottomHeight))
        self.view.addSubview(bottomView)
        
        for i in 0..<ButtonInfos.count {
            let bottomButtonWidth = SCREEN.WIDTH / CGFloat(ButtonInfos.count)
            let bottomButton = UIButton(frame: CGRect(x: CGFloat(i) * bottomButtonWidth, y: 0, width: bottomButtonWidth, height: bottomView.frame.size.height))
            bottomButton.backgroundColor = buttonNonSelectedColor
            bottomButton.tag = i
            
            var normalColors = [UIColor]()
            var highlightedColors = [UIColor]()
            for j in 0..<5 {
                normalColors.append(buttonNonSelectedColor.removeBrightness(val: 0.01 * CGFloat(j)))
                highlightedColors.append(buttonSelectedColor.removeBrightness(val: 0.01 * CGFloat(j)))
            }
            bottomButton.setGradientColorImage(colors: normalColors, for: .normal)
            bottomButton.setGradientColorImage(colors: highlightedColors, for: .selected)
            
            bottomView.addSubview(bottomButton)
            bottomButtons.append(bottomButton)
            
            bottomButton.addTarget(self, action: #selector(bottomButtonPressed(button:)), for: .touchUpInside)
            
            let buttonTitleLabel = UILabel(frame: bottomButton.frame)
            buttonTitleLabel.textAlignment = .center
            buttonTitleLabel.textColor = UIColor.white
            buttonTitleLabel.text = ButtonInfos[i][BUTTON_INFO_KEY.BUTTON_TITLE]
            buttonTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
            if IS_IPHONE_SE {
                buttonTitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
            }
            
            bottomView.addSubview(buttonTitleLabel)
            
            if i != 0 {
                let line = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: bottomButton.frame.size.height))
                line.backgroundColor = UIColor(colorWithHexValue: 0x595959)
                bottomButton.addSubview(line)
            }
            
        }
        
        for i in 0..<ButtonInfos.count {
            
            let buttonInfo = ButtonInfos[i]
            
            guard let title = buttonInfo[BUTTON_INFO_KEY.TITLE] else { continue }
            
            if let typeValue = buttonInfo[BUTTON_INFO_KEY.TYPE] {
                if let type = BUTTON_INFO_KEY.type(rawValue: typeValue) {
                    switch type {
                    case .voting:
                        let votingView = VotingView(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: bottomView.frame.minY), titleName: title, motherVC: self)
                        self.view.addSubview(votingView)
                        mainViews.append(votingView)
                        break
                    case .QnA_normal:
                        let questionView = QuestionView1(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: bottomView.frame.minY), titleName: title, motherVC: self)
                        self.view.addSubview(questionView)
                        mainViews.append(questionView)
                        break
                    case .QnA_category:
                        let questionView = QuestionView2(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: bottomView.frame.minY), titleName: title, mainVC: self)
                        self.view.addSubview(questionView)
                        mainViews.append(questionView)
                        break
                    case .QnA_Type3:
                        let questionView = QuestionView3(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: bottomView.frame.minY), titleName: title, mainVC: self)
                        self.view.addSubview(questionView)
                        mainViews.append(questionView)
                        break
                    default:
                        break
                    }
                    
                }
                
            }
            
        }
        
//        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        closeButton.center = CGPoint(x: SCREEN.WIDTH - 50, y: STATUS_BAR_HEIGHT + 40)
//        closeButton.setImage(UIImage(named: "b_card_close"), for: .normal)
//        closeButton.addTarget(event: .touchUpInside) { (button) in
//            self.dismiss(animated: true, completion: {
//
//            })
//        }
//        self.view.addSubview(closeButton)
        
        let closeButton = ImageButton(frame: CGRect(x: SCREEN.WIDTH - NAVIGATION_BAR_HEIGHT - 10, y: STATUS_BAR_HEIGHT, width: NAVIGATION_BAR_HEIGHT, height: NAVIGATION_BAR_HEIGHT), image: UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), ratio: 0.45)
        closeButton.buttonImageView.tintColor = UIColor.black
        closeButton.setTarget(event: UIControl.Event.touchUpInside) { [weak self] (button) in
            self?.dismiss(animated: true) {}
        }
        self.view.addSubview(closeButton)
        
        self.bottomButtonPressed(button: bottomButtons[self.startIndex-1])
    }
    
    @objc func bottomButtonPressed(button : UIButton){
        for i in 0..<self.bottomButtons.count {
            let targetButton = self.bottomButtons[i]
            if button == targetButton {
                targetButton.isSelected = true
                self.mainViews[i].isHidden = false
                
                if let webView = self.mainViews[i] as? VotingWebView {
                    webView.webView.reloading()
                }
                
            }else{
                targetButton.isSelected = false
                self.mainViews[i].isHidden = true
            }
        }
    }
}





