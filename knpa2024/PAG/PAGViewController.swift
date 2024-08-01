//
//  PAGViewController.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit



class PAGViewController: BaseViewController {

    var bottomView : BottomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.subTitleLabel.text = "Program at a Glance"

        bottomView = BottomView()
        self.view.addSubview(bottomView)
        
        let pagView = PAGView(
            frame: CGRect(
                x: 0,
                y: self.subTitleView.frame.maxY,
                width: SCREEN.WIDTH,
                height: bottomView.frame.minY - self.subTitleView.frame.maxY),
            
            kSubTitleView: self.subTitleView,
            kSubTitleLabel: self.subTitleLabel,
            kBackButtonimageView: self.backButtonimageView,
            kMotherVC: self)
        self.view.addSubview(pagView)
        
    }
    


}
