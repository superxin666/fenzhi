//
//  CommonDataMangerViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//  通用数据

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON
class CommonDataMangerViewController: FZRequestViewController {

//    通用
    func getCommon(completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + common_api
        var model:CommonModel = CommonModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<CommonModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }
        }
        
    }


    /// 区域列表
    ///
    /// - Parameters:
    ///   - parentId: 父层级id, 例如北京是1 省份与直辖市的id从获取公共数据接口中获取
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func getgetregionlist(parentId:Int,completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + getregionlist_api+"parentId="+"\(parentId)"
        var model:GetregionlistModel = GetregionlistModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<GetregionlistModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }
        }

    }


    /// 获取学校列表接口
    ///
    /// - Parameters:
    ///   - regionId: 地区id，目前支持到区级别，即获取区域列表中type为3的区域
    ///   - type: 类型: 0-小学 1-初中 2-高中
    ///   - pageNum: 翻页页码，从1开始计数，默认是1
    ///   - count: 	每页的条数，默认20
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func getschoollist(regionId : Int,type : Int, pageNum : Int,count : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + getschoollist_api+"regionId="+"\(regionId)"+"&type="+"\(type)"+"&pageNum="+"\(pageNum)"+"&count="+"\(count)"
        var model:GetschoollistModel = GetschoollistModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<GetschoollistModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
        
    }

    func getbooklist(version : Int,grade : Int, subject : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + getbooklist_api+"version="+"\(version)"+"&grade="+"\(grade)"+"&subject="+"\(subject)"
        var model:GetbooklistModel = GetbooklistModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<GetbooklistModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }

    }

}
