//
//  LikeModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/22.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class LikeModel_data: Mappable {

    var action : String = ""
    var mylikeId : String = ""

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        action <- map["action"]
        mylikeId <- map["mylikeId"]
    }
}
class LikeModel: Mappable {
        var errno: Int = 1
        var errmsg : String = ""
        var logId : String = ""
        var data : LikeModel_data = LikeModel_data()
        
        
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
