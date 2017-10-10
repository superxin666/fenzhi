//
//  GetCommentMessagelistModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/10.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class GetCommentMessagelistModel_data: Mappable {
    var totalNum: Int = 0
    var pageNum: Int = 0
    var count: Int = 0
    var messageList: [GetcommentlistModel_data_list_commentList] = []
    
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        totalNum <- map["totalNum"]
        pageNum <- map["pageNum"]
        count <- map["count"]
        messageList <- map["messageList"]
        
    }
}

class GetCommentMessagelistModel: Mappable {
    var errno: Int!
    var errmsg : String = ""
    var logId : String = ""
    var data : GetCommentMessagelistModel_data = GetCommentMessagelistModel_data()
    
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        errno <- map["errno"]
        errmsg <- map["errmsg"]
        logId <- map["logId"]
        data <- map["data"]
        
    }
}
