//
//  PAGView.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit
import FontAwesome_swift

//struct PAG_INFO {
//    static let month = "4"
//
//    static let day1 = "18"
//    static let tab1 = "42"
//
//    static let day2 = "19"
//    static let tab2 = "43"
//
//    static let day3 = "20"
//    static let tab3 = "44"
//}

class PAGView: UIView {

    weak var subTitleLabel : UILabel!
    weak var backButtonimageView : UIImageView!
    weak var subTitleView : UIView!
    
    weak var motherVC : UIViewController!
    
    var headerView : PAGHeaderView!
    var webView : WebView!
    
    var pagNoticeButton : PAG_NoticeButton?
    
    init(frame: CGRect, kSubTitleView : UIView, kSubTitleLabel : UILabel, kBackButtonimageView : UIImageView, kMotherVC : UIViewController) {
        super.init(frame: frame)
        
        self.subTitleView = kSubTitleView
        self.subTitleLabel = kSubTitleLabel
        self.backButtonimageView = kBackButtonimageView
        
        self.motherVC = kMotherVC
        
        Server.postData(urlString: "https://ezv.kr:4447/voting/php/session/get_set.php?code=\(code)", otherInfo: [:]) {[weak self] (kData : Data?) in
            guard let self = self else { return }
            
            if let data = kData {
                if let dataDic = data.toJson() as? [String:Any] {
                    print("PAGView dataDic:\(dataDic)")
                    
                    //서브 타이틀 색상 업데이트
                    let session_topmenu_bg = UIColor(colorWithHexString: dataDic["session_topmenu_bg"] as? String ?? "ffffff")
                    self.subTitleView.backgroundColor = session_topmenu_bg
                    
                    let session_topmenu_font = UIColor(colorWithHexString: dataDic["session_topmenu_font"] as? String ?? "000000")
                    self.subTitleLabel.textColor = session_topmenu_font
                    self.backButtonimageView.image = UIImage.fontAwesomeIcon(name: FontAwesome.arrowLeft, style: .solid, textColor: session_topmenu_font, size: self.backButtonimageView.frame.size)
                    
                    //헤더뷰
                    self.headerView = PAGHeaderView(infoDic: dataDic)
                    self.headerView?.delegate = self
                    self.addSubview(self.headerView!)
                    
                    //웹뷰
                    self.webView = WebView(frame: CGRect(x: 0, y: self.headerView!.frame.maxY, width: SCREEN.WIDTH, height: self.frame.size.height - self.headerView!.frame.maxY), urlString: "https://ezv.kr:4447/voting/php/session/glance.php?code=\(code)")
                    self.webView.motherVC = self.motherVC
                    self.webView.glanceSubTitleString = "Program at a Glance"
                    self.addSubview(self.webView)
                    
                    //안내문구
                    if self.pagNoticeButton == nil {
                        self.pagNoticeButton = PAG_NoticeButton()
                        appDel.window?.addSubview(self.pagNoticeButton!)
                    }
                    
                    
                    guard let dayTypeString = dataDic["day_type"] as? String else { return }
                    
                    if let currentTab = dataDic["tab"] as? String {
                        print("currentTab:\(currentTab)")
                        if dayTypeString == "1" {
                            for i in 0..<self.headerView.tapButtons.count {
                                let tapButton = self.headerView.tapButtons[i]
                                if tapButton.tabString == currentTab {
                                    self.headerView.tapButtonPressed(tapButton: self.headerView.tapButtons[i])
                                    return
                                }
                            }
                        }else{
                            for i in 0..<self.headerView.dayViews.count {
                                let dayView = self.headerView.dayViews[i]
                                if dayView.tabString == currentTab {
                                    self.headerView.dayViewButtonPressed(dayView: self.headerView.dayViews[i])
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension PAGView : PAGHeaderViewDelegate {
    func pagHeaderView(pagHeaderView: PAGHeaderView, backButtonPressed backButton: UIButton) {
        if self.webView.wkWebView.canGoBack {
            self.webView.wkWebView.goBack()
        }else{
            appDel.naviCon?.popViewController(animated: true)
            
        }
    }
    
    func pagHeaderView(pagHeaderView: PAGHeaderView, update tab: String) {
        print(#function)
        self.webView.urlString = "https://ezv.kr:4447/voting/php/session/glance.php?code=\(code)&tab=\(tab)"
        self.webView.reloading()
        
    }
    
    func pagHeaderView(pagHeaderView: PAGHeaderView, dayViewButtonPressed tab: String) {
        self.webView.urlString = "https://ezv.kr:4447/voting/php/session/glance.php?code=\(code)&tab=\(tab)"
        self.webView.reloading()
    }
}
