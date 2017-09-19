//
//  TeachDetailModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/19.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class TeachDetailModel_data_zanUsers: Mappable {
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


class TeachDetailModel_data_coursewares: Mappable {

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

class TeachDetailModel_data: Mappable {
    var id: Int!
    var userId: Int!
    var type: Int!
    var status: Int!
    var content : String = ""
    var catalogId : String = ""
    var catalog : String = ""
    var coursewares : [TeachDetailModel_data_coursewares] = []
    var images : [String] = []
    var createTime : String = ""
    var updateTime : String = ""
    var likeNum: Int!
    var favoriteNum: Int!
    var shareNum: Int!
    var zanUsers : [TeachDetailModel_data_zanUsers] = []
    var userInfo : UserInfoModel = UserInfoModel()

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

        favoriteNum <- map["favoriteNum"]
        shareNum <- map["shareNum"]
        zanUsers <- map["zanUsers"]
        userInfo <- map["userInfo"]

    }

}

class TeachDetailModel: Mappable {
    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var data : TeachDetailModel_data = TeachDetailModel_data()


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
