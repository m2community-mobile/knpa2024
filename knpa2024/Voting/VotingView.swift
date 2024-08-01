//
//  VotingView2.swift
//  CosoptTransformSymposium2019
//
//  Created by m2comm on 25/03/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class VotingView: UIView {

    var motherVC : UIViewController?
    
    var titleLabel : UILabel!
    
    init(frame: CGRect, titleName : String, motherVC kMotherVC : UIViewController) {
        super.init(frame: frame)
        
        motherVC = kMotherVC
        
        SendReq().sendLogin(code: code, id: deviceID)
        
        ////////////////////////////////////////////////////////////////////////////////////////////////
        
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
        
        let box1ImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: SCREEN.WIDTH - 30, height: 0))
        box1ImageView.setImageWithFrameHeight(image: UIImage(named: "box_bg1"))
        box1ImageView.frame.origin.y = self.titleLabel.frame.maxY
        self.addSubview(box1ImageView)
        
        let box3ImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: SCREEN.WIDTH - 30, height: 0))
        box3ImageView.setImageWithFrameHeight(image: UIImage(named: "box_bg3"))
        box3ImageView.frame.origin.y = self.frame.size.height - box3ImageView.frame.size.height - 10
        self.addSubview(box3ImageView)
        
        let box2ImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: SCREEN.WIDTH - 30, height: 0))
        box2ImageView.image = UIImage(named: "box_bg2")
        box2ImageView.frame.origin.y = box1ImageView.frame.maxY
        box2ImageView.frame.size.height = box3ImageView.frame.origin.y - box1ImageView.frame.maxY
        self.addSubview(box2ImageView)
        
        let votingTextLabel = UILabel(frame: CGRect(
            x: 0,
            y: box1ImageView.frame.minY + (box1ImageView.frame.size.height / 2),
            width: SCREEN.WIDTH * 0.8,
            height: 40))
        votingTextLabel.center.x = SCREEN.WIDTH / 2
        votingTextLabel.text = "문제를 보시고 아래 번호를 선택해 주세요."
        votingTextLabel.font = UIFont.systemFont(ofSize: 25)
        votingTextLabel.adjustsFontSizeToFitWidth = true
        votingTextLabel.textAlignment = .center
        self.addSubview(votingTextLabel)
        
        let votingInnerView = UIView(frame: CGRect(
            x: 30,
            y: votingTextLabel.frame.maxY + 10,
            width: SCREEN.WIDTH - 60,
            height: (box3ImageView.frame.minY + (box3ImageView.frame.size.height / 2)) - (votingTextLabel.frame.maxY + 10)))
        self.addSubview(votingInnerView)
        
        
        let buttonSizeWidth = SCREEN.WIDTH - 60
        let buttonOriginY = votingInnerView.frame.size.height / 5
        
        for i in 0..<5 {
            
            let votingBackView = UIView(frame: CGRect(x: 0, y: (CGFloat(i) * buttonOriginY), width: buttonSizeWidth, height: buttonOriginY))
            votingInnerView.addSubview(votingBackView)
            
            let votingButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSizeWidth, height: votingBackView.frame.size.height * 0.85))
            votingButton.center.y = buttonOriginY / 2
            votingButton.layer.cornerRadius = 10
            votingButton.clipsToBounds = true
            var normalColors = [UIColor]()
            var highlightedColors = [UIColor]()
            for i in 0..<5 {
                
//                normalColors.append(questionNonSelectedColor.removeBrightness(val: 0.05 * CGFloat(i)))
//                highlightedColors.append(questionSelectedColor.removeBrightness(val: 0.01 * CGFloat(i)))
                
                normalColors.append(votingNonSelectedColor.removeBrightness(val: 0.05 * CGFloat(i)))
//                highlightedColors.append(votingSelectedColor.removeBrightness(val: 0.01 * CGFloat(i)))
                highlightedColors.append(votingSelectedColor.removeBrightness(val: 0.05 * CGFloat(i)))
            }
            votingButton.setGradientColorImage(colors: normalColors, for: .normal)
            votingButton.setGradientColorImage(colors: highlightedColors, for: .highlighted)
            
            votingBackView.addSubview(votingButton)
            
            let votingNumberLabel = UILabel(frame: votingButton.frame)
            votingNumberLabel.textAlignment = .center
            votingNumberLabel.font = UIFont.systemFont(ofSize: votingNumberLabel.frame.size.height * 0.4)
            votingNumberLabel.text = "\(i+1)번"
            votingNumberLabel.textColor = UIColor.white
            votingNumberLabel.isUserInteractionEnabled = false
            votingBackView.addSubview(votingNumberLabel)
            
            votingButton.addTarget(event: .touchUpInside) { [weak self] (button) in
                self?.submission(code: i+1)
            }
        }
    }
    
    func submission(code:Int){
        var returnCode = 4
        if code <= 5 {
            returnCode = SendReq().socket("\(code)")
        }
        self.errorAlertWindow(returnCode: returnCode)
    }
    
    //Alert Error Window
    func  errorAlertWindow(returnCode : Int){
        var alertMessage = ""
        
        switch returnCode {
        case 0:
            alertMessage = "퀴즈가 진행중이 아닙니다."
        case 1:
            alertMessage = "제출 되었습니다."
        case 2:
            alertMessage = "이미 제출되었습니다."
        default:
            return
        }
        
        let alert = UIAlertController(title: "알림", message: alertMessage , preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "확인", style: .cancel){
            (_)in
            //앱 강제종료코드 넣기
            return
        }
        alert.addAction(cancleAction)
        
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        if topController != nil {
            topController?.present(alert, animated: true, completion: nil)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


func colorToImage(color : UIColor) -> UIImage{
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image!
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIButton {
    
    func setBackgroundImageClippedToBounds(_ image: UIImage, for state: UIControl.State) {
        if !(!clipsToBounds && layer.cornerRadius != 0.0) {
            setBackgroundImage(image, for: state)
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).addClip()
        image.draw(in: bounds)
        let clippedBackgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        setBackgroundImage(clippedBackgroundImage, for: state)
    }
}
