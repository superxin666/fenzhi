//
//  UpFileDataModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/28.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class UpFileDataModel_data: Mappable {

    var file : String = ""
    var type : String = ""
    var name : String = ""


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {

        file <- map["file"]
        type <- map["type"]
        name <- map["name"]
    }

}

class UpFileDataModel: Mappable {

    var errno: Int!
    var errmsg : String = ""
    var logId : String = ""
    var data : UpFileDataModel_data = UpFileDataModel_data()


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
