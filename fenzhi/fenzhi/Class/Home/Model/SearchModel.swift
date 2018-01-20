//
//  SearchModel.swift
//  fenzhi
//
//  Created by lvxin on 2018/1/20.
//  Copyright © 2018年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class SearchModel_data_fenx: Mappable {
    var totalNum: Int = 0
    var pageNum : Int = 0
    var count : Int = 0
    var list :[GetmyfeedlistModel_data_fenxList] = []
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        totalNum <- map["totalNum"]
        pageNum <- map["pageNum"]
        count <- map["count"]
        list <- map["list"]
        
    }
}


class SearchModel_data_user: Mappable {
    var totalNum: Int = 0
    var pageNum : Int = 0
    var count : Int = 0
    var list :[UserInfoModel] = []
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        totalNum <- map["totalNum"]
        pageNum <- map["pageNum"]
        count <- map["count"]
        list <- map["list"]
        
    }
}


class SearchModel_data: Mappable {
    var fenx: [GetmyfeedlistModel_data] = []
    var user : SearchModel_data_user = SearchModel_data_user()
    
    
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        fenx <- map["fenx"]
        user <- map["user"]
        
    }
}


class SearchModel: Mappable {
    var errno: Int = 1
    var errmsg : String = ""
    var data : SearchModel_data = SearchModel_data()
    
    
    
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
