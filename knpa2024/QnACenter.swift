//
//  QnACheck.swift
//  kingca2020s
//
//  Created by JinGu's iMac on 2020/02/20.
//  Copyright © 2020 JinGu's iMac. All rights reserved.
//

import UIKit

class QnACenter: NSObject {

    var isShow = false
    
    static let shared : QnACenter = {
        let sharedCenter = QnACenter()
        return sharedCenter
    }()

    func stateUpdate(complete:@escaping(_:Bool) -> Void){
        //todo - Change
        let urlString = "https://ezv.kr:4447/knpa/knpa.txt?date=\(Date().timeIntervalSince1970)"
        
        Server.postData(urlString: urlString, method: .get) { (kData : Data?) in
            if let data = kData {
                print("data.toString():\(String(describing: data.toString()))")
                if let dataString = data.toString() {
                    self.isShow = dataString.lowercased() == "y"
                    complete(self.isShow)
                    return
                }
            }
            self.isShow = false
            complete(self.isShow)
            return
        }
    }
    
}
