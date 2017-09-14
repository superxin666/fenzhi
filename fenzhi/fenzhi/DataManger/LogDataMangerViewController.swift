//
//  LogDataMangerViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/12.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

class LogDataMangerViewController: FZRequestViewController {

    func login(phoneNum : String, paseWord : String, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        
        let encWithPubKey = RSA.encryptString(paseWord, publicKey: pubkey)
        let urlBase : String =  RSA.encodeParameter(encWithPubKey)
        //15910901725
        let url = BASER_API + login_api + "phone="+phoneNum+"&password="+urlBase+last_pra_log
        print("编码"+url)
        var model:LoginModelMapper = LoginModelMapper()
        Alamofire.request(url, method: .post).responseJSON { (returnResult) in
            print("secondMethod --> post 请求 --> returnResult = \(returnResult)")
              model = Mapper<LoginModelMapper>().map(JSON: returnResult.result.value as! [String : Any])!
            completion(model)
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
            model = Mapper<SmsModel>().map(JSON: returnResult.result.value as! [String : Any])!
            completion(model)
        }

    }

    
    func get_sms_code(phoneNum : String, type : String, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        
   
        let url = BASER_API + sms_api + "phone="+phoneNum+"&type="+type+last_pra
        KFBLog(message: url)

        var model:SmsModel = SmsModel()
        Alamofire.request(url, method: .get).responseJSON { (returnResult) in
            
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
        
            model = Mapper<SmsModel>().map(JSON: returnResult.result.value as! [String : Any])!
            completion(model)
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
            model = Mapper<ResModelMaper>().map(JSON: returnResult.result.value as! [String : Any])!
            completion(model)
        }

        
    }

}
