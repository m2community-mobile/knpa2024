//
//  ImageButton.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit

class ImageButton: UIButton {
    
    var buttonImageView : UIImageView!
    var ratio : CGFloat = 0
    
    init(frame : CGRect, image : UIImage?, ratio kRatio: CGFloat) {
        super.init(frame: frame)
        
        self.ratio = kRatio
        
        buttonImageView = UIImageView(frame: self.bounds)
        buttonImageView.isUserInteractionEnabled = false
        buttonImageView.frame.size.width *= ratio
        buttonImageView.frame.size.height *= ratio
        
        if let image = image {
            if image.size.width > image.size.height {
                buttonImageView.setImageWithFrameHeight(image: image)
            }else{
                buttonImageView.setImageWithFrameWidth(image: image)
            }
            buttonImageView.center = self.frame.center
        }
        self.addSubview(buttonImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
