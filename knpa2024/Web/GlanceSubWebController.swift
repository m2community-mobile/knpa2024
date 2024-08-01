//
//  GlanceSubWebController.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit
import WebKit
import MessageUI

class GlanceSubWebController: UIViewController
,WKNavigationDelegate , WKUIDelegate
{
 
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    var wkWebView : WKWebView!
    var urlString = ""
    
    let isShowableTypes = ["jpeg","jpg","doc","docx","png","ppt","pptx","xlsx","xls"]
    let notShowableTypes = ["hwp","gif","ai","zip"]

    var documentInteractionCon : UIDocumentInteractionController?

    weak var motherVC : UIViewController?
    
    var glanceSubTitleString = "Program"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.motherVC = self
        
        self.view.backgroundColor = UIColor.white
        
        let webViewFrame = CGRect(x: 0, y: STATUS_BAR_HEIGHT, width: SCREEN.WIDTH, height: SCREEN.HEIGHT - STATUS_BAR_HEIGHT - SAFE_AREA)
        self.wkWebView = WKWebView(frame: webViewFrame)
        self.wkWebView.allowsLinkPreview = false
        self.wkWebView.uiDelegate = self
        self.wkWebView.navigationDelegate = self
        self.wkWebView.scrollView.bounces = false
        self.view.addSubview(self.wkWebView)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longGesture.delegate = self
        self.wkWebView.addGestureRecognizer(longGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPress(gesture:)))
        tapGesture.delegate = self
        self.wkWebView.addGestureRecognizer(tapGesture)
     
        self.reloading()
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        closeButton.center = CGPoint(x: SCREEN.WIDTH - 20, y: STATUS_BAR_HEIGHT + 20)
        closeButton.setImage(UIImage(named: "b_card_close"), for: .normal)
        closeButton.addTarget(event: .touchUpInside) { (button) in
            self.dismiss(animated: true, completion: {
                
            })
        }
        self.view.addSubview(closeButton)
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (noti : Notification) in
            let nextPoint = CGPoint(x: 0, y: self.wkWebView.scrollView.contentSize.height - self.wkWebView.scrollView.frame.size.height)
            if self.wkWebView.scrollView.contentOffset.y > nextPoint.y {
                self.wkWebView.scrollView.setContentOffset(nextPoint, animated: true)
            }
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
      }
    
    @objc func tapPress( gesture : UILongPressGestureRecognizer ){
        print("tapPress")
        self.view.endEditing(true)
    }
    
    func reloading(){
        
        var newURLString = self.urlString.addParameterToURLString(key: "deviceid", value: deviceID)
        newURLString = newURLString.addParameterToURLString(key: "device", value: "IOS")
        if name_id != "" { newURLString = newURLString.addParameterToURLString(key: "name", value: name_id) }
        if license_id != "" { newURLString = newURLString.addParameterToURLString(key: "license_number", value: license_id) }
        newURLString = newURLString.addPercenterEncoding()
        
        if let url = URL(string: newURLString) {
            let request = URLRequest(url: url)
            //            if isLogin { //add Cookie
            //                request.httpMethod = "POST"
            //                request.addValue("member_id=\(member_id); member_level=\(member_level)", forHTTPHeaderField: "Cookie")
            //            }
            self.wkWebView.load(request)
        }else{
            print("urlErro : \(urlString)")
            toastShow(message: "인터넷 연결을 확인 해주세요.")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func longPress( gesture : UILongPressGestureRecognizer ){
        
        if gesture.state == .began {
            print("longPress began")

            self.wkWebView.readImageFrom(point: CGPoint(x: self.lastX, y: self.lastY)) { (image) in
                if let image = image {
                    print("이미지 있음")
                    
                    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                        
                    }))
                    actionSheet.addAction(UIAlertAction(title: "Save Image", style: UIAlertAction.Style.default, handler: { (action) in
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    }))
                    DispatchQueue.main.async {
                        self.present(actionSheet, animated: true, completion: {
                            
                        })
                    }
                    
                }
            }
            
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error{
            print("save image fail \(error.localizedDescription)")
        }else{
            toastShow(message: "완료.")
        }
    }
    
    var lastX : CGFloat = 0
    var lastY : CGFloat = 0
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
        
//        print("decidePolicyFor navigationAction:\(String(describing: navigationAction.request.url?.absoluteString))")
        
        if let absoluteString = navigationAction.request.url?.absoluteString {
            
            let components: [String] = absoluteString.components(separatedBy: ":")
            if (components.count > 1 && components[0] == "myweb") {
                if (components[1] == "touch") {
                    if (components[2] == "start") {
                        if let ptX = Float(components[3]), let ptY = Float(components[4]) {
//                            print("\(ptX),\(ptY)")
                            self.lastX = CGFloat(ptX)
                            self.lastY = CGFloat(ptY)
                            decisionHandler(.cancel); return
                        }
                    }
                }
            }
            
            print("absoluteString:\(absoluteString)")
            
            if absoluteString.contains("app_question.php") {
                let parameterDic = absoluteString.parameterFromURL()
                if let sid = parameterDic["sid"] {
                    let appQuestionVC = AppQuestionViewController()
                    appQuestionVC.session_sid = sid
                    appQuestionVC.modalPresentationStyle = .fullScreen
                    self.motherVC?.present(appQuestionVC, animated: true, completion: { })
                }
                decisionHandler(.cancel); return
            }
            
            if absoluteString.contains("tel:") {
                let newURLString = absoluteString.replacingOccurrences(of: "tel:", with: "tel://")
                if let callUrl = URL(string: newURLString) {
                    UIApplication.shared.open(callUrl, options: [:]) { (fi) in
                        
                    }
                }
                decisionHandler(.cancel); return
            }
            
            if absoluteString.contains("blob:"){
                print("blob: urlString : \(absoluteString)")
                decisionHandler(.cancel); return
            }
            
            if absoluteString.contains("session/view.php") {
                //?/
                var newURL = absoluteString
                if !newURL.contains("title=") {
                    newURL = "\(newURL)&title=\(self.glanceSubTitleString)".addPercenterEncoding()
                    self.urlString = newURL
                    self.reloading()
                    decisionHandler(.cancel); return
                }
                decisionHandler(.allow); return
            }
            
            if absoluteString.contains("glance.php") {
                //                goPAG()
                decisionHandler(.cancel); return
            }
            
            if absoluteString.contains("back.php"){
                if self.wkWebView.canGoBack {
                    self.wkWebView.goBack()
                    decisionHandler(.cancel); return
                }else{
                    self.dismiss(animated: true) {
                        
                    }
//                    appDel.naviCon?.popViewController(animated: true)
                    decisionHandler(.cancel); return
                }
            }
            if absoluteString.contains("close.php"){
                if let naviCon = self.motherVC?.navigationController {
                    naviCon.popViewController(animated: true)
                }else{
                    self.motherVC?.dismiss(animated: true, completion: {
                        
                    })
                }
                decisionHandler(.cancel); return
            }
            
            if absoluteString.contains("add_alarm.php") {
                print("addAlarm - \(absoluteString)")
                
                let urlComponnents = absoluteString.components(separatedBy: "?")
                if urlComponnents.count == 2 {
                    let parameterString = urlComponnents[1]
                    let parameterComponents = parameterString.components(separatedBy: "&")
                    var parameterDic = [String:String]()
                    for i in 0..<parameterComponents.count {
                        let parameters = parameterComponents[i].components(separatedBy: "=")
                        if parameters.count == 2{
                            parameterDic[parameters[0]] = parameters[1]
                        }
                    }
                    print("parameterDic:\(parameterDic)")
                    
                    NotiCenter.shared.addAlram(dataDic: parameterDic) { (success) in
                        DispatchQueue.main.async {
                            if success {
                                toastShow(message: "Add alarm complete.")
                            }else{
                                //                                toastShow(message: "Add Alram is fail. Retry after few minite.")
                            }
                        }
                    }
                }
                decisionHandler(.cancel); return
            }
            if absoluteString.contains("remove_alarm.php") {
                print("removeAlram - \(absoluteString)")
                
                let urlComponnents = absoluteString.components(separatedBy: "?")
                if urlComponnents.count == 2 {
                    let parameterString = urlComponnents[1]
                    let parameterComponents = parameterString.components(separatedBy: "&")
                    var parameterDic = [String:String]()
                    for i in 0..<parameterComponents.count {
                        let parameters = parameterComponents[i].components(separatedBy: "=")
                        if parameters.count == 2{
                            parameterDic[parameters[0]] = parameters[1]
                        }
                    }
                    print("parameterDic:\(parameterDic)")
                    
                    if let sid = parameterDic["sid"] {
                        NotiCenter.shared.removeAlram(id: sid)
                        toastShow(message: "Remove alarm complete.")
                    }
                    
                }
                decisionHandler(.cancel); return
            }
            
            if absoluteString.contains("vimeo") {
                decisionHandler(.allow); return
            }
            
            let urlComponents = absoluteString.components(separatedBy: ".")
            if let lastComponent = urlComponents.last {
//                print("lastComponent:\(lastComponent)")
                
                if absoluteString.contains("mailto") {
                    if MFMailComposeViewController.canSendMail() {
                        let mailVC = MFMailComposeViewController()
                        if let mailURLString = absoluteString.subString(from: "mailto:".count) {
                            mailVC.setToRecipients([mailURLString])
                            mailVC.mailComposeDelegate = self
                            mailVC.modalPresentationStyle = .fullScreen
                            self.motherVC?.present(mailVC, animated: true, completion: { })
                        }
                    }else{
                        print("메일 설정이 안되어있음")
                        DispatchQueue.main.async {
                            toastShow(message: "메일이 설정되어있지 않습니다.\n설정 앱을 통해 메일 설정을 해주세요.")
                        }
                    }
                    decisionHandler(.cancel)
                    return
                }else if lastComponent.lowercased() == "pdf" {
                    let pdfURLString = absoluteString.addPercenterEncoding()
                    if let url = URL(string: pdfURLString), let motherVC = self.motherVC {
                        showPDF(fileURL: url, inView: self.view, fileName: nil, viewCon: motherVC)
                        decisionHandler(.cancel)
                        return
                    }
                }else if isShowableTypes.contains(lastComponent){
                    let popUpVC = WebPopUpViewController()
                    popUpVC.urlString = absoluteString
                    popUpVC.modalPresentationStyle = .fullScreen
                    self.motherVC?.present(popUpVC, animated: true, completion: {
                        
                    })
                    decisionHandler(.cancel)
                    return
                }else if notShowableTypes.contains(lastComponent){
                    let fileURLString = absoluteString.addPercenterEncoding()
                    if let url = URL(string: fileURLString) {
                        showETC(fileURL: url, inView: self.view, fileName: nil) { (fileURL) in
                            self.documentInteractionCon = UIDocumentInteractionController(url: fileURL)
                            self.documentInteractionCon?.presentOptionsMenu(from: CGRect.zero, in: self.view, animated: true)
                        }
                        decisionHandler(.cancel)
                        return
                    }
                }
            }
            
            if absoluteString.contains("session/social.php") {
                
                if navigationAction.targetFrame == nil {
                        if let url = navigationAction.request.url {
                            let app = UIApplication.shared
                            if app.canOpenURL(url) {
                                app.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    decisionHandler(.allow)
                decisionHandler(.cancel); return
            }
            
            if !absoluteString.contains(URL_KEY.BASE_URL) && !absoluteString.contains(URL_KEY.EZV_URL){
                //about:blank
                if absoluteString.contains("https://www.google.com/maps") || absoluteString.contains("about:blank"){
                    decisionHandler(.allow)
                    return
                }
                
                print("not contains")
                
                if let url = URL(string: absoluteString) {
                    UIApplication.shared.open(url, options: [:]) { (fi) in }
                    decisionHandler(.cancel)
                    return
                }
                
                
//                let popUpVC = WebPopUpViewController()
//                popUpVC.urlString = absoluteString
//                popUpVC.modalPresentationStyle = .fullScreen
//                self.motherVC?.present(popUpVC, animated: true, completion: {
//
//                })
//                decisionHandler(.cancel)
//                return
            }
        }
        
        decisionHandler(.allow)
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
//        
//        if navigationAction.targetFrame == nil {
//            if let url = navigationAction.request.url {
//                let app = UIApplication.shared
//                if app.canOpenURL(url) {
//                    app.open(url, options: [:], completionHandler: nil)
//                }
//            }
//        }
//        decisionHandler(.allow)
//        
//        print("decidePolicyFor navigationAction:\(String(describing: navigationAction.request.url?.absoluteString))")
//        
//        if let absoluteString = navigationAction.request.url?.absoluteString {
//            print("absoluteString:\(absoluteString)")
//            
//            var components: [String] = absoluteString.components(separatedBy: ":")
//            if (components.count > 1 && components[0] == "myweb") {
//                if (components[1] == "touch") {
//                    if (components[2] == "start") {
//                        if let ptX = Float(components[3]), let ptY = Float(components[4]) {
//                            print("\(ptX),\(ptY)")
//                            self.lastX = CGFloat(ptX)
//                            self.lastY = CGFloat(ptY)
//                            decisionHandler(.cancel); return
//                        }
//                    }
//                }
//            }
//            
//            if absoluteString.contains("app_question.php") {
//                let parameterDic = absoluteString.parameterFromURL()
//                if let sid = parameterDic["sid"] {
//                    let appQuestionVC = AppQuestionViewController()
//                    appQuestionVC.session_sid = sid
//                    appQuestionVC.modalPresentationStyle = .fullScreen
//                    self.motherVC?.present(appQuestionVC, animated: true, completion: { })
//                }
//                decisionHandler(.cancel); return
//            }
//            
//            if absoluteString.contains("tel:") {
//                let newURLString = absoluteString.replacingOccurrences(of: "tel:", with: "tel://")
//                if let callUrl = URL(string: newURLString) {
//                    UIApplication.shared.open(callUrl, options: [:]) { (fi) in
//                        
//                    }
//                }
//                decisionHandler(.cancel); return
//            }
//            
//            if absoluteString.contains("blob:"){
//                print("blob: urlString : \(absoluteString)")
//                decisionHandler(.cancel); return
//            }
//            
//            if absoluteString.contains("session/view.php") {
//                //?/
//                if isLogin {
//                    var newURL = absoluteString
//                    if !newURL.contains("title=") {
//                        newURL = "\(newURL)&title=\(self.glanceSubTitleString)".addPercenterEncoding()
//                        self.urlString = newURL
//                        self.reloading()
//                        decisionHandler(.cancel); return
//                    }
//                }else{
//                    showLoginAlert()
//                }
//                decisionHandler(.allow); return
//            }
//            
//            if absoluteString.contains("session/social.php") {
//                print("social absoluteString:\(absoluteString)")
//                
//                let parameterValues = absoluteString.replacingOccurrences(of: "https://ezv.kr:4447/voting/php/session/social.php?", with: "")
//                let parameters = absoluteString.removingPercentEncoding?.parameterFromURL()
//                let title = parameters?["title"]?.removingPercentEncoding ?? ""
//                print("title : \(title)")
//                let newURL = "- 대한신경정신의학회 추계학술대회\n- \(title)\nhttps://ezv.kr:4447/knpa/schem.php?\(parameterValues)"
//                print("newURL:\(newURL)")
//                //                let activity = TUSafariActivity()
//                //                let activityVC = UIActivityViewController(activityItems: [newURL], applicationActivities: [activity])
//                let activityVC = UIActivityViewController(activityItems: [newURL], applicationActivities: [])
//                self.motherVC?.present(activityVC, animated: true, completion: {
//                    
//                })
//                decisionHandler(.cancel); return
//            }
//            
//            if absoluteString.contains("glance.php") {
//                //                goPAG()
//                decisionHandler(.cancel); return
//            }
//            
//            if absoluteString.contains("back.php"){
//                if self.wkWebView.canGoBack {
//                    self.wkWebView.goBack()
//                    decisionHandler(.cancel); return
//                }else{
//                    self.dismiss(animated: true) {
//                        
//                    }
////                    appDel.naviCon?.popViewController(animated: true)
//                    decisionHandler(.cancel); return
//                }
//            }
//            if absoluteString.contains("close.php"){
//                if let naviCon = self.motherVC?.navigationController {
//                    naviCon.popViewController(animated: true)
//                }else{
//                    self.motherVC?.dismiss(animated: true, completion: {
//                        
//                    })
//                }
//                decisionHandler(.cancel); return
//            }
//            
//            if absoluteString.contains("add_alarm.php") {
//                print("addAlarm - \(absoluteString)")
//                
//                let urlComponnents = absoluteString.components(separatedBy: "?")
//                if urlComponnents.count == 2 {
//                    let parameterString = urlComponnents[1]
//                    let parameterComponents = parameterString.components(separatedBy: "&")
//                    var parameterDic = [String:String]()
//                    for i in 0..<parameterComponents.count {
//                        let parameters = parameterComponents[i].components(separatedBy: "=")
//                        if parameters.count == 2{
//                            parameterDic[parameters[0]] = parameters[1]
//                        }
//                    }
//                    print("parameterDic:\(parameterDic)")
//                    
//                    NotiCenter.shared.addAlram(dataDic: parameterDic) { (success) in
//                        DispatchQueue.main.async {
//                            if success {
//                                toastShow(message: "알람 추가 완료.")
//                            }else{
//                                //                                toastShow(message: "Add Alram is fail. Retry after few minite.")
//                            }
//                        }
//                    }
//                }
//                decisionHandler(.cancel); return
//            }
//            if absoluteString.contains("remove_alarm.php") {
//                print("removeAlram - \(absoluteString)")
//                
//                let urlComponnents = absoluteString.components(separatedBy: "?")
//                if urlComponnents.count == 2 {
//                    let parameterString = urlComponnents[1]
//                    let parameterComponents = parameterString.components(separatedBy: "&")
//                    var parameterDic = [String:String]()
//                    for i in 0..<parameterComponents.count {
//                        let parameters = parameterComponents[i].components(separatedBy: "=")
//                        if parameters.count == 2{
//                            parameterDic[parameters[0]] = parameters[1]
//                        }
//                    }
//                    print("parameterDic:\(parameterDic)")
//                    
//                    if let sid = parameterDic["sid"] {
//                        NotiCenter.shared.removeAlram(id: sid)
//                        toastShow(message: "알람 삭제 완료.")
//                    }
//                    
//                }
//                decisionHandler(.cancel); return
//            }
//            
//            let urlComponents = absoluteString.components(separatedBy: ".")
//            if let lastComponent = urlComponents.last {
//                print("lastComponent:\(lastComponent)")
//                
//                if absoluteString.contains("mailto") {
//                    if MFMailComposeViewController.canSendMail() {
//                        let mailVC = MFMailComposeViewController()
//                        if let mailURLString = absoluteString.subString(from: "mailto:".count) {
//                            mailVC.setToRecipients([mailURLString])
//                            mailVC.mailComposeDelegate = self
//                            mailVC.modalPresentationStyle = .fullScreen
//                            self.motherVC?.present(mailVC, animated: true, completion: { })
//                        }
//                    }else{
//                        print("메일 설정이 안되어있음")
//                        DispatchQueue.main.async {
//                            toastShow(message: "메일이 설정되어있지 않습니다.\n설정 앱을 통해 메일 설정을 해주세요.")
//                        }
//                    }
//                    decisionHandler(.cancel)
//                    return
//                }else if lastComponent == "pdf" {
//                    let pdfURLString = absoluteString.addPercenterEncoding()
//                    if let url = URL(string: pdfURLString), let motherVC = self.motherVC {
//                        showPDF(fileURL: url, inView: self.view, fileName: nil, viewCon: motherVC)
//                        decisionHandler(.cancel)
//                        return
//                    }
//                }else if isShowableTypes.contains(lastComponent){
//                    let popUpVC = WebPopUpViewController()
//                    popUpVC.urlString = absoluteString
//                    popUpVC.modalPresentationStyle = .fullScreen
//                    self.motherVC?.present(popUpVC, animated: true, completion: {
//                        
//                    })
//                    decisionHandler(.cancel)
//                    return
//                }else if notShowableTypes.contains(lastComponent){
//                    let fileURLString = absoluteString.addPercenterEncoding()
//                    if let url = URL(string: fileURLString) {
//                        showETC(fileURL: url, inView: self.view, fileName: nil) { (fileURL) in
//                            self.documentInteractionCon = UIDocumentInteractionController(url: fileURL)
//                            self.documentInteractionCon?.presentOptionsMenu(from: CGRect.zero, in: self.view, animated: true)
//                        }
//                        decisionHandler(.cancel)
//                        return
//                    }
//                }
//            }
//            
//            if !absoluteString.contains(URL_KEY.BASE_URL) && !absoluteString.contains(URL_KEY.EZV_URL){
//                //about:blank
//                if absoluteString.contains("https://www.google.com/maps") || absoluteString.contains("about:blank"){
//                    decisionHandler(.allow)
//                    return
//                }
//                
//                print("not contains")
//                let popUpVC = WebPopUpViewController()
//                popUpVC.urlString = absoluteString
//                popUpVC.modalPresentationStyle = .fullScreen
//                self.motherVC?.present(popUpVC, animated: true, completion: {
//                    
//                })
//                decisionHandler(.cancel)
//                return
//            }
//        }
//        
//        decisionHandler(.allow)
//    }
    func webViewDidClose(_ webView: WKWebView){
        print(#function)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        print(#function)
    }
    
    
    //MARK:WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        print(#function)
    }
    
    
    
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!){
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        print(#function)
//        self.view.endEditing(true)
//        webView.scrollView.contentOffset = CGPoint.zero
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print(#function)
        webView.touchCalloutNone()
        
        let kTouchJavaScriptString: String = """
document.ontouchstart=function(event){
x=event.targetTouches[0].clientX;
y=event.targetTouches[0].clientY;
document.location=\"myweb:touch:start:\"+x+\":\"+y;
};
"""
        webView.evaluateJavaScript(kTouchJavaScriptString) { (result : Any?, error : Error?) in
            print("Error : \(String(describing: error))")
            print("result : \(String(describing: result))")
        }
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        UIAlertController.showAlert(title: "안내", message: message)
        
        completionHandler()
    }
    
    var confirmPanelValue = 0
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        self.confirmPanelValue = 0
        
        let alertCon = UIAlertController(title: "안내", message: message, preferredStyle: UIAlertController.Style.alert)
        alertCon.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
            self.confirmPanelValue = 1
        }))
        alertCon.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: { (action) in
            self.confirmPanelValue = 2
        }))
        self.present(alertCon, animated: true, completion: {})
        
        while confirmPanelValue == 0 {
            RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.01))
        }
        
        if confirmPanelValue == 1 {
            completionHandler(true)
        }else{
            completionHandler(false)
        }
        
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        print(#function)
    }

}
extension GlanceSubWebController : MFMailComposeViewControllerDelegate,UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            
        }
    }
}
