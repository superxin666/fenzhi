//
//  createorderModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/20.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class createorderModel_data_wxpay: Mappable {
    
    var appid : String = ""
    var partnerid : String = ""
    var prepayid : String = ""
    var package : String = ""
    var noncestr : String = ""
    var timestamp : String = ""
    var sign : String = ""
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        appid <- map["appid"]
        partnerid <- map["partnerid"]
        prepayid <- map["prepayid"]
        package <- map["package"]
        noncestr <- map["noncestr"]
        timestamp <- map["timestamp"]
        sign <- map["sign"]
    }
    
}

class createorderModel_data: Mappable {
    

    var orderId : String = ""
    var wxpay : createorderModel_data_wxpay = createorderModel_data_wxpay()

    
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        orderId <- map["orderId"]
        wxpay <- map["wxpay"]
    }
    
}

class createorderModel: Mappable {
    
    var errno: Int = 1
    var errmsg : String = ""
    var logId : String = ""
    var data : createorderModel_data = createorderModel_data()
    
    
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
