//
//  WebView.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit
import WebKit
import MessageUI

class WebView: UIView
,WKNavigationDelegate , WKUIDelegate//, WKScriptMessageHandler
    ,UIGestureRecognizerDelegate
{

    let isShowableTypes = ["jpeg","jpg","doc","docx","png","ppt","pptx","xlsx","xls"]
    let notShowableTypes = ["hwp","gif","ai","zip"]
    
    var documentInteractionCon : UIDocumentInteractionController?
    weak var motherVC : UIViewController?
    
    var wkWebView : WKWebView!
    var urlString = ""
    
    var glanceSubTitleString = "Program"
    
    init(frame: CGRect, urlString : String) {
        super.init(frame: frame)
        
        print("WebView url:\(urlString)")
    
        self.backgroundColor = UIColor.white
        
        self.wkWebView = WKWebView(frame: self.bounds)
        self.wkWebView.allowsLinkPreview = false
        self.wkWebView.uiDelegate = self
        self.wkWebView.navigationDelegate = self
        self.wkWebView.scrollView.bounces = false
        self.addSubview(self.wkWebView)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longGesture.delegate = self
        self.wkWebView.addGestureRecognizer(longGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPress(gesture:)))
        tapGesture.delegate = self
        self.wkWebView.addGestureRecognizer(tapGesture)
        
        self.urlString = urlString
        self.reloading()
        
        
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func tapPress( gesture : UILongPressGestureRecognizer ){
        print("tapPress")
        
     
        
        self.endEditing(true)
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
                        self.motherVC?.present(actionSheet, animated: true, completion: {
                            
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
    
    var lastX : CGFloat = 0
    var lastY : CGFloat = 0
    
    //MARK:WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        print("createWebViewWith:\(String(describing: navigationAction.request.url?.absoluteString))")
        if let absoluteString = navigationAction.request.url?.absoluteString {
            self.urlString = absoluteString
            self.reloading()
        }
        
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
    
        print("decidePolicyFor navigationAction:\(String(describing: navigationAction.request.url?.absoluteString))")
        
        if let absoluteString = navigationAction.request.url?.absoluteString {
            print("absoluteString:\(absoluteString)")
            
            var components: [String] = absoluteString.components(separatedBy: ":")
            if (components.count > 1 && components[0] == "myweb") {
                if (components[1] == "touch") {
                    if (components[2] == "start") {
                        if let ptX = Float(components[3]), let ptY = Float(components[4]) {
                            print("\(ptX),\(ptY)")
                            self.lastX = CGFloat(ptX)
                            self.lastY = CGFloat(ptY)
                            decisionHandler(.cancel); return
                        }
                    }
                }
            }
            
            if absoluteString.contains("download.php"){
                //로딩 시작
                var hud : MBProgressHUD?
                DispatchQueue.main.async {
                    hud = MBProgressHUD.showAdded(to: self, animated: true)
                }
                
                //파일 네임을 읽어오자
                Server.readFileName(urlString: urlString) { (fileName : String) in
                    //파일 네임을 읽어오는것에 대한 로딩 제거
                    DispatchQueue.main.async {
                        hud?.hide(animated: true)
                    }
                    let fileComponents = fileName.components(separatedBy: ".")
                    if fileComponents.count >= 2 {
                        let lastComponent = fileComponents[fileComponents.count - 1]
                        if lastComponent.lowercased() == "pdf" {    //PDF
                            if let url = URL(string: absoluteString), let motherVC = self.motherVC {
                                showPDF(fileURL: url, inView: self, fileName: fileName, viewCon: motherVC)
                                return
                            }
                        }else if self.isShowableTypes.contains(lastComponent.lowercased()){
                            let popUpVC = WebPopUpViewController()
                            popUpVC.urlString = absoluteString
                            popUpVC.modalPresentationStyle = .fullScreen
                            self.motherVC?.present(popUpVC, animated: true, completion: {
                                
                            })
                            return
                        }else {
                            if let url = URL(string: absoluteString) {
                                var newFileName = fileName
                                if let removeEncodingFileName = fileName.removingPercentEncoding {
                                    newFileName = removeEncodingFileName
                                }
                                showETC(fileURL: url, inView: self, fileName: newFileName) { (fileURL) in
                                    self.documentInteractionCon = UIDocumentInteractionController(url: fileURL)
                                    self.documentInteractionCon?.presentOptionsMenu(from: CGRect.zero, in: self, animated: true)
                                }
                                return
                            }
                        }
                    }
                }
                decisionHandler(.cancel); return
            }
            
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
                if isLogin {
                    decisionHandler(.allow); return
                }else{
                    showLoginAlert()
                    decisionHandler(.cancel); return
                }
            }
            
            if absoluteString.contains("session/social.php") {
                print("social absoluteString:\(absoluteString)")
                
                let parameterValues = absoluteString.replacingOccurrences(of: "https://ezv.kr:4447/voting/php/session/social.php?", with: "")
                let parameters = absoluteString.removingPercentEncoding?.parameterFromURL()
                let title = parameters?["title"]?.removingPercentEncoding ?? ""
                print("title : \(title)")
                let newURL = "- 대한신경정신의학회 추계학술대회\n- \(title)\nhttps://ezv.kr:4447/knpa/schem.php?\(parameterValues)"
                print("newURL:\(newURL)")
                //                let activity = TUSafariActivity()
                //                let activityVC = UIActivityViewController(activityItems: [newURL], applicationActivities: [activity])
                let activityVC = UIActivityViewController(activityItems: [newURL], applicationActivities: [])
                self.motherVC?.present(activityVC, animated: true, completion: {
                    
                })
                decisionHandler(.cancel); return
            }
            
            if absoluteString.contains("glance_sub.php") {
                print("glance_sub.php")


                loginCheckWithShow {

                    let glanceSubPopUpWC = GlanceSubWebController()
                    glanceSubPopUpWC.glanceSubTitleString = self.glanceSubTitleString
                    var newURL = absoluteString
                    if !newURL.contains("title=") {
                        newURL = "\(newURL)&title=\(self.glanceSubTitleString)".addPercenterEncoding()
                    }
                    glanceSubPopUpWC.urlString = newURL
                    glanceSubPopUpWC.modalPresentationStyle = .fullScreen
                    self.motherVC?.present(glanceSubPopUpWC, animated: true, completion: {

                    })
                }
                decisionHandler(.cancel)
                return
            }
            
//            if absoluteString.contains("glance.php") {
//                //                goPAG()
//                decisionHandler(.cancel); return
//            }
            
            if absoluteString.contains("back.php"){
                if self.wkWebView.canGoBack {
                    self.wkWebView.goBack()
                    decisionHandler(.cancel); return
                }else{
                    appDel.naviCon?.popViewController(animated: true)
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
                                toastShow(message: "알람 추가 완료.")
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
                    
                    //todo
                    if let sid = parameterDic["sid"] {
                        NotiCenter.shared.removeAlram(id: sid)
                        toastShow(message: "알람 삭제 완료.")
                    }
                    
                }
                decisionHandler(.cancel); return
            }
        
            let urlComponents = absoluteString.components(separatedBy: ".")
            if let lastComponent = urlComponents.last {
                print("lastComponent:\(lastComponent)")
                
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
                }else if lastComponent == "pdf" {
                    let pdfURLString = absoluteString.addPercenterEncoding()
                    if let url = URL(string: pdfURLString), let motherVC = self.motherVC {
                        showPDF(fileURL: url, inView: self, fileName: nil, viewCon: motherVC)
                        decisionHandler(.cancel)
                        return
                    }
                }else if isShowableTypes.contains(lastComponent.lowercased()){
                    let popUpVC = WebPopUpViewController()
                    popUpVC.urlString = absoluteString
                    popUpVC.modalPresentationStyle = .fullScreen
                    self.motherVC?.present(popUpVC, animated: true, completion: {
                        
                    })
                    decisionHandler(.cancel)
                    return
                }else if notShowableTypes.contains(lastComponent.lowercased()){
                    let fileURLString = absoluteString.addPercenterEncoding()
                    if let url = URL(string: fileURLString) {
                        showETC(fileURL: url, inView: self, fileName: nil) { (fileURL) in
                            self.documentInteractionCon = UIDocumentInteractionController(url: fileURL)
                            self.documentInteractionCon?.presentOptionsMenu(from: CGRect.zero, in: self, animated: true)
                        }
                        decisionHandler(.cancel)
                        return
                    }
                }
            }
        
            if !absoluteString.contains(URL_KEY.BASE_URL) && !absoluteString.contains(URL_KEY.EZV_URL){
                //about:blank
                if absoluteString.contains("https://www.google.com/maps") || absoluteString.contains("about:blank"){
                    decisionHandler(.allow)
                    return
                }
                
                print("not contains")
                let popUpVC = WebPopUpViewController()
                popUpVC.urlString = absoluteString
                popUpVC.modalPresentationStyle = .fullScreen
                self.motherVC?.present(popUpVC, animated: true, completion: {

                })
                decisionHandler(.cancel)
                return
            }
        }
        
        decisionHandler(.allow)
    }

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
        print("error : \(error.localizedDescription)")
//        self.endEditing(true)

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
        webView.evaluateJavaScript(kTouchJavaScriptString) { (result : Any?, error : Error?) in  }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        print(#function)
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
        self.motherVC?.present(alertCon, animated: true, completion: {})
        
        while confirmPanelValue == 0 {
            RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.01))
        }
        
        if confirmPanelValue == 1 {
            completionHandler(true)
        }else{
            completionHandler(false)
        }
        
        
    }
    
//    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
//
//
//        completionHandler(nil)
//    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension WebView : MFMailComposeViewControllerDelegate,UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            
        }
    }
}


extension WKWebView {
    
    func readImageFrom(point : CGPoint, complete:@escaping(_ image : UIImage?) -> Void ) {
        
        let js = "document.elementFromPoint(\(point.x), \(point.y)).tagName"
        var tagName = ""
        
        self.evaluateJavaScript(js) { (result : Any?, error : Error?) in
            tagName = result as? String ?? ""
            if tagName == "IMG" {
                print("tagName == IMG")
                var imageURLString = ""
                self.evaluateJavaScript("document.elementFromPoint(\(point.x), \(point.y)).src") { (result : Any?, error : Error?) in
                    imageURLString = result as? String ?? ""
                    //                    print("imageURLString:\(imageURLString)")
                    
                    if let imageURL = URL(string: imageURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!){
                        if let imageData = try? Data(contentsOf: imageURL) {
                            if let image = UIImage(data: imageData) {
                                complete(image)
                                return
                            }
                        }
                    }
                }
            }
            
            complete(nil)
            return
        }
    }
    
    func touchCalloutNone(){
        let javaCode = "document.body.style.webkitTouchCallout='none';"
        self.evaluateJavaScript(javaCode)  { (result : Any?, error : Error?) in
            print("after touchCalloutNone")
            
            
            

            

            if let error = error {
                print("error : \(error.localizedDescription)")
            }
        }
    }
}

