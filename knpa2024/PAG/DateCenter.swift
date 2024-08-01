//
//  DateCenter.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//



import UIKit


class DateCenter: NSObject {
    
    static let shared : DateCenter = {
        let sharedCenter = DateCenter()
        return sharedCenter
    }()
    
    var format = DateFormatter()
    
    func stringToDateWithFormat(
        formatString : String,
        dateString : String,
        locale : Locale = Locale(identifier: "ko-KR"),
        timeZone : TimeZone = TimeZone.current,
        amSymbol : String = "오전",
        pmSymbol : String = "오후") -> Date? {
        
        format.locale = locale
        format.timeZone = timeZone
        format.amSymbol = amSymbol
        format.pmSymbol = pmSymbol
        
        format.dateFormat = formatString
        
        guard let time = format.date(from: dateString) else {
            print("error : \(dateString)")
            return nil
        }
        return time
        
    }
    
    
    func dateToStringWithFormat(
        formatString : String,
        date : Date,
        locale : Locale = Locale(identifier: "ko-KR"),
        timeZone : TimeZone = TimeZone.current,
        amSymbol : String = "오전",
        pmSymbol : String = "오후") -> String {
        
        format.locale = locale
        format.timeZone = timeZone
        format.amSymbol = amSymbol
        format.pmSymbol = pmSymbol
        
        format.dateFormat = formatString
        return format.string(from: date)
    }
    
    
    
    /*
     Date에 정보 추가
     alramDate = Calendar.current.date(bySetting: .weekday, value: index, of: alramDate)!
     alramDate = Calendar.current.date(bySetting: .hour, value: info.hour, of: alramDate)!
     alramDate = Calendar.current.date(bySetting: .minute, value: info.minute, of: alramDate)!
     
     
     */
    
}

