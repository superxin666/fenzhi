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
    
    /// 0 是 老师 1 是游客 
    var type :Int = 0
    
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
    var token: String = ""


    var subjectName: String = ""
    var gradeName: String = ""
    var provinceName: String = ""
    var cityName: String = ""
    var districtName: String = ""
    var schoolName: String = ""
    var bookName: String = ""
    var versionName: String = ""

   var isFollow:Int = 0

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        avatar <- map["avatar"]
        type <- map["type"]
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
        token <- map["token"]

        subjectName <- map["subjectName"]
        gradeName <- map["gradeName"]
        provinceName <- map["provinceName"]
        cityName <- map["cityName"]
        districtName <- map["districtName"]
        schoolName <- map["schoolName"]
        bookName <- map["bookName"]
        versionName <- map["versionName"]
        isFollow <- map["isFollow"]
    }

}
