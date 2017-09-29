//
//  FollowModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/15.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class FollowModel_data_list: Mappable {

    var name : String = ""
    var avatar : String = ""
    var provinceName : String = ""
    var cityName : String = ""
    var districtName : String = ""
    var subjectName : String = ""
    var gradeName : String = ""
    var createTime : String = ""
    var userId : Int = 0
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        name <- map["name"]
        userId <- map["userId"]
        avatar <- map["avatar"]
        provinceName <- map["provinceName"]
        cityName <- map["cityName"]
        districtName <- map["districtName"]
        subjectName <- map["subjectName"]
        gradeName <- map["gradeName"]
        createTime <- map["createTime"]

    }
}


class FollowModel_data: Mappable {
    var totalNum: Int = 0
    var pageNum: Int = 0
    var count: Int = 0
    var followList: [FollowModel_data_list] = []
    var fansList: [FollowModel_data_list] = []
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        totalNum <- map["totalNum"]
        pageNum <- map["pageNum"]
        count <- map["count"]
        followList <- map["followList"]
        fansList <- map["fansList"]
        
    }
}



class FollowModel: Mappable {
    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var data : FollowModel_data = FollowModel_data()


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
