//
//  AboutLeftTableView.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit
import FontAwesome_swift


@objc protocol LeftTableViewHeaderDelegate {
    @objc optional func leftTableViewHeader(_ leftTableViewHeader: LeftTableViewHeader, didSelectHeader index: Int)
}

class LeftTableViewHeader: UITableViewHeaderFooterView {
    
    static let height : CGFloat = 60
    
    var delegate : LeftTableViewHeaderDelegate?
    
    var titleLabel : UILabel!
    var titleImageView : UIImageView!
    
    var arrowImageView : UIImageView!
    
    var index = 0
    
    var underBar : UIView!
    
//    var isHighlighted : Bool = false {
//        willSet(newIsHighlighted) {
//            self.contentView.backgroundColor = newIsHighlighted ? #colorLiteral(red: 0.168627451, green: 0.3882352941, blue: 0.7215686275, alpha: 1) : UIColor.white
//        }
//    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        
        let myHeight = LeftTableViewHeader.height
        
        self.frame.size = CGSize(width: leftViewContentViewWidth, height: myHeight)
        
        let arrowImageBackView = UIView(frame: CGRect(x: leftViewContentViewWidth - myHeight, y: 0, width: myHeight, height: myHeight))
        //        plusImageBackView.backgroundColor = UIColor.red
        self.addSubview(arrowImageBackView)
        
        arrowImageView = UIImageView(frame: arrowImageBackView.bounds)
        arrowImageView.frame.size.width *= 0.4
        arrowImageView.frame.size.height *= 0.4
        arrowImageView.center = arrowImageBackView.frame.center
        arrowImageView.image = UIImage.fontAwesomeIcon(name: FontAwesome.angleDown, style: FontAwesomeStyle.solid, textColor: UIColor.black, size: arrowImageView.frame.size)
        arrowImageBackView.addSubview(arrowImageView)
        
        titleImageView = UIImageView(frame: CGRect(x: 25, y: 0, width: LeftTableViewHeader.height * 0.35, height: LeftTableViewHeader.height * 0.35))
        titleImageView.center.y = LeftTableViewHeader.height * 0.5
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.isUserInteractionEnabled = false
        self.addSubview(titleImageView)
        
        titleLabel = UILabel(frame: CGRect(
            x: titleImageView.frame.maxX + 20,
            y: 0,
            width: arrowImageBackView.frame.minX - 10 - (titleImageView.frame.maxX + 20),
//            width: 100,
            height: self.frame.size.height))
        //        titleLabel.font = UIFont.systemFont(ofSize: titleLabel.frame.size.height * 0.25)
        titleLabel.font = UIFont.systemFont(ofSize: titleLabel.frame.size.height * 0.3)
        titleLabel.isUserInteractionEnabled = false
        self.addSubview(titleLabel)
        
        
        underBar = UIView(frame: CGRect(x: 0, y: LeftTableViewHeader.height - 0.5, width: self.frame.size.width, height: 0.5))
        underBar.backgroundColor = UIColor(white: 222/255, alpha: 1)
        self.addSubview(underBar)
        
        let button = UIButton(frame: self.bounds)
        button.addTarget(event: .touchUpInside) { [weak self] (button) in
            if let self = self {
                self.delegate?.leftTableViewHeader?(self, didSelectHeader: self.index)
            }
        }
        self.addSubview(button)
        
        //todo-remove
        //        titleImageView.frame = CGRect.zero
        //        titleLabel.frame = CGRect.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class LeftTableViewCell: UITableViewCell {
    
    static let height : CGFloat = 50
    
    var titleLabel : UILabel!
    
    override var isSelected: Bool {
        willSet(newIsSelected) {
            if newIsSelected {
                titleLabel.textColor = #colorLiteral(red: 0.2017554045, green: 0.1662605107, blue: 0.516266942, alpha: 1)
            }else{
                titleLabel.textColor = #colorLiteral(red: 0.3882352941, green: 0.3882352941, blue: 0.3882352941, alpha: 1)
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = #colorLiteral(red: 0.9529412389, green: 0.9529412389, blue: 0.9529412389, alpha: 1)
        //rgb 234 241 233
        self.selectionStyle = .none
        
        let myHeight = LeftTableViewCell.height
        self.frame.size = CGSize(width: leftViewContentViewWidth, height: myHeight)
        
        titleLabel = UILabel(frame: CGRect(x: 60, y: 0, width: leftViewContentViewWidth - 32, height: myHeight))
        titleLabel.font = UIFont.systemFont(ofSize: myHeight * 0.3)
        titleLabel.textColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        self.addSubview(titleLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
