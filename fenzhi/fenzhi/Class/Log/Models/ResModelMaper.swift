//
//  ResModelMaper.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/14.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper


class ResModelMaper: Mappable {
    var errno: Int = 1
    var errmsg : String = ""
    var data :  ResModel = ResModel()//
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        errno <- map["errno"]
        errmsg <- map["errmsg"]
        data <- map["data"]
        
        
    }
}
