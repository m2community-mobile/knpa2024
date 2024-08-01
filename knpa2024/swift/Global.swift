//
//  Global.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import Foundation

//let code = "knpa2023s"
//let code = "knpa2023f"
let code = "knpa2024s"



let USER_SID = "USER_SID"
var user_sid : String {
    get{
        if let value = userD.object(forKey: USER_SID) as? String {
            return value
        }else{
            return ""
        }
    }
}

struct URL_KEY {
    
    static let BASE_URL = "knpa.m2comm.co.kr"
    static let EZV_URL = "ezv.kr"

    static let 인사말 = "https://knpa.m2comm.co.kr/app/2024spring/php/about/greetings.php"
//    static let 인사말 = "https://knpa.m2comm.co.kr/app/2023fall/php/about/greetings.php"

    static let E_Poster = "https://knpa.m2comm.co.kr/app/2024spring/php/eposter/"
//    static let E_Poster = "https://knpa.m2comm.co.kr/app/2023fall/php/eposter/"
    

    static let Highlights = "https://knpa.m2comm.co.kr/app/2024spring/php/program/highlights.php"
//    static let Highlights = "https://knpa.m2comm.co.kr/app/2023fall/php/program/highlights.php"


    static let feedback = "https://knpa.m2comm.co.kr/app/2024spring/php/feedback/feedback_01.php"
//    static let feedback = "https://knpa.m2comm.co.kr/app/2023fall/php/feedback/feedback_01.php"
    
    
    
    static let 대회장_안내 = "https://knpa.m2comm.co.kr/app/2024spring/php/about/floor.php"
//    static let 대회장_안내 = "https://knpa.m2comm.co.kr/app/2023fall/php/about/floor.php"
    
    
    static let 오시는길 = "https://knpa.m2comm.co.kr/app/2024spring/php/about/map.php"
//    static let 오시는길 = "https://knpa.m2comm.co.kr/app/2024spring/html/app/map.html"
//    static let 오시는길 = "https://knpa.m2comm.co.kr/app/2023fall/php/about/map.php"

    static let 전시_안내 = "https://knpa.m2comm.co.kr/app/2024spring/php/about/booth.php"
//    static let 전시_안내 = "https://knpa.m2comm.co.kr/app/2023fall/php/about/booth.php"


    static let day_1 = "https://ezv.kr:4447/voting/php/session/list.php?tab=558&code=\(code)"
    static let day_2 = "https://ezv.kr:4447/voting/php/session/list.php?tab=559&code=\(code)"
    
    static let now = "https://ezv.kr:4447/voting/php/session/list.php?code=\(code)&tab=-1"
    static let session = "https://ezv.kr:4447/voting/php/session/category.php?code=\(code)"
    static let today = "https://ezv.kr:4447/voting/php/session/list.php?code=\(code)"
    
    static let speakers = "https://ezv.kr:4447/voting/php/faculty/list.php?code=\(code)"
    static let sponsor = "https://ezv.kr:4447/voting/php/booth/list.php?code=\(code)&tab=undefined"
    
    static let mySchedule = "https://ezv.kr:4447/voting/php/session/list.php?code=\(code)&tab=-2"
    static let search = "https://ezv.kr:4447/voting/php/session/list.php?code=\(code)&tab=-3"
    static let memo = "https://ezv.kr:4447/voting/php/session/list.php?code=\(code)&tab=-6"
    
    static let notice = "https://ezv.kr:4447/voting/php/bbs/list.php?code=\(code)"
    static let noticeView = "https://ezv.kr:4447/voting/php/bbs/view.php?code=\(code)"
    static let noticeList = "https://ezv.kr:4447/voting/php/bbs/get_list.php?code=\(code)"

    static let Abstract_category = "https://ezv.kr:4447/voting/php/abstract/category.php?code=\(code)"
    static let Abstract_list = "https://ezv.kr:4447/voting/php/abstract/list.php?code=\(code)"
    
    static let 초록_포맷별 = "https://ezv.kr:4447/voting/php/abstract/category.php?code=\(code)&top_tab=1"
    static let 초록_주제별 = "https://ezv.kr:4447/voting/php/abstract/category.php?code=\(code)&top_tab=2"
    
    
//    static let 초록 = "https://ezv.kr:4447/voting/php/abstract/category.php?code=\(code)&top_tab=2"
//    static let 초록 = "http://ezv.kr/voting/php/abstract/category.php?code=\(code)"
    static let 초록 = "http://ezv.kr/voting/php/abstract/category.php?code=\(code)"
    

    

    
    static let 연구기금_및_학술상 = "https://knpa.m2comm.co.kr/app/2024spring/php/about/award.php"
//    static let 연구기금_및_학술상 = "https://knpa.m2comm.co.kr/app/2023fall/php/about/award.php"
    
    
}

var myPage : String {
    get{
        return ""
//        "http://www.koa.or.kr/new_workshop/201901/app/php/attendance.php?user_sid=\(user_sid)&deviceid=\(deviceID)"
    }
}

struct INFO {
    
    struct KEY {
        static let TITLE = "TITLE"
        static let SUB_MENU = "SUB_MENU"
        
        static let URL = "URL"
        
        static let IS_REQUIRED_LOGIN = "IS_REQUIRED_LOGIN"
        
        static let IS_PHOTO_GALLERY = "IS_PHOTO_GALLERY"
        static let IS_PROGRAM_AT_A_GLANCE = "IS_PROGRAM_AT_A_GLANCE"
        
        //etc
        static let IS_BOOTH_EVENT = "IS_BOOTH_EVENT"
        static let IS_VOTING = "IS_VOTING"
    }
    
    
    static let MAIN_INFO =
        [
            [KEY.TITLE : "인사말",KEY.URL:URL_KEY.인사말],
            [KEY.TITLE : "일정",KEY.URL:URL_KEY.today,
             KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN
            ],
            [
//                KEY.TITLE : "초록보기",KEY.URL:URL_KEY.초록_포맷별,
                KEY.TITLE : "초록보기"
                ,KEY.URL:URL_KEY.초록
                ,KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN
            ],
            [
                KEY.TITLE : "E-Poster"
                ,KEY.URL:URL_KEY.E_Poster
                ,KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN
            ],
            [
                KEY.TITLE : "Highlights"
                ,KEY.URL:URL_KEY.Highlights
//                ,KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN
            ],
            [
                KEY.TITLE : "피드백"
                ,KEY.URL:URL_KEY.feedback
             ,KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN
            ],
//            [KEY.TITLE : "대회장 안내",KEY.URL:URL_KEY.대회장_안내],
            [KEY.TITLE : "공지사항",KEY.URL:URL_KEY.notice],
            [KEY.TITLE : "전시안내",KEY.URL:URL_KEY.전시_안내],
            [
                KEY.TITLE : "포토갤러리"
                ,KEY.IS_PHOTO_GALLERY:KEY.IS_PHOTO_GALLERY,
                KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN
            ],
    ]
    /*
     1. 인사말
     2. 일정
        program at a glacne
         4월 20일(목)
         4월 21일(금)
     3. 초록보기
     4. E-Poster
     5. Highlights
     6. 피드백
     7. 대회장안내
     대회장 안내
         오시는길
     8. 공지사항
     9. 전시안내
     10. 포토갤러리
        4월 20일(목)
         4월 21일(금)
         사용자 사진
     
     */
    static let INFOS =
        [
            [
                KEY.TITLE:"인사말",
//                ,KEY.URL:URL_KEY.인사말
                KEY.SUB_MENU :
                    [
                        [KEY.TITLE:"인사말",KEY.URL:URL_KEY.인사말],
                        [KEY.TITLE:"학술상",KEY.URL:URL_KEY.연구기금_및_학술상]
                    ]
            ],
            [
                KEY.TITLE : "일정",
                KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN,
                
                KEY.SUB_MENU :
                    [
                        [KEY.TITLE:"Program at a Glance",KEY.IS_PROGRAM_AT_A_GLANCE:KEY.IS_PROGRAM_AT_A_GLANCE,KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN],
                        [KEY.TITLE:"4월 18일(목)",KEY.URL:URL_KEY.day_1,KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN],
                        [KEY.TITLE:"4월 19일(금)",KEY.URL:URL_KEY.day_2,KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN],
                        
                ]
            ],
            [
                KEY.TITLE:"초록보기",KEY.URL:URL_KEY.초록,
                KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN

            ],
            
            [
                KEY.TITLE:"E-Poster",KEY.URL:URL_KEY.E_Poster,
                KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN

            ],
            [
                KEY.TITLE : "Highlights"
                ,KEY.URL:URL_KEY.Highlights
                
            ],
            [
                KEY.TITLE : "피드백",
                KEY.URL:URL_KEY.feedback,
                KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN

                
            ],
            [
                KEY.TITLE : "대회장안내",
                KEY.SUB_MENU :
                    [
                        [KEY.TITLE:"대회장 안내",KEY.URL:URL_KEY.대회장_안내],
                        [KEY.TITLE:"오시는길",KEY.URL:URL_KEY.오시는길]
                ]
            ],
//            [
//                KEY.TITLE : "공지사항",
//                KEY.URL : URL_KEY.notice
//            ],
            
            [
                KEY.TITLE : "공지사항",
                KEY.URL : URL_KEY.notice
            ],
            
            [
                KEY.TITLE : "전시안내",
                KEY.URL : URL_KEY.전시_안내
            ],
            [
                KEY.TITLE : "포토갤러리",
                KEY.IS_PHOTO_GALLERY:KEY.IS_PHOTO_GALLERY,
                KEY.IS_REQUIRED_LOGIN:KEY.IS_REQUIRED_LOGIN
                
            ],
    ]
}
