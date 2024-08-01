//
//  AppDelegate.swift
//  knpa2021f
//
//  Created by JinGu's iMac on 2021/09/29.
//

import UIKit
import Firebase
import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mainCon : MainViewController?
    var naviCon : NotRotatableNavigationController?
    
    var leftView : LeftView?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = urlComponents?.queryItems
        
        var itemDic = [String:Any]()
        if let items = items {
            for i in 0..<items.count {
                itemDic[items[i].name] = items[i].value
            }
        }
        
        if let sid = itemDic["sid"] as? String {
            let urlString = "https://ezv.kr:4447/voting/php/session/view.php?sid=\(sid)&code=\(code)&deviceid=\(deviceID)"
            print("urlString:\(urlString)")
            allDismiss {
                DispatchQueue.main.async {
                    goURL(urlString: urlString)
                }
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        WebCacheCleaner.clean()
        
        addKeyboardObserver()
        
        
        FirebaseApp.configure()
        NotiCenter.shared.authorizationCheck()
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        mainCon = MainViewController()
        naviCon = NotRotatableNavigationController(rootViewController: mainCon!)
        naviCon?.isNavigationBarHidden = true
        
        window?.rootViewController = naviCon
        
        window?.makeKeyAndVisible()
        
        self.leftView = LeftView()
        self.window?.addSubview(self.leftView!)
        
//        sleep(2)
        
        return true
        
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.allButUpsideDown
    }
}

