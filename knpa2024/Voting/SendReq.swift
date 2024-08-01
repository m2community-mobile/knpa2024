//
//  SendReq.swift
//  CosoptTransformSymposium2019
//
//  Created by m2comm on 25/03/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import Foundation
import UIKit

class SendReq {
    
    //기기 고유값 전송
    func sendLogin(code : String! , id : String! ){

        let sendUrl = NSURL(string: "http://121.254.129.104/voting_0523/insert_device.asp")
        let request = NSMutableURLRequest(url: sendUrl! as URL)
        request.httpMethod = "POST"
        
        let postString = "code=\(code!)&id=\(id!)&os=IOS"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data,response,error in
            
            if error != nil {
                print("SendReq error=\(String(describing: error))")
                return
            }
            do{
                let log = NSString(data:data!,encoding:String.Encoding.utf8.rawValue) ?? ""
                if  log == "Y"{
                    print("insert Success")
//                    UD.set(true, forKey: "isLogin")
                }else{
//                    UD.set(false, forKey: "isLogin")
                }
            }
//            catch{
//                print("insert fail")
//            }
        }
        task.resume()
    }
    
    
    func socket(_ voting : String) -> Int{
        
        let socket = TcpSocket()
        var returnCode = 0
        
        socket.connect(host: SOKET_IP, port: SOKET_PORT)
        
        var msg = "<voting><request><device_type>user</device_type><type>quiz_result</type><id>"
        msg.append(deviceID)
        msg.append("</id><lectureid>0</lectureid><quizid>0</quizid><selected>")
        msg.append(voting)
        msg.append("</selected></request></voting>")
        
        let base64msg = msg.base64Encoded()
        let dataQuery = base64msg!.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let sentCount = socket.send(data: dataQuery!)
        //let sentCount = socket.send(data: query)
        print("sentCount : \(sentCount)")
        
        
        let buffersize = 1024
        let chunk = socket.recv(buffersize: buffersize)
        
        var getString : String?
        
        if(chunk.count > 0){
            getString = String(bytes: chunk, encoding: String.Encoding.utf8)!
            let newString = getString!.replacingOccurrences(of: "\r\n\r\n\0", with: "", options: .literal, range: nil)
            print("newString:\(newString.base64Decoded()!)")
            if newString.base64Decoded()!.search(of: "successfully") != nil {
                returnCode = 1
            } else if newString.base64Decoded()!.search(of: "error") != nil {
                returnCode = 0
            } else if newString.base64Decoded()!.search(of: "submitted") != nil {
                returnCode = 2
            }
        }
        
        socket.disconnect()
        return returnCode
    }
    

    
    
}


extension String {
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func search(of target:String) -> Range<Index>? {
        // 찾는 결과는 `leftIndex`와 `rightIndex`사이에 들어가게 된다.
        var leftIndex = startIndex
        while true {
            // 우선 `leftIndex`의 글자가 찾고자하는 target의 첫글자와 일치하는 곳까지 커서를 전진한다.
            guard self[leftIndex] == target[target.startIndex] else {
                leftIndex = index(after:leftIndex)
                if leftIndex >= endIndex { return nil }
                continue
            }
            // `leftIndex`의 글자가 일치하는 곳이후부터 `rightIndex`를 늘려가면서 일치여부를 찾는다.
            var rightIndex = index(after:leftIndex)
            var targetIndex = target.index(after:target.startIndex)
            while self[rightIndex] == target[targetIndex] {
                // target의 전체 구간이 일치함이 확인되는 경우
                guard distance(from:leftIndex, to:rightIndex) < target.count - 1
                    else {
                        return leftIndex..<index(after:rightIndex)
                }
                rightIndex = index(after:rightIndex)
                targetIndex = target.index(after:targetIndex)
                // 만약 일치한 구간을 찾지못하고 범위를 벗어나는 경우
                if rightIndex >= endIndex {
                    return nil
                }
            }
            leftIndex = index(after:leftIndex)
        }
    }
    
}
