//
//  agendaView.swift
//  CosoptTransformSymposium2019
//
//  Created by m2comm on 25/03/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit

class VotingWebView: UIView {

    var mainVC : MainViewController?
    
    var titleLabel : UILabel!
    var webView : WebView!
    
    init(frame: CGRect, urlString : String, titleName : String, mainVC kMainVC : MainViewController) {
        super.init(frame: frame)
        
        self.mainVC = kMainVC
        print("webView urlString : \(urlString)")
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
        
        self.webView = WebView(frame: CGRect(x: 0, y: self.titleLabel.frame.maxY , width: SCREEN.WIDTH, height: self.frame.size.height - self.titleLabel.frame.maxY), urlString: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        self.addSubview(self.webView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
