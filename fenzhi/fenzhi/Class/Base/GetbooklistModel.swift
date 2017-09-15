//
//  GetbooklistModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class GetbooklistModel_data: Mappable {
    var name : String = ""
    var id : String = ""
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

class GetbooklistModel: Mappable {

    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var bookList : [GetschoollistModel_data] = []


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        errno <- map["errno"]
        errmsg <- map["errmsg"]
        logId <- map["logId"]
        bookList <- map["data"]["bookList"]
        
    }
    
}

