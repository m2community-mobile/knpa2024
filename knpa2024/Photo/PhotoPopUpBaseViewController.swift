//
//  PhotoPopUpBaseViewController.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit

class PhotoPopUpBaseViewController: UIViewController {

    var isDarkBackground = false {
        willSet(newValue){
            DispatchQueue.main.async {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return isDarkBackground
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    var currentPhotoImage : UIImage?
    var pageVC : UIPageViewController!
    
    var photoInfos = [[String:Any]]()
    var startIndex = 0
    
    var nextButton : UIButton!
    var beforeButton : UIButton!
    
    var buttonBackWithSafeArea : UIView!
    var buttonBackView : UIView!
    var likeButton : PhotoPopUpViewContentButton!
    var saveButton : PhotoPopUpViewContentButton!
    var deleteButton : PhotoPopUpViewContentButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.white
  
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = mainColor
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font:UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 17.5)!]

            navigationItem.scrollEdgeAppearance = navigationBarAppearance
            navigationItem.standardAppearance = navigationBarAppearance
            navigationItem.compactAppearance = navigationBarAppearance

            setNeedsStatusBarAppearanceUpdate()
        }else{
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.barTintColor = mainColor
            navigationController?.navigationBar.isTranslucent = false
            self.extendedLayoutIncludesOpaqueBars = true
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font:UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 17.5)!]
        }
        let buttonAlpha : CGFloat = 0.8
            
        nextButton = UIButton(frame: CGRect(x: SCREEN.WIDTH - 40, y: 0, width: 40, height: 75))
        nextButton.center.y = SCREEN.HEIGHT / 2
        nextButton.backgroundColor = mainColor.withAlphaComponent(buttonAlpha)
        
        let nextButtonimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: nextButton.frame.size.width, height: nextButton.frame.size.width))
        nextButtonimageView.image = UIImage(named: "btn_d_next1")?.withRenderingMode(.alwaysTemplate)
        nextButtonimageView.center.x = nextButton.frame.size.width / 2
        nextButtonimageView.center.y = nextButton.frame.size.height / 2
        nextButtonimageView.tintColor = UIColor.white
        nextButtonimageView.isUserInteractionEnabled = false
        nextButton.addSubview(nextButtonimageView)
        
        beforeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 75))
        beforeButton.center.y = SCREEN.HEIGHT / 2
        beforeButton.backgroundColor = mainColor.withAlphaComponent(buttonAlpha)

        let beforeButtonimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: beforeButton.frame.size.width, height: beforeButton.frame.size.width))
        beforeButtonimageView.image = UIImage(named: "btn_d_back1")?.withRenderingMode(.alwaysTemplate)
        beforeButtonimageView.center.x = beforeButton.frame.size.width / 2
        beforeButtonimageView.center.y = beforeButton.frame.size.height / 2
        beforeButtonimageView.tintColor = UIColor.white
        beforeButtonimageView.isUserInteractionEnabled = false
        beforeButton.addSubview(beforeButtonimageView)
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        let buttonBackViewHeight : CGFloat = 50
        buttonBackWithSafeArea = UIView(frame: CGRect(x: 0, y: SCREEN.HEIGHT - (buttonBackViewHeight + SAFE_AREA), width: SCREEN.WIDTH, height: buttonBackViewHeight + SAFE_AREA))
        buttonBackWithSafeArea.backgroundColor = UIColor.white
        
        buttonBackView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH * 0.85, height: buttonBackViewHeight))
        buttonBackView.center.x = buttonBackWithSafeArea.frame.size.width / 2
        buttonBackWithSafeArea.addSubview(buttonBackView)
        
        let buttonWidth = buttonBackView.frame.size.width / 3
        
        likeButton = PhotoPopUpViewContentButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonBackView.frame.size.height))
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        buttonBackView.addSubview(likeButton)
        
        saveButton = PhotoPopUpViewContentButton(frame: CGRect(x: buttonBackView.frame.size.width / 3, y: 0, width: buttonWidth, height: buttonBackView.frame.size.height))
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        buttonBackView.addSubview(saveButton)
        
        deleteButton = PhotoPopUpViewContentButton(frame: CGRect(x: buttonBackView.frame.size.width * 2 / 3, y: 0, width: buttonWidth, height: buttonBackView.frame.size.height))
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        buttonBackView.addSubview(deleteButton)
                
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        let closeButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(close))
//        let closeButtonItem = UIBarButtonItem(image: UIImage(named: "btnBack1")?.withRenderingMode(.alwaysTemplate), style: UIBarButtonItem.Style.done, target: self, action: #selector(close))
        closeButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = closeButtonItem
        
        self.pageVC = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: [:])
        
        self.pageVC?.delegate = self
        self.pageVC?.dataSource = self
        
        self.currentIndex = self.startIndex
        let photoPopUpVC = makePhotoPopUpVC(index: self.startIndex)
        self.pageVC?.setViewControllers([photoPopUpVC], direction: UIPageViewController.NavigationDirection.forward, animated: true) { (fi) in  }
        
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)

        self.view.addSubview(buttonBackWithSafeArea)
        self.view.addSubview(nextButton)
        self.view.addSubview(beforeButton)
        
        
        nextButton.addTarget(event: UIControl.Event.touchUpInside) { (button) in
            print("nextButton currentIndex:\(self.currentIndex)")
            
            let nextIndex = self.currentIndex + 1
            if nextIndex < self.photoInfos.count {
                let photoPopUpVC = self.makePhotoPopUpVC(index: nextIndex)
                self.pageVC?.setViewControllers([photoPopUpVC], direction: UIPageViewController.NavigationDirection.forward, animated: true) { (fi) in }
            }
            
        }
        beforeButton.addTarget(event: UIControl.Event.touchUpInside) { (button) in
            print("nextButton currentIndex:\(self.currentIndex)")
            
            let nextIndex = self.currentIndex - 1
            if nextIndex < self.photoInfos.count {
                let photoPopUpVC = self.makePhotoPopUpVC(index: nextIndex)
                self.pageVC?.setViewControllers([photoPopUpVC], direction: UIPageViewController.NavigationDirection.reverse, animated: true) { (fi) in }
            }
        }
        
        self.uiUpdate(size: self.view.frame.size)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        UIView.animate(withDuration: coordinator.transitionDuration) {
            self.uiUpdate(size: size)
        }
    }
    
    func uiUpdate(size:CGSize){
        print("uiUpdate - base")
        if size.width < size.height {
            self.nextButton.alpha = 1
            self.beforeButton.alpha = 1
        }else{
            self.nextButton.alpha = 0
            self.beforeButton.alpha = 0
        }
    }
    
    //?/
    @objc func likeButtonPressed(){
        
        var dataDic = self.photoInfos[self.contentIndex]
        
        var nextValue = 0
        
        guard let sid = dataDic["sid"] as? String else { return print("sid is nil") }
        guard let myfav = dataDic["myfav"] as? String else { return print("myfav is nil")}
        
        guard let myfavValue = Int(myfav, radix: 10) else { return print("10진수 변환 실패") }
        if myfavValue == 0 { nextValue = 1}
        if myfavValue == 1 { nextValue = 0}
        
        let urlString = "https://ezv.kr:4447/voting/php/photo/set_favor.php?sid=\(sid)&deviceid=\(deviceID)&val=\(nextValue)"
        //        print("set urlString \(urlString)")
        Server.postData(urlString: urlString, otherInfo: [:]) { (kData : Data?) in
            if let data = kData {
                if let afterCnt = data.toString() {
                    dataDic["cnt"] = afterCnt
                    dataDic["myfav"] = myfavValue == 1 ? "0":"1"
                    self.photoInfos[self.contentIndex] = dataDic
                    self.buttonsUpdate(index: self.contentIndex)
                    
                    if myfav == "0" {
                        
                    }
                }
            }
        }
    }
    
    @objc func saveButtonPressed(){
//        var dataDic = self.photoInfos[self.contentIndex]
        self.saveImage()
    }
    
    @objc func deleteButtonPressed(){
        
        let alertCon = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        alertCon.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            
        }))
        alertCon.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            var dataDic = self.photoInfos[self.contentIndex]
            
            if let url = dataDic["url"] as? String {
                
                print("deletedurl--->\(url)")
                
                let urlString = "https://ezv.kr:4447/voting/php/photo/del_photo.php?image=\(url)"
                
                Server.postData(urlString: urlString, otherInfo: [:]) { (kData : Data?) in
                    if let data = kData {
                        if let dataString = data.toString() {
                            print("dataString:\(dataString)")
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: {
                                    toastShow(message: "삭제 완료.")
                                })
                            }
                        }
                    }
                }
            }
        }))
        self.present(alertCon, animated: true) {
            
        }
        
        
        
        
        
        
        
    }
    
    var contentIndex = 0
    func buttonsUpdate(index : Int){
        
        self.contentIndex = index
        
        let dataDic = self.photoInfos[index]
        print("dataDic : \(dataDic)")
        
        deleteButton.isHidden = true
        if let deviceIDFromImage = dataDic["deviceid"] as? String {
            if deviceIDFromImage == deviceID {
                deleteButton.isHidden = false
                deleteButton.updateButtonName(name: "  Delete", icon: .trashAlt, iconColor: #colorLiteral(red: 0.2509803922, green: 0.2470588235, blue: 0.2509803922, alpha: 1))
            }
        }
      
        if let cntString = dataDic["cnt"] as? String {
            let myfav = dataDic["myfav"] as? String
            
            if myfav == "0" {
                likeButton.updateButtonName(name: "  \(cntString) Like", icon: .heart, iconColor: .lightGray)
                
            } else {
                likeButton.updateButtonName(name: "  \(cntString) Like", icon: .heart, iconColor: .red)
            }
            
            //            likeButton.updateButtonName(name: "  \(cntString) Like", icon: .heart, iconColor: #colorLiteral(red: 0.5450980392, green: 0.05882352941, blue: 0.3725490196, alpha: 1))
            //        }else{
            //            likeButton.updateButtonName(name: "  0 Like", icon: .heart, iconColor: #colorLiteral(red: 0.9450980392, green: 0.05882352941, blue: 0.3725490196, alpha: 1))
            //        }
            
            saveButton.updateButtonName(name: "  Save", icon: .download, iconColor: #colorLiteral(red: 0.2509803922, green: 0.2470588235, blue: 0.2509803922, alpha: 1))
            
        }
//        if let cntString = dataDic["cnt"] as? String {
//            likeButton.updateButtonName(name: "  \(cntString) Like", icon: .heart, iconColor: #colorLiteral(red: 0.9450980392, green: 0.05882352941, blue: 0.3725490196, alpha: 1))
//        }else{
//            likeButton.updateButtonName(name: "  0 Like", icon: .heart, iconColor: #colorLiteral(red: 0.9450980392, green: 0.05882352941, blue: 0.3725490196, alpha: 1))
//        }
//
//        saveButton.updateButtonName(name: "  Save", icon: .download, iconColor: #colorLiteral(red: 0.2509803922, green: 0.2470588235, blue: 0.2509803922, alpha: 1))
        
    }
    
    //MARK:Gesture

    @objc func tap( tapGesture : UITapGestureRecognizer ){
        
        
        self.isDarkBackground = !self.isDarkBackground

        self.navigationController?.setNavigationBarHidden(isDarkBackground, animated: true)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.pageVC.view.backgroundColor = self.isDarkBackground ? UIColor.black : UIColor.white
            self.buttonBackView.isHidden = self.isDarkBackground
            self.buttonBackWithSafeArea.isHidden = self.isDarkBackground
            if self.isDarkBackground {
                self.beforeButton.isHidden = true
                self.nextButton.isHidden = true
            }else{
                self.beforeButton.isHidden = self.isBeforeButtonHidden
                self.nextButton.isHidden = self.isNextButtonHidden
            }
        }) { (fi) in

        }
    }
    
    func imageUpdate(image : UIImage?){
        self.currentPhotoImage = image
    }
    
    var isNextButtonHidden = false
    var isBeforeButtonHidden = false
    var currentIndex = 0
    func titleUpdate(index : Int){
        
        currentIndex = index
        isBeforeButtonHidden = (index + 1) == 1
        isNextButtonHidden = (index + 1) == photoInfos.count
        
        self.beforeButton.isHidden = isBeforeButtonHidden
        self.nextButton.isHidden = isNextButtonHidden
        
        self.title = "\(index + 1)/\(photoInfos.count)"
    }
    
    //MARK:NavigationItemAction
    @objc func saveImage(){
        if let image = self.currentPhotoImage {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }else{
            toastShow(message: "이미지 저장 실패/ 잠시 후 다시 시도해주세요.")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error{
            print("save image fail \(error.localizedDescription)")
            toastShow(message: "이미지 저장 실패/ 잠시 후 다시 시도해주세요.")
        }else{
            toastShow(message: "완료.")
        }
    }
    
    @objc func close(){
        self.dismiss(animated: true) { }
    }
}

extension PhotoPopUpBaseViewController : UIPageViewControllerDelegate ,UIPageViewControllerDataSource {
    
    //MARK:UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){

    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        
    }

    
    //MARK:UIPageViewControllerDataSource
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        if let currentVC = viewController as? PhotoPopUpViewController {
            let nextIndex = currentVC.currentIndex - 1
            if nextIndex >= 0 {
                return makePhotoPopUpVC(index: nextIndex)
            }
        }
        return nil
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        if let currentVC = viewController as? PhotoPopUpViewController {
            let nextIndex = currentVC.currentIndex + 1
            
            if nextIndex < photoInfos.count {
                return makePhotoPopUpVC(index: nextIndex)
            }
        }
        return nil
    }
    
    
    func makePhotoPopUpVC(index : Int) -> PhotoPopUpViewController{
        let photoPopUpVC = PhotoPopUpViewController()
        photoPopUpVC.currentIndex = index
        photoPopUpVC.baseVC = self
        if index < photoInfos.count {
            photoPopUpVC.photoInfo = self.photoInfos[index]
        }
        return photoPopUpVC
    }
    
}
