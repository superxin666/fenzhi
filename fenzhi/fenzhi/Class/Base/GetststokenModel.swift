//
//  GetststokenModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/11/30.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class GetststokenModel_data_credentials: Mappable {
    
    var AccessKeySecret : String = ""
    var AccessKeyId : String = ""
    var Expiration : String = ""
    var SecurityToken : String = ""
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        AccessKeySecret <- map["AccessKeySecret"]
        AccessKeyId <- map["AccessKeyId"]
        Expiration <- map["Expiration"]
        SecurityToken <- map["SecurityToken"]
    }
    
}

class GetststokenModel_data: Mappable {
    
    var credentials : GetststokenModel_data_credentials = GetststokenModel_data_credentials()
    
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        credentials <- map["credentials"]
    }
    
}

class GetststokenModel: Mappable {
    
    var errno: Int!
    var errmsg : String = ""
    var data : GetststokenModel_data = GetststokenModel_data()
    
    
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
