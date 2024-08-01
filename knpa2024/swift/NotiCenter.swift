//
//  NotiCenter.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class NotiCenter: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {

    static let shared : NotiCenter = {
        let sharedCenter = NotiCenter()
        return sharedCenter
    }()

    let notiCenter = UNUserNotificationCenter.current()

    func authorizationCheck() {
        notiCenter.requestAuthorization(options: [.alert,.sound,.badge]) { ( authorization: Bool, error : Error?) in
            if let error = error {
                print("requestAuthorization error : \(error)")
            }else{
                if !authorization {
                    print("권한부여를 해야한다는 안내")
                }else{
                    print("OK")

                    self.notiCenter.delegate = self
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }

                    Messaging.messaging().delegate = self

                    Messaging.messaging().token { token, error in
                        if let error = error {
                            print("Messaging.messaging().error : \(error.localizedDescription)")
                        }else{
                            if let token = token {
                                print("Messaging.messaging().token :\(token)")
                                self.setToken(token: token)
                            }
                        }
                    }
                    
//                    InstanceID.instanceID().instanceID(handler: { (instantIDResult : InstanceIDResult? , error : Error?) in
//                        if let error = error {
//                            print("instanceID(handler error : \(error.localizedDescription)")
//                        }else{
//                            if let token = instantIDResult?.token {
//                                print("instanceID(handler token :\(token)")
//                                self.setToken(token: token)
//                            }
//
//                        }
//                    })

                    //

                    //처음 실행일때는 알람 제거
                    //ios10에서 앱 삭제 후에도 알람이 남아있는 이슈가 있음
                    let IS_FIRST = "IS_FIRST"
                    if let _ = UserDefaults.standard.object(forKey: IS_FIRST) as? String {
                        //not first
                        print("not first")
                    }else{
                        //is first
                        print("is first")
                        self.notiCenter.removeAllDeliveredNotifications()
                        self.notiCenter.removeAllPendingNotificationRequests()

                        UserDefaults.standard.set(IS_FIRST, forKey: IS_FIRST)
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }

    
    
    //========================================================================//
    //                   UNUserNotificationCenterDelegate                     //
    //========================================================================//



    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {

        print("willPresent:\(notification)")

        if notification.request.trigger!.isKind(of: UNCalendarNotificationTrigger.self ){
            print("로컬노티")
            let alertCon = UIAlertController(title: notification.request.content.title, message: notification.request.content.body, preferredStyle: UIAlertController.Style.alert)
            alertCon.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                appDel.allDismiss {
                    goURL(urlString: URL_KEY.mySchedule)
                }
            }))
            alertCon.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.default, handler: { (action) in }))
            
            appDel.topVC?.present(alertCon, animated: true, completion: { })
        }else{
            print("푸쉬노티")
            let userInfo = notification.request.content.userInfo
            if let sid = userInfo["sid"] as? String {
                let alertCon = UIAlertController(title: notification.request.content.title, message: notification.request.content.body, preferredStyle: UIAlertController.Style.alert)
                alertCon.addAction(UIAlertAction(title: "보기", style: UIAlertAction.Style.default, handler: { (action) in
                    appDel.allDismiss {
                        goURL(urlString:"\(URL_KEY.noticeView)&sid=\(sid)")
                    }
                }))
                alertCon.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.default, handler: { (action) in }))
                
                appDel.topVC?.present(alertCon, animated: true, completion: { })
            }
        }
        
        if UIApplication.shared.applicationState == .active {
            completionHandler([])
        }else{
            completionHandler([.alert,.sound]) //호출을 해야 실제로 알람 등이 울린다.
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void){

        print("didReceive response:\(response)")

        if response.notification.request.trigger!.isKind(of: UNCalendarNotificationTrigger.self ){
            let alertCon = UIAlertController(title: response.notification.request.content.title, message: response.notification.request.content.body, preferredStyle: UIAlertController.Style.alert)
            alertCon.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                appDel.allDismiss {
                    goURL(urlString: URL_KEY.mySchedule)
                }
            }))
            alertCon.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.default, handler: { (action) in }))
            
            appDel.topVC?.present(alertCon, animated: true, completion: { })
        }else{
            let userInfo = response.notification.request.content.userInfo
            if let sid = userInfo["sid"] as? String {
                let alertCon = UIAlertController(title: response.notification.request.content.title, message: response.notification.request.content.body, preferredStyle: UIAlertController.Style.alert)
                alertCon.addAction(UIAlertAction(title: "보기", style: UIAlertAction.Style.default, handler: { (action) in
                    appDel.allDismiss {
                        goURL(urlString:"\(URL_KEY.noticeView)&sid=\(sid)")
                    }
                }))
                alertCon.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.default, handler: { (action) in
                    
                }))
                
                appDel.topVC?.present(alertCon, animated: true, completion: { })
            }
        }

        //호출된 배너를 눌렀을때
        completionHandler()
    }

    //========================================================================//
    //                           MessagingDelegate                            //
    //========================================================================//

    func setToken(token : String){
        
        userD.set(token, forKey: TOKEN_ID)
        userD.synchronize()
        
        let urlString = "https://ezv.kr:4447/voting/php/token.php"
        let sendDataDic = [
            "device":"IOS",
            "device_id":deviceID,
            "token":token,
            "code":code
        ]
        print("add_push :\(sendDataDic)")
        Server.postData(urlString: urlString, method: .post, otherInfo: sendDataDic, completion: { (kData:Data?) in
            if let data = kData {
                print("success : \(String(describing: data.toString()))")

            }
        })
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken:\(String(describing: fcmToken))")
        if let fcmToken = fcmToken {
            self.setToken(token: fcmToken)
        }
    }

//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("remoteMessage:\(remoteMessage)")
//    }


}


extension NotiCenter {
    
    //========================================================================//
    //                           LocalNotification                            //
    //========================================================================//

    
    func addAlram(dataDic : [String:String], complete:@escaping (_ success : Bool) -> Void)  {
        
//        ["time": "10:00-10:30", "subject": "JS%20MIN%20Memorial%20Lecture", "sid": "465", "tab": "39"]
        guard let time = dataDic["time"],
            let subject = dataDic["subject"],
            let sid = dataDic["sid"],
            let tab = dataDic["tab"] else { return complete(false) }
        
        let content = UNMutableNotificationContent()
        let titleString = subject.removingPercentEncoding ?? subject
        content.title = titleString
        content.body = "[\(titleString)] 10분 후 시작됩니다."
        content.sound = UNNotificationSound.default
        
        var startTime = Date()
        
        //년 세팅
        if let setTime = Calendar.current.date(bySetting: Calendar.Component.year, value: 2023, of: startTime) {
            startTime = setTime
        }
        
        //월 세팅
        if let setTime = Calendar.current.date(bySetting: Calendar.Component.month, value: 4, of: startTime) {
            startTime = setTime
        }
        
        //일 세팅
        var day = 0
        if tab == "559" { day = 18 }
        else if tab == "559" { day = 19 }
        if day == 0 { return complete(false) }
        
        if let setTime = Calendar.current.date(bySetting: Calendar.Component.day, value: day, of: startTime) {
            startTime = setTime
        }
        
        //시 세팅
        var startHour = 0
        if let startHourString = time.subString(start: 0, numberOf: 2) {
            if let startHourValue = Int(startHourString, radix: 10) {
                startHour = startHourValue
            }
        }
        if let setTime = Calendar.current.date(bySetting: Calendar.Component.hour, value: startHour, of: startTime) {
            startTime = setTime
        }
        
        //분 세팅
        var startMin = 0
        if let startMinString = time.subString(start: 3, numberOf: 2) {
            if let startMinValue = Int(startMinString, radix: 10) {
                startMin = startMinValue
            }
        }
        if let setTime = Calendar.current.date(bySetting: Calendar.Component.minute, value: startMin, of: startTime) {
            startTime = setTime
        }
        
        //마지막으로 10분을 빼자
        startTime.addTimeInterval(-60 * 10)
        
        //해당하는 Date 객체와 어떤거가 맞을때 알람이 울릴지 결정
        let triggerDate = Calendar.current.dateComponents([.month, .day, .hour,.minute,.second], from: startTime)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,repeats: false)
        
        //identifier를 이용해 알람을 구분
        let request = UNNotificationRequest(identifier: sid, content: content, trigger: trigger)
        
        notiCenter.add(request) { (error : Error?) in
            if error == nil {
                complete(true)
            }else{
                complete(false)
            }
        }
    }
    
    func removeAlram(id : String){
        //알려진거, 안 알려진거 모두 제거
        self.notiCenter.removeDeliveredNotifications(withIdentifiers: [id])
        self.notiCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func readAllAlram(){
        self.notiCenter.getDeliveredNotifications { (notifications : [UNNotification]) in
            for notification in notifications {
                print("readAlram - Delivered : \(notification)")
            }
        }
        
        self.notiCenter.getPendingNotificationRequests { ( notificationRequests : [UNNotificationRequest]) in
            for notificationRequest in notificationRequests {
                print("readAlram - Pending : \(notificationRequest)")
            }
        }
        
    }
}



