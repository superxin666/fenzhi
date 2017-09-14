//
//  ResModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/14.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//  注册

import UIKit
import ObjectMapper


class ResModel: Mappable {
    var id: Int = 1
    var token : String = ""
    
    init() {}
    required init?(map: Map){
        mapping(map: map) 
    }
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        token <- map["token"]
    }
}





