//
//  IconButton.swift
//  Templete
//
//  Created by m2comm on 29/04/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import UIKit
import FontAwesome_swift


class IconButton : UIButton {
    
    var iconImageView : UIImageView!
    var nameLabel : UILabel!
    
    init(frame: CGRect, name : String, fontAwesome : FontAwesome, fontAwesomeStyle : FontAwesomeStyle = .solid) {
        super.init(frame: frame)
        
        let innerView = UIView(frame: self.bounds)
        self.addSubview(innerView)
        
        iconImageView  = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height * 0.5, height: self.frame.size.height * 0.5))
        iconImageView.image = UIImage.fontAwesomeIcon(name: fontAwesome, style: FontAwesomeStyle.solid, textColor: UIColor.white, size: iconImageView.frame.size)
        iconImageView.center.y = self.frame.size.height / 2
        iconImageView.isUserInteractionEnabled = false
        innerView.addSubview(iconImageView)
        
        nameLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + 10, y: 0, width: 100, height: self.frame.size.height))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.text = name
        nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 20)
        nameLabel.sizeToFit()
        nameLabel.center.y = self.frame.size.height / 2
        nameLabel.isUserInteractionEnabled = false
        innerView.addSubview(nameLabel)
        
        innerView.frame.size.width = nameLabel.frame.maxX
        innerView.center.x = self.frame.size.width / 2
    }
    
    init(frame: CGRect, name : String, imageName : String) {
        super.init(frame: frame)
        
        let innerView = UIView(frame: self.bounds)
        self.addSubview(innerView)
        
        iconImageView  = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height * 0.5))
        iconImageView.setImageWithFrameWidth(image: UIImage(named: imageName))
        iconImageView.center.y = self.frame.size.height / 2
        iconImageView.isUserInteractionEnabled = false
        innerView.addSubview(iconImageView)
        
        nameLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + 10, y: 0, width: 100, height: self.frame.size.height))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.text = name
        nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 20)
        nameLabel.sizeToFit()
        nameLabel.center.y = self.frame.size.height / 2
        nameLabel.isUserInteractionEnabled = false
        innerView.addSubview(nameLabel)
        
        innerView.frame.size.width = nameLabel.frame.maxX
        innerView.center.x = self.frame.size.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IconButton2: UIButton {
    
    var iconImageView : UIImageView!
    var nameLabel : UILabel!
    
    init(frame: CGRect, name : String, imageName : String) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let innerView = UIView(frame: self.bounds)
        innerView.isUserInteractionEnabled = false
        self.addSubview(innerView)
        
        let iconImageBackViewRatio : CGFloat = 0.5
        let iconImageBackView = UIView(frame: self.bounds)
        iconImageBackView.frame.size.width *= iconImageBackViewRatio
        iconImageBackView.frame.size.height *= iconImageBackViewRatio
        iconImageBackView.backgroundColor = #colorLiteral(red: 0.1647058824, green: 0.3176470588, blue: 0.768627451, alpha: 1)
        iconImageBackView.layer.cornerRadius = iconImageBackView.frame.size.width * 0.5
        iconImageBackView.clipsToBounds = true
        iconImageBackView.center.x = self.frame.size.width / 2
        innerView.addSubview(iconImageBackView)
        
        iconImageView  = UIImageView(frame: iconImageBackView.bounds)
        iconImageView.frame.size.width *= 0.9
        iconImageView.frame.size.height *= 0.9
        iconImageBackView.addSubview(iconImageView)
        
        let iconImage = UIImage(named: imageName)!
        if iconImage.size.width > iconImage.size.height {
            iconImageView.setImageWithFrameHeight(image: iconImage)
        }else{
            iconImageView.setImageWithFrameWidth(image: iconImage)
        }
        iconImageView.center = iconImageBackView.frame.center
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: iconImageBackView.frame.maxY, width: self.frame.size.width * 2, height: 50))
        nameLabel.textColor = #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 16)
        nameLabel.numberOfLines = 0
        innerView.addSubview(nameLabel)
        
        nameLabel.frame.origin.y = iconImageBackView.frame.maxY + 5
        nameLabel.center.x = innerView.frame.size.width / 2
        nameLabel.text = name
        if !name.contains("\n") {
            nameLabel.text = "\(name)\n"
        }
        nameLabel.sizeToFit()
        nameLabel.text = name
        nameLabel.center.x = self.frame.size.width / 2
        
        innerView.frame.size.height = nameLabel.frame.maxY
        innerView.center.y = self.frame.size.height * 0.5
    }
    
    init(frame: CGRect, name : String, fontAwesome : FontAwesome, fontAwesomeStyle : FontAwesomeStyle = .solid) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let innerView = UIView(frame: self.bounds)
        innerView.isUserInteractionEnabled = false
        self.addSubview(innerView)
        
        let iconImageBackViewRatio : CGFloat = 0.5
        let iconImageBackView = UIView(frame: self.bounds)
        iconImageBackView.frame.size.width *= iconImageBackViewRatio
        iconImageBackView.frame.size.height *= iconImageBackViewRatio
        iconImageBackView.backgroundColor = #colorLiteral(red: 0.1647058824, green: 0.3176470588, blue: 0.768627451, alpha: 1)
        iconImageBackView.layer.cornerRadius = iconImageBackView.frame.size.width / 2
        iconImageBackView.clipsToBounds = true
        iconImageBackView.center.x = self.frame.size.width / 2
        innerView.addSubview(iconImageBackView)
        
        iconImageView  = UIImageView(frame: iconImageBackView.bounds)
        iconImageView.frame.size.width *= 0.9
        iconImageView.frame.size.height *= 0.9
        iconImageBackView.addSubview(iconImageView)
        
        iconImageView.image = UIImage.fontAwesomeIcon(name: fontAwesome, style: fontAwesomeStyle, textColor: UIColor.white, size: iconImageView.frame.size)
        iconImageView.center = iconImageBackView.frame.center
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: iconImageBackView.frame.maxY, width: self.frame.size.width * 2, height: 50))
        nameLabel.textColor = #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 16)
        nameLabel.numberOfLines = 0
        innerView.addSubview(nameLabel)
        
        nameLabel.frame.origin.y = iconImageBackView.frame.maxY + 5
        nameLabel.center.x = innerView.frame.size.width / 2
        nameLabel.text = name
        if !name.contains("\n") {
            nameLabel.text = "\(name)\n"
        }
        nameLabel.sizeToFit()
        nameLabel.text = name
        nameLabel.center.x = self.frame.size.width / 2
        
        innerView.frame.size.height = nameLabel.frame.maxY
        innerView.center.y = self.frame.size.height * 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IconButtonWithBottom : UIButton {
    
    var iconImageView : UIImageView!
    var nameLabel : UILabel!
    
    init(frame: CGRect, name : String, fontAwesome : FontAwesome, fontAwesomeStyle : FontAwesomeStyle = .solid) {
        super.init(frame: frame)
        
        let innerView = UIView(frame: self.bounds)
        innerView.isUserInteractionEnabled = false
        innerView.frame.size.height = 50
        self.addSubview(innerView)
        
        iconImageView  = UIImageView(frame: CGRect(x: 0, y: 0, width: innerView.frame.size.height * 0.5, height: innerView.frame.size.height * 0.5))
        iconImageView.image = UIImage.fontAwesomeIcon(name: fontAwesome, style: fontAwesomeStyle, textColor: UIColor.white, size: iconImageView.frame.size)
        iconImageView.center.y = innerView.frame.size.height / 2
        iconImageView.isUserInteractionEnabled = false
        innerView.addSubview(iconImageView)
        
        nameLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + 10, y: 0, width: 100, height: innerView.frame.size.height))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.text = name
        nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 20)
        nameLabel.sizeToFit()
        nameLabel.center.y = innerView.frame.size.height / 2
        nameLabel.isUserInteractionEnabled = false
        innerView.addSubview(nameLabel)
        
        innerView.frame.size.width = nameLabel.frame.maxX
        innerView.center.x = self.frame.size.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


