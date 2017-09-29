//
//  GetmessagelistLikeModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/29.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class GetmessagelistLikeModel_data_messageList_fenxInfo: Mappable {

    var fenxId : Int = 0
    var type : Int = 0
    var catalog : String = ""

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        fenxId <- map["fenxId"]
        type <- map["type"]
        catalog <- map["catalog"]
    }

}

class GetmessagelistLikeModel_data_messageList_userInfo: Mappable {
    var userId: Int!
    var name : String = ""
    var avatar : String = ""



    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        userId <- map["userId"]
        name <- map["name"]
        avatar <- map["avatar"]
    }
}
class GetmessagelistLikeModel_data_messageList: Mappable {
    var messageId: Int = 0
    var type: Int = 0
    var status: Int = 0
    var createTime : String = ""

    var userInfo : GetmessagelistLikeModel_data_messageList_userInfo = GetmessagelistLikeModel_data_messageList_userInfo()
    var fenxInfo : GetmessagelistLikeModel_data_messageList_fenxInfo = GetmessagelistLikeModel_data_messageList_fenxInfo()
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        messageId <- map["messageId"]
        type <- map["type"]
        status <- map["status"]
        userInfo <- map["userInfo"]
        fenxInfo <- map["fenxInfo"]
        createTime <- map["createTime"]
    }
}

class GetmessagelistLikeModel_data: Mappable {
    var totalNum: Int = 0
    var pageNum: Int = 0
    var count: Int = 0
    var messageList: [GetmessagelistLikeModel_data_messageList] = []


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

class GetmessagelistLikeModel: Mappable {
    var errno: Int!
    var errmsg : String = ""
    var logId : String = ""
    var data : GetmessagelistLikeModel_data = GetmessagelistLikeModel_data()


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
