//
//  UserInfoModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/13.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class UserInfoModel: Mappable {
    var avatar: String = ""
    var book: Int = 0
    var city: Int = 0
    var createTime: String = ""
    var district: Int = 0
    var extend: String = ""
    var grade: Int = 0
    var id: Int = 0
    var name: String = ""
    var phone: String = ""
    var province: Int = 0
    var school: Int = 0
    var sex: Int = 0
    var status: Int = 0
    var subject: Int = 0
    var updateTime: String = ""
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        avatar <- map["avatar"]
        book <- map["book"]
        city <- map["city"]
        createTime <- map["createTime"]
        grade <- map["grade"]
        id <- map["id"]
        name <- map["name"]
        phone <- map["phone"]
        province <- map["province"]
        school <- map["school"]
        sex <- map["sex"]
        subject <- map["subject"]
        updateTime <- map["updateTime"]

    }


}
