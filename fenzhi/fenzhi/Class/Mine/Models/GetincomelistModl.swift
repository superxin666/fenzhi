//
//  GetincomelistModl.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/18.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper


class GetincomelistModl_data_incomeList: Mappable {
    var userId: Int = 0
    var name : String = ""
    var avatar : String = ""
    var fenxId: Int = 0
    var type: Int = 0
    var price: Int = 0
    var catalog : String = ""
    var catalogId : String = ""
    var createTime : String = ""
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
        type <- map["type"]
        price <- map["price"]
        catalog <- map["catalog"]
        catalogId <- map["catalogId"]
        createTime <- map["createTime"]

    }
}

class GetincomelistModl_data: Mappable {
    var totalNum: Int = 0
    var pageNum: Int = 0
    var count: Int = 0
    var totalMoney: Int = 0
    var incomeList: [GetincomelistModl_data_incomeList] = []

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        totalNum <- map["totalNum"]
        pageNum <- map["pageNum"]
        count <- map["count"]
        totalMoney <- map["totalMoney"]
        incomeList <- map["incomeList"]
    }
}



class GetincomelistModl: Mappable {
    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var data : GetincomelistModl_data = GetincomelistModl_data()


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

