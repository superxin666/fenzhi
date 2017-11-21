//
//  LogDataMangerViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/12.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//  登录

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON
let COUSENAME = "setSelectCouse_name"
let COUSEID = "setSelectCouse_id"
let ISHAVECOUSEINFO = "isHaveSelectCouseinfo"

let COUSENAME_TEACH = "setSelectCouse_name_TEACH"
let COUSEID_TEACH = "setSelectCouse_id_TEACH"
let ISHAVECOUSEINFO_TEACH = "isHaveSelectCouseinfo_TEACH"
class LogDataMangerViewController: FZRequestViewController {

    func login(phoneNum : String, paseWord : String, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        
        let encWithPubKey = RSA.encryptString(paseWord, publicKey: pubkey)
        let urlBase : String =  RSA.encodeParameter(encWithPubKey)
        //15910901725
        KFBLog(message: GeTuiSdk.clientId()!)
        let url = BASER_API + login_api + "phone="+phoneNum+"&password="+urlBase+"&clientId="+GeTuiSdk.clientId()!+last_pra_log
        print("编码"+url) 
        var model:LoginModelMapper = LoginModelMapper()
        Alamofire.request(url, method: .post).responseJSON { (returnResult) in
            print("secondMethod --> post 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<LoginModelMapper>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
        
    }


    func findpwd(phoneNum : String, paseWord : String, verification: String,completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {

        let encWithPubKey = RSA.encryptString(paseWord, publicKey: pubkey)
        let urlBase : String =  RSA.encodeParameter(encWithPubKey)
        //15910901725
        let url = BASER_API + findpwd_api + "phone="+phoneNum+"&password="+urlBase+"&verification="+verification+last_pra
        print("编码"+url)
        var model:SmsModel = SmsModel()
        Alamofire.request(url, method: .post).responseJSON { (returnResult) in
            print("secondMethod --> post 请求 --> returnResult = \(returnResult)")
            
            if let json = returnResult.result.value {
                model = Mapper<SmsModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }
            
        }

    }

    
    func get_sms_code(phoneNum : String, type : String, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        
   
        let url = BASER_API + sms_api + "phone="+phoneNum+"&type="+type+last_pra
        KFBLog(message: url)

        var model:SmsModel = SmsModel()
        Alamofire.request(url, method: .get).responseJSON { (returnResult) in
            
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
        
            if let json = returnResult.result.value {
                model = Mapper<SmsModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }
            
        }
        
        
    }


    func logout( completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {


        let url = BASER_API + logout_api + token_pra
        KFBLog(message: url)

        var model:SmsModel = SmsModel()
        Alamofire.request(url, method: .get).responseJSON { (returnResult) in

            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")

            if let json = returnResult.result.value {
                model = Mapper<SmsModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
    }


    
    func register(phoneNum : String, paseWord : String, verification: String,completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        
        let encWithPubKey = RSA.encryptString(paseWord, publicKey: pubkey)
        let urlBase : String =  RSA.encodeParameter(encWithPubKey)
        
        let url = BASER_API + register_api + "phone="+phoneNum+"&password="+urlBase+"&verification="+verification+last_pra_log
        KFBLog(message: url)
        
        var model:ResModelMaper = ResModelMaper()
        Alamofire.request(url, method: .post).responseJSON { (returnResult) in
            
            print("secondMethod --> post 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<ResModelMaper>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }
        }

        
    }
    
    func supplyinfo(name : String, province : Int, city : Int,district : Int,school : Int,grade : Int,subject : Int,book : Int,avatar : String,completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        

        let iconStr : String =  RSA.encodeParameter(avatar)
        let nameStr : String =  RSA.encodeParameter(name)
        let url = BASER_API + supplyinfo_api + "name="+nameStr+"&avatar="+iconStr+"&province="+"\(province)"+"&city="+"\(city)"+"&district="+"\(district)"+"&school="+"\(school)"+"&grade="+"\(grade)"+"&subject="+"\(subject)"+"&book="+"\(book)"+token_pra
   
        KFBLog(message: url)
    
        var model:SmsModel = SmsModel()
        Alamofire.request(url, method: .post).responseJSON { (returnResult) in
            
            print("secondMethod --> post 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<SmsModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }
        }
        
    }
    
    class func setSelectCouse_name_id_heart(name : String , couseid : String, ishaveinfo : String){
        UserDefaults.standard.set("1", forKey: ISHAVECOUSEINFO)
        UserDefaults.standard.set(name, forKey: COUSENAME)
        UserDefaults.standard.set(couseid, forKey: COUSEID)
        UserDefaults.standard.synchronize()

    }
    class func getSelectCouse_name_id_heart() -> (ishaveCouse : String,name : String, couseid:String) {
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
    
    class func setSelectCouse_name_id_teach(name : String , couseid : String, ishaveinfo : String){
        UserDefaults.standard.set("1", forKey: ISHAVECOUSEINFO_TEACH)
        UserDefaults.standard.set(name, forKey: COUSENAME_TEACH)
        UserDefaults.standard.set(couseid, forKey: COUSEID_TEACH)
       UserDefaults.standard.synchronize()

    }
    
    class func getSelectCouse_name_id_teach() -> (ishaveCouse : String,name : String, couseid:String) {
        var isHaveCouse :String? = UserDefaults.standard.value(forKey: ISHAVECOUSEINFO_TEACH) as! String?
        if isHaveCouse == nil {
            isHaveCouse = "0"
        }
        var nameStr :String? = UserDefaults.standard.value(forKey: COUSENAME_TEACH) as! String?
        if nameStr == nil {
            nameStr = ""
        }
        var idStr :String? = UserDefaults.standard.value(forKey: COUSEID_TEACH) as! String?
        if idStr == nil {
            idStr = ""
        }
        return (isHaveCouse!,nameStr!,idStr!)
    }


}
