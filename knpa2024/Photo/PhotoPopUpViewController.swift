//
//  PhotoPopUpViewController.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit
import FontAwesome_swift

class PhotoPopUpViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var photoImage : UIImage? {
        willSet(newImage){
//            self.baseVC?.imageUpdate(image: newImage)
        }
    }
    var photoImageView : UIImageView!
    var scrollView : UIScrollView!
   
    var currentIndex = 0
    var photoInfo = [String:Any]()
    
    weak var baseVC : PhotoPopUpBaseViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.baseVC?.buttonsUpdate(index: self.currentIndex)
        self.baseVC?.titleUpdate(index: self.currentIndex)
        self.baseVC?.imageUpdate(image: self.photoImage)
        
        

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(UIView())
        
        scrollView = UIScrollView(frame: SCREEN.BOUND)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        photoImageView = UIImageView(frame: CGRect.zero)
        scrollView.addSubview(photoImageView)
        
        scrollView.maximumZoomScale = 2
        
        
        
        
        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(tap(tapGesture:)))
        tapGestrue.numberOfTapsRequired = 1
        tapGestrue.delegate = self
        scrollView.addGestureRecognizer(tapGestrue)
        
        let doubleTapGestrue = UITapGestureRecognizer(target: self, action: #selector(doubleTap(tapGesture:)))
        doubleTapGestrue.numberOfTapsRequired = 2
        doubleTapGestrue.delegate = self
        scrollView.addGestureRecognizer(doubleTapGestrue)
        
        tapGestrue.require(toFail: doubleTapGestrue)
        
        if let urlString = self.photoInfo["url"] {
            if let url = URL(string: "https://ezv.kr:4447/voting/upload/photo/\(urlString)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
                self.photoImageView.sd_setImage(with: url) { (image, error, casheType, url) in
                    if let image = image {
                        self.photoImage = image
                        DispatchQueue.main.async {
                            self.photoImageView.frame.size = image.size
                            self.uiUpdate(size: UIScreen.main.bounds.size)
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        UIView.animate(withDuration: coordinator.transitionDuration) {
            self.uiUpdate(size: size)
        }
    }
    
    func uiUpdate(size:CGSize){
        print("uiUpdate - not base")
        
        if let image = self.photoImage {
            if size.width < size.height {
                scrollView.frame = CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: SCREEN.HEIGHT)
                scrollView.contentInset = UIEdgeInsets(top: STATUS_BAR_HEIGHT, left: 0, bottom: SAFE_AREA, right: 0)
            }else{
                scrollView.frame = CGRect(x: 0, y: 0, width: SCREEN.HEIGHT, height: SCREEN.WIDTH)
                scrollView.contentInset = UIEdgeInsets(top: 0, left: SAFE_AREA_SIDE, bottom: BOTTOM_SAFE_AREA, right: SAFE_AREA_SIDE)
            }

            //find adaptivedScale
            let widthScale = scrollView.frame.size.width / image.size.width
            let heightScale = scrollView.frame.size.height / image.size.height
            
            scrollView.minimumZoomScale = min(widthScale, heightScale)
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
            
            scrollViewDidZoom(scrollView)
        }
    }
    
    //MARK:scrollViewDelegate
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let imageViewSize = photoImageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        if verticalPadding >= 0 || horizontalPadding >= 0{
            if scrollView.frame.size.width < scrollView.frame.size.height {
                scrollView.contentInset = UIEdgeInsets(
                    top: (verticalPadding == 0 ? STATUS_BAR_HEIGHT : verticalPadding),
                    left: horizontalPadding,
                    bottom: (verticalPadding == 0 ? SAFE_AREA : verticalPadding),
                    right: horizontalPadding)
            }else{
                scrollView.contentInset = UIEdgeInsets(
                    top: verticalPadding,
                    left: (horizontalPadding == 0 ? SAFE_AREA_SIDE : horizontalPadding),
                    bottom: (verticalPadding == 0 ? BOTTOM_SAFE_AREA : verticalPadding),
                    right: (horizontalPadding == 0 ? SAFE_AREA_SIDE : horizontalPadding))
            }
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
            scrollView.contentSize = imageViewSize
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    
    
    //MARK:Gesture
    @objc func tap( tapGesture : UITapGestureRecognizer ){
        
        self.baseVC?.tap(tapGesture: tapGesture)
        
    }
    @objc func doubleTap( tapGesture : UITapGestureRecognizer ){
        
        if self.scrollView.zoomScale != self.scrollView.minimumZoomScale {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        }else{
            self.scrollView.setZoomScale(self.scrollView.maximumZoomScale, animated: true)
        }
    }
    
    
    //MARK:NavigationItemAction
    @objc func saveImage(){
        if let image = self.photoImage {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error{
            print("save image fail \(error.localizedDescription)")
        }else{
            toastShow(message: "저장되었습니다.")
        }
    }
    
    @objc func close(){
        self.dismiss(animated: true) { }
    }
    
    
    
}



class PhotoPopUpViewContentButton: UIButton {
    
    var nameLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: self.frame.size.height * 0.4))
        nameLabel.center.y = self.frame.size.height / 2
        nameLabel.isUserInteractionEnabled = false
        self.addSubview(nameLabel)
        
    }
    
    func updateButtonName(name : String , icon : FontAwesome, iconColor : UIColor ){
        
        let attributedString = NSMutableAttributedString(string: name)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: Nanum_Barun_Gothic_OTF, size: 15)!, range: NSMakeRange(0, name.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1), range: NSMakeRange(0, name.count))

        let textAttachment = NSTextAttachment()
        let fontAwesomeImage = UIImage.fontAwesomeIcon(name: icon, style: FontAwesomeStyle.solid, textColor: iconColor, size: CGSize(width: self.frame.size.height * 0.3, height: self.frame.size.height * 0.3))
        textAttachment.image = fontAwesomeImage
        textAttachment.bounds = CGRect(origin: CGPoint(x: 0, y: (self.nameLabel.font.capHeight - fontAwesomeImage.size.height).rounded() / 2), size: fontAwesomeImage.size)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.replaceCharacters(in: NSMakeRange(0, 0), with: attrStringWithImage)
        self.nameLabel.attributedText = attributedString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




