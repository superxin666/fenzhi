//
//  UploadimgModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/17.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class UploadimgModel: Mappable {

    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var data : String = ""


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

