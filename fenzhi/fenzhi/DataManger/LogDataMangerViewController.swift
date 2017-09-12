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
        
        let pubkey = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCs/AKBw1GMHK+0JS6MP+6UJ2WM\nUU1yX4qKhkKvn1vzTQjzIEf1X92+4kH51wkrWVnWy8dObblMu6CERDs+lqzkmkp5\np3Yv9wMHnNhxwZYr+qMr73X5Pkn41Qsdbe+rxGO7dWSuhmcgY2EbZle6N8bXssZk\n8yK+gz6ReGr7k2lgHwIDAQAB\n-----END PUBLIC KEY-----\n";
        
        let  privkey = "-----BEGIN PRIVATE KEY-----\nMIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKz8AoHDUYwcr7Ql\nLow/7pQnZYxRTXJfioqGQq+fW/NNCPMgR/Vf3b7iQfnXCStZWdbLx05tuUy7oIRE\nOz6WrOSaSnmndi/3Awec2HHBliv6oyvvdfk+SfjVCx1t76vEY7t1ZK6GZyBjYRtm\nV7o3xteyxmTzIr6DPpF4avuTaWAfAgMBAAECgYA1Nv2Kb8ypXrXKpFmSeaRqXUhH\nB0fc9HlJLg5buplt2nfzWy3n1UsBCtejBTzj4gPaKSwx+10yttGlftv+4BllZBvq\n3UuG4uqj8Y7sRzQPCBAhik1EMGL5QqpWyOkJta5g7itLq797MYtJKcPjzRcGoUEb\nwZ7EWD2dUoN8QL5CQQJBAOMWJ5guVcXw6MVo3aI7MXsz0kziUa+9aB/09xerowbh\n7e9whUCoCvf6wdO4EXCAI5jRO0I+7c/6d0cRmiJERv8CQQDDAmfo7aucTz/XLv/w\nEIdGzQBWuQFSZcpsYlSrA1TAtKzRy3RD1v6M7bZEExMvpDarTMCEyKr2XJOU+ne5\nQwbhAkB3wDchCU4yE9isQaCe7JgrYCiGYtKw2jEOqR+kW96cwoe2vJ+IeRVPr+yG\nuYp4yRn8fFnDlWvTQUGlOKMPbvIBAkAPiE2GfAfDN3y6QwAXuvlLZmC0h5/XVEw/\nPcXIqUdC4iExxKbKEIHN79EosuxASzAfjMl4yhLz9IO8xgZrNy+BAkEApj3DpvaK\nUIUiZkx2KpEkRUy755zOxMSP1HUcXw2TxfSGzMAUs6pxS734yUUj/cL228/Y/nat\n1ev9yQpFc/TYhQ==\n-----END PRIVATE KEY-----\n";
        
        
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

        
        let url = "http://fenzhi.wchao.org/api/user/login?client=iphone&version=071313&phone=15910901725&password="+encWithPubKey
        Alamofire.request(url, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> GET 请求 --> returnResult = \(returnResult)")
        }
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
