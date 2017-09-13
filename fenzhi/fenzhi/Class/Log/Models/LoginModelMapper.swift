//
//  LoginModelMapper.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/13.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class LoginModelMapper: Mappable {
    var errno: Int = 0
    var errmsg : String = ""
    var data :  UserInfoModel = UserInfoModel()//本周课程
    
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
