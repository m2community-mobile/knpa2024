//
//  VotingDefine.swift
//  CosoptTransformSymposium2019
//
//  Created by m2comm on 25/03/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import Foundation
import KeychainSwift

//let QUESTION_URL = "https://ezv.kr:4447/voting/php/question/post.php"
let LECTURE_LIST_URL = "https://ezv.kr:4447/voting/php/session/get_session.php?code=\(code)"

let SOKET_IP   = "121.254.129.104"
let SOKET_PORT = 13001


struct BUTTON_INFO_KEY {
    static let TITLE            = "TITLE"
    static let BUTTON_TITLE     = "BUTTON_TITLE"
    static let URL              = "URL"
    static let GET_QUESTION_URL = "GET_QUESTION_URL"
    
    static let TYPE             = "TYPE"
    enum type : String {
        case web          = "web"
        case voting       = "voting"
        case QnA_normal   = "QnA_normal"
        case QnA_category = "QnA_category"
        case QnA_Type3 = "QnA_Type3"
        case Etc = "Etc"
    }
}

let questionSelectedColor    = #colorLiteral(red : 0.05490196078, green : 0.368627451, blue : 0.7176470588, alpha : 1)
let questionNonSelectedColor = #colorLiteral(red : 0.4588235294, green : 0.4941176471, blue : 0.568627451, alpha : 1)

let votingSelectedColor      = #colorLiteral(red : 0.05490196078, green : 0.368627451, blue : 0.7176470588, alpha : 1)
let votingNonSelectedColor   = #colorLiteral(red   : 0.4588235294, green   : 0.4941176471, blue   : 0.568627451, alpha   : 1)

let buttonSelectedColor      = #colorLiteral(red : 0.05490196078, green : 0.368627451, blue : 0.7176470588, alpha : 1)
let buttonNonSelectedColor   = #colorLiteral(red : 0.3137254902, green : 0.3137254902, blue : 0.3137254902, alpha : 1)

let ButtonInfos = [
    [
        BUTTON_INFO_KEY.TITLE : "VOTING",
        BUTTON_INFO_KEY.BUTTON_TITLE : "Voting",
        BUTTON_INFO_KEY.TYPE : BUTTON_INFO_KEY.type.voting.rawValue
    ],
    [
        BUTTON_INFO_KEY.TITLE : "QUESTION",
        BUTTON_INFO_KEY.BUTTON_TITLE : "Question",
//        BUTTON_INFO_KEY.TYPE : BUTTON_INFO_KEY.type.QnA_normal.rawValue
//        BUTTON_INFO_KEY.TYPE : BUTTON_INFO_KEY.type.QnA_category.rawValue
        BUTTON_INFO_KEY.TYPE : BUTTON_INFO_KEY.type.QnA_Type3.rawValue
    ]
]



