//
//  ProfileMineModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/24.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class ProfileMineModel_data_notify: Mappable {

    var like: Int = 0
    var comment:Int = 0
    var zan:Int = 0

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        like <- map["like"]
        comment <- map["comment"]
        zan <- map["zan"]
        
    }
}

class ProfileMineModel_data: Mappable {
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
    var token: String = ""


    var subjectName: String = ""
    var gradeName: String = ""
    var provinceName: String = ""
    var cityName: String = ""
    var districtName: String = ""
    var schoolName: String = ""
    var bookName: String = ""
    var versionName: String = ""


    var followNum: Int!
    var fansNum: Int!
    var likeNum: Int!
    var favoriteNum:Int!
    var type:Int!
    var notify:ProfileMineModel_data_notify = ProfileMineModel_data_notify()
    
    //看其他用户信息时 有以下数据
    var myfeedList:GetmyfeedlistModel_data = GetmyfeedlistModel_data()
    var isFollow:Int = 0

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
        district <- map["district"]
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

        followNum <- map["followNum"]
        fansNum <- map["fansNum"]
        likeNum <- map["likeNum"]
        favoriteNum <- map["favoriteNum"]
        notify <- map["notify"]

        
        myfeedList <- map["myfeedList"]
        isFollow <- map["isFollow"]
        type <- map["type"]

    }
}


class ProfileMineModel: Mappable {
    var errno: Int!
    var errmsg : String = ""
    var logId : String = ""
    var data : ProfileMineModel_data = ProfileMineModel_data()


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
