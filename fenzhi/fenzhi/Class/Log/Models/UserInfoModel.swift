//
//  UserInfoModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/13.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
let COUSENAME = "setSelectCouse_name"
let COUSEID = "setSelectCouse_id"
let ISHAVECOUSEINFO = "isHaveSelectCouseinfo"
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
    var token: String = ""


    var subjectName: String = ""
    var gradeName: String = ""
    var provinceName: String = ""
    var cityName: String = ""
    var districtName: String = ""
    var schoolName: String = ""
    var bookName: String = ""
    var versionName: String = ""



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
        token <- map["token"]

        subjectName <- map["subjectName"]
        gradeName <- map["gradeName"]
        provinceName <- map["provinceName"]
        cityName <- map["cityName"]
        districtName <- map["districtName"]
        schoolName <- map["schoolName"]
        bookName <- map["bookName"]
        versionName <- map["versionName"]

    }
    class func setSelectCouse_name_id(name : String , id : String, ishaveinfo : String, complate:(_ data : Any) ->() ){
        UserDefaults.standard.set("1", forKey: ISHAVECOUSEINFO)
        UserDefaults.standard.set(name, forKey: COUSENAME)
        UserDefaults.standard.set(id, forKey: COUSEID)
        let ok = UserDefaults.standard.synchronize()
        if ok {
            print("存储成功")
            complate("1")
        } else {
            print("存储失败")
            complate("0")
        }
    }
    
    
    class func getSelectCouse_name_id() -> (ishaveCouse : String,name : String, id:String) {
        var isHaveCouse :String? = UserDefaults.standard.value(forKey: ISHAVECOUSEINFO) as! String?
        if isHaveCouse == nil {
            isHaveCouse = "0"
        }
        var nameStr :String? = UserDefaults.standard.value(forKey: COUSENAME) as! String?
        if nameStr == nil {
            nameStr = ""
        }
        var idStr :String? = UserDefaults.standard.value(forKey: COUSEID) as! String?
        if idStr == nil {
            idStr = ""
        }
        return (isHaveCouse!,nameStr!,idStr!)
    }


}
