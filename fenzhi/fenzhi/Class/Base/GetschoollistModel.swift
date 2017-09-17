//
//  GetschoollistModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class GetschoollistModel_schoolList: Mappable {
    var name : String = ""
    var id : Int = 100
    var type : Int = 100
    var provinceId : Int = 100
    var cityId : Int = 100
    var distId : Int = 100
    var sortNum : Int = 100
    var status : Int = 100


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        name <- map["name"]
        id <- map["id"]
        type <- map["type"]
        status <- map["status"]
        provinceId <- map["provinceId"]
        cityId <- map["cityId"]
        distId <- map["distId"]
        sortNum <- map["sortNum"]
        status <- map["status"]
    }
}

class GetschoollistModel_data: Mappable {

    var totalNum: Int = 1
    var pageNum: Int = 1
    var count: Int = 1
    var schoolList : [GetschoollistModel_schoolList] = []


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        totalNum <- map["totalNum"]
        pageNum <- map["pageNum"]
        count <- map["count"]
        schoolList <- map["schoolList"]

    }
    
}

class GetschoollistModel: Mappable {

    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var data : GetschoollistModel_data = GetschoollistModel_data()


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
