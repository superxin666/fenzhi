//
//  GetcommentlistModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/20.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class GetcommentlistModel_data_list_commentList_fenxInfo: Mappable {
    var fenxId: Int!
    var type: Int!
    var catalog: String = ""
    
    
    
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

class GetcommentlistModel_data_list_commentList_commentInfo: Mappable {
    var commentId: Int!
    var content: String = ""

    
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        commentId <- map["commentId"]
        content <- map["content"]
        
    }
}
class GetcommentlistModel_data_list_commentList_toCommentInfo: Mappable {
    var id: Int!
    var toCommentId : Int!
    var userId : Int!
    var toUserId: Int!
    var content : String = ""
    var fenxId : Int!
    var status : Int!
    var createTime : String = ""
    var updateTime : String = ""
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        toCommentId <- map["toCommentId"]
        userId <- map["userId"]
        toUserId <- map["toUserId"]
        content <- map["content"]
        fenxId <- map["fenxId"]
        status <- map["status"]
        createTime <- map["createTime"]
        updateTime <- map["updateTime"]
    }
}


class GetcommentlistModel_data_list_commentList_userInfo: Mappable {
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
class GetcommentlistModel_data_list_commentList: Mappable {
    var id: Int!
    var toCommentId: Int!
    var userId: Int!
    var toUserId: Int!
    var content : String = ""
    var fenxId : Int!
    var status : Int!
    var createTime : String = ""
    var updateTime : String = ""
    var likeNum : Int = 0
    var isHot : Int!
    var isLike: Int!
    var userInfo : GetcommentlistModel_data_list_commentList_userInfo = GetcommentlistModel_data_list_commentList_userInfo()
    var toUserInfo : GetcommentlistModel_data_list_commentList_userInfo = GetcommentlistModel_data_list_commentList_userInfo()
    var toCommentInfo : GetcommentlistModel_data_list_commentList_toCommentInfo = GetcommentlistModel_data_list_commentList_toCommentInfo()

    var cellHeight: CGFloat = 0.0
    
    //消息列表中的评论独有的
    var commentInfo : GetcommentlistModel_data_list_commentList_commentInfo = GetcommentlistModel_data_list_commentList_commentInfo()
    var fenxInfo:GetcommentlistModel_data_list_commentList_fenxInfo = GetcommentlistModel_data_list_commentList_fenxInfo()
    


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        toCommentId <- map["toCommentId"]
        userId <- map["userId"]
        toUserId <- map["toUserId"]
        content <- map["content"]
        fenxId <- map["fenxId"]
        status <- map["status"]
        createTime <- map["createTime"]
        updateTime <- map["updateTime"]
        likeNum <- map["likeNum"]
        isHot <- map["isHot"]
        userInfo <- map["userInfo"]
        isLike <- map["isLike"]
        toUserInfo <- map["toUserInfo"]
        toCommentInfo <- map["toCommentInfo"]
        
        commentInfo <- map["commentInfo"]
        fenxInfo <- map["fenxInfo"]
    }
}

class GetcommentlistModel_data_list: Mappable {
    var title: String = ""
    var commentList : [GetcommentlistModel_data_list_commentList] = []


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        title <- map["title"]
        commentList <- map["commentList"]
        
    }
}

class GetcommentlistModel_data: Mappable {
    var totalNum: Int!
    var pageNum: Int!
    var count: Int!
    var list : [GetcommentlistModel_data_list] = []


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        totalNum <- map["totalNum"]
        pageNum <- map["pageNum"]
        count <- map["count"]
        list <- map["list"]

    }
}


class GetcommentlistModel: Mappable {
    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var data : GetcommentlistModel_data = GetcommentlistModel_data()


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
