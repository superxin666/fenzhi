//
//  MineDataManger.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/15.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//   个人设置

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

class MineDataManger: FZRequestViewController {




    /// 获取关注列表
    ///
    /// - Parameters:
    ///   - pageNum: 	页码
    ///   - count: 	每页的条数
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func getfollowlist(pageNum : Int, count : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
//
        let urlStr = BASER_API + getfollowlist_api + "pageNum="+"\(pageNum)"+"&count="+"\(count)"+last_pra
        var model:FollowModel = FollowModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<FollowModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
        
    }


    /// 获取粉丝列表接口
    ///
    /// - Parameters:
    ///   - pageNum: pageNum
    ///   - count: count
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func getfanslist(pageNum : Int, count : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //

        
        let urlStr = BASER_API + getfanslist_api + "pageNum="+"\(pageNum)"+"&count="+"\(count)"+last_pra+token_pra
        var model:FollowModel = FollowModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<FollowModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
        
    }


    /// 用户个人信息接口
    ///
    /// - Parameters:
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func info( completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {

//        let token = self.getToken_RSA()

        //15910901725  + "token="+token
        let url = BASER_API + info_api
        print("编码"+url)
        var model:LoginModelMapper = LoginModelMapper()
        Alamofire.request(url, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<LoginModelMapper>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }

    }


    /// 获取收藏列表接口
    ///
    /// - Parameters:
    ///   - pageNum: 	页码
    ///   - count: <#count description#>
    ///   - completion: 	每页的条数
    ///   - failure: <#failure description#>
    func getfavoritelist(pageNum : Int, count : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + getfavoritelist_api + "pageNum="+"\(pageNum)"+"&count="+"\(count)"+last_pra+token_pra
        var model:GetzanlistModel = GetzanlistModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<GetzanlistModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
        
    }


    func getzanlistlist(pageNum : Int, count : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + getzanlist_api + "pageNum="+"\(pageNum)"+"&count="+"\(count)"+last_pra+token_pra
        var model:GetzanlistModel = GetzanlistModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<GetzanlistModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }

    }

    func getgetincomelist(pageNum : Int, count : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + getincomelist_api + "pageNum="+"\(pageNum)"+"&count="+"\(count)"+last_pra+token_pra
        var model:GetincomelistModl = GetincomelistModl()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<GetincomelistModl>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
        
    }

}
