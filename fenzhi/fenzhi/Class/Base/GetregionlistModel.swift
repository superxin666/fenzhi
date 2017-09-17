//
//  GetregionlistModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//  获取区域列表

import UIKit
import ObjectMapper

class GetregionlistModel_regionList: Mappable {
    var name : String = ""
    var id : Int = 100
    var type : Int = 100
    var status : Int = 100
    var parent : Int = 100


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
        parent <- map["parent"]
    }
}

class GetregionlistModel_data: Mappable {

    var totalNum: Int = 0
    var regionList : [GetregionlistModel_regionList] = []


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        totalNum <- map["totalNum"]
        regionList <- map["regionList"]
        
    }
}

class GetregionlistModel: Mappable {

    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var data : GetregionlistModel_data = GetregionlistModel_data()



    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        errno <- map["errno"]
        errmsg <- map["errmsg"]
        logId <- map["logId"]
        data  <- map["data"]

    }
}
