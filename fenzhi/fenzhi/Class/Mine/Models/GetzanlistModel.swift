//
//  GetzanlistModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class GetzanlistModel_data_list: Mappable {
    var userId : Int = 0
    var name : String = ""
    var avatar : String = ""
    var fenxId : Int = 0
    var type : Int = 0
    var catalog : String = ""
    var catalogId : String = ""
    var fenxStatus : Int = 0
    var price : Int = 0
    var createTime : String = ""
    var updateTime : String = ""
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        userId <- map["userId"]
        name <- map["name"]
        avatar <- map["avatar"]
        fenxId <- map["fenxId"]
        price <- map["price"]
        type <- map["type"]
        catalog <- map["catalog"]
        catalogId <- map["catalogId"]
        fenxStatus <- map["fenxStatus"]
        createTime <- map["createTime"]
        updateTime <- map["updateTime"]
        
    }
}


class GetzanlistModel_data: Mappable {
    var totalNum: Int = 0
    var pageNum: Int = 0
    var count: Int = 0
    var favoriteList: [GetzanlistModel_data_list] = []
    var zanList: [GetzanlistModel_data_list] = []
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        totalNum <- map["totalNum"]
        pageNum <- map["pageNum"]
        count <- map["count"]
        favoriteList <- map["favoriteList"]
        zanList <- map["zanList"]

    }
}



class GetzanlistModel: Mappable {
    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var data : GetzanlistModel_data = GetzanlistModel_data()


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
