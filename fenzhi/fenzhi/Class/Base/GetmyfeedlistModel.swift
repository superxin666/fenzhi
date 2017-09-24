//
//  GetmyfeedlistModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/23.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class GetmyfeedlistModel_data_fenxList_coursewares: Mappable {
    var name : String = ""
    var type : String = ""
    var file : String = ""

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        name <- map["name"]
        type <- map["type"]
        file <- map["file"]
    }
}

class GetmyfeedlistModel_data_fenxList: Mappable {
    var id: Int!
    var userId: Int!
    var type: Int!
    var status: Int!
    var content : String = ""
    var catalogId : String = ""
    var catalog : String = ""
    var coursewares : [GetmyfeedlistModel_data_fenxList_coursewares] = []
    var images : [String] = []
    var createTime : String = ""
    var updateTime : String = ""
    var userInfo : UserInfoModel = UserInfoModel()

    var likeNum: Int!
    var zanNum: Int!
    var commentNum: Int!
    var isLike: Int!

    var cellHeight :  CGFloat  = 0.0




    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
       id <- map["id"]
        userId <- map["userId"]
        type <- map["type"]
        status <- map["status"]

        content <- map["content"]
        catalogId <- map["catalogId"]
        catalog <- map["catalog"]
        coursewares <- map["coursewares"]

        images <- map["images"]
        createTime <- map["createTime"]
        updateTime <- map["updateTime"]
        likeNum <- map["likeNum"]
        isLike <- map["isLike"]
        zanNum <- map["zanNum"]

        commentNum <- map["commentNum"]
        commentNum <- map["commentNum"]
        userInfo <- map["userInfo"]

    }
}
class GetmyfeedlistModel_data: Mappable {
    var totalNum: Int = 1
    var pageNum: Int = 1
    var count: Int = 1
    var fenxList : [GetmyfeedlistModel_data_fenxList] = []


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        totalNum <- map["totalNum"]
        pageNum <- map["pageNum"]
        count <- map["count"]
        fenxList <- map["fenxList"]

    }
}

class GetmyfeedlistModel: Mappable {
        var errno: Int = 1
        var errmsg : String = ""
        var logId : String = ""
        var data : GetmyfeedlistModel_data = GetmyfeedlistModel_data()


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
