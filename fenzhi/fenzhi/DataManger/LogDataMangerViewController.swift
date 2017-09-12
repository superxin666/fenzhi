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
        
        let  pubkey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQK\nBgQCs/AKBw1GMHK+0JS6MP+6UJ2WM\nUU1yX4qKhkKvn1vzTQjzIEf1X92+4kH51wkrWVn\nWy8dObblMu6CERDs+lqzkmkp5\np3Yv9wMHnNhxwZYr+qMr73X5Pkn41Qsdbe+rx\nGO7dWSuhmcgY2EbZle6N8bXssZk\n8yK+gz6ReGr7k2lgHwIDAQAB";

        
        let  privkey = "MIICXAIBAAKBgQCs/AKBw1GMHK+0JS6MP+6UJ2WMUU1yX4qKhkKvn1vzTQjzIEf1X92+4kH51wkrWVnWy8dObblMu6CERDs+lqzkmkp5p3Yv9wMHnNhxwZYr+qMr73X5Pkn41Qsdbe+rxGO7dWSuhmcgY2EbZle6N8bXssZk8yK+gz6ReGr7k2lgHwIDAQABAoGANTb9im/MqV61yqRZknmkal1IRwdH3PR5SS4OW7qZbdp381st59VLAQrXowU84+ID2iksMftdMrbRpX7b/uAZZWQb6t1LhuLqo/GO7Ec0DwgQIYpNRDBi+UKqVsjpCbWuYO4rS6u/ezGLSSnD480XBqFBG8GexFg9nVKDfEC+QkECQQDjFieYLlXF8OjFaN2iOzF7M9JM4lGvvWgf9PcXq6MG4e3vcIVAqAr3+sHTuBFwgCOY0TtCPu3P+ndHEZoiREb/AkEAwwJn6O2rnE8/1y7/8BCHRs0AVrkBUmXKbGJUqwNUwLSs0ct0Q9b+jO22RBMTL6Q2q0zAhMiq9lyTlPp3uUMG4QJAd8A3IQlOMhPYrEGgnuyYK2AohmLSsNoxDqkfpFvenMKHtryfiHkVT6/shrmKeMkZ/HxZw5Vr00FBpTijD27yAQJAD4hNhnwHwzd8ukMAF7r5S2ZgtIef11RMPz3FyKlHQuIhMcSmyhCBze/RKLLsQEswH4zJeMoS8/SDvMYGazcvgQJBAKY9w6b2ilCFImZMdiqRJEVMu+eczsTEj9R1HF8Nk8X0hszAFLOqcUu9+MlFI/3C9tvP2P52rdXr/ckKRXP02IU=";
        
        
        let originString = "123456"
        var encWithPubKey = ""
        var decWithPrivKey = ""
    
        print("Original string" + originString)
        
        // Demo: encrypt with public key
        encWithPubKey = RSA.encryptString(originString, publicKey: pubkey)
        print("Enctypted with public key   " + encWithPubKey)
        // Demo: decrypt with private key
        decWithPrivKey = RSA.decryptString(encWithPubKey, privateKey: privkey)
         print("Decrypted with public key   " + decWithPrivKey)
        
        
//        let url = "http://fenzhi.wchao.org/api/user/login?phone=15910901725&password="+encWithPubKey
//        Alamofire.request(url, method: .get).responseJSON { (returnResult) in
//            print("secondMethod --> GET 请求 --> returnResult = \(returnResult)")
//        }
//        
    }
    
    func register(phoneNum : String, paseWord : String, verification: String,completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        let url = BASER_API + login_api
        let dict = [
            "phone":phoneNum,
            "password":paseWord,
            "verification":verification,
            "version":self.getAppVersion(),
            "client":"iphone",
            ]
        
        Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default).responseJSON { (response) in
            
            debugPrint(response)
        }
        
    }

}
