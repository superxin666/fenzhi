//
//  CommonModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class CommonModel_data_regionList: Mappable {

    var name : String = ""
    var id : Int = 1000
    var type : String = ""
    var status : String = ""

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
        
    }
}


class CommonModel_data_grade: Mappable {

    var name : String = ""
    var id : String = ""
    var type : String = ""

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        name <- map["name"]
        id <- map["id"]
        type <- map["type"]


    }
}

class CommonModel_data_subject: Mappable {

    var name : String = ""
    var id : String = ""

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        name <- map["name"]
        id <- map["id"]

    }
}

class CommonModel_data_version: Mappable {

    var name : String = ""
    var id : String = ""


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
    }
}


class CommonModel_data: Mappable {
    var version: [CommonModel_data_version] = []
    var subject: [CommonModel_data_subject] = []
    var grade: [CommonModel_data_grade] = []
    var regionList: [CommonModel_data_regionList] = []

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        version <- map["version"]
        subject <- map["subject"]
        grade <- map["grade"]
        regionList <- map["regionList"]
    }
}



class CommonModel: Mappable {
    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var data : CommonModel_data = CommonModel_data()


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

