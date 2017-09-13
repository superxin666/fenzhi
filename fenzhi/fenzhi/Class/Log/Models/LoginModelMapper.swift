//
//  LoginModelMapper.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/13.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
let TOKENUDSTR = "LOGININTOKEN"
let LOGINUDSTR = "LOGININLOGINID"
let ISLOGINSTR = "ISHAVELOGIN"
class LoginModelMapper: Mappable {
    var errno: Int = 0
    var errmsg : String = ""
    var data :  UserInfoModel = UserInfoModel()//
    
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
    
    
    class func setLoginIdAndTokenInUD(loginUserId : String , token : String, complate:(_ data : Any) ->() ){
        UserDefaults.standard.set("1", forKey: ISLOGINSTR)
        UserDefaults.standard.set(token, forKey: TOKENUDSTR)
        UserDefaults.standard.set(loginUserId, forKey: LOGINUDSTR)
        let ok = UserDefaults.standard.synchronize()
        if ok {
            print("存储成功")

            complate("1")
        } else {
            print("存储失败")
            complate("0")
        }
    }
    
    
    /// 返回当前登录用户的 loginid tokenid
    ///
    /// - returns: 返回元组loginid
    class func getLoginIdAndTokenInUD() -> (loginId : String, tokenStr:String,isHaveLogin : String) {
        var isloginStr :String? = UserDefaults.standard.value(forKey: ISLOGINSTR) as! String?
        if isloginStr == nil {
            isloginStr = "0"
        }
        var loginStr :String? = UserDefaults.standard.value(forKey: LOGINUDSTR) as! String?
        if loginStr == nil {
            loginStr = ""
        }
        var tokenStr :String? = UserDefaults.standard.value(forKey: TOKENUDSTR) as! String?
        if tokenStr == nil {
            tokenStr = ""
        }
        return (loginStr!,tokenStr!,isloginStr!)
    }
}
