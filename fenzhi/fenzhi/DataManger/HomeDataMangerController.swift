//
//  HomeViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/19.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON
class HomeDataMangerController: FZRequestViewController {

    /// 分享详情接口
    ///
    /// - Parameters:
    ///   - fenxId: 	分享ID
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func profile(fenxId : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + profile_api + "fenxId="+"\(fenxId)"+last_pra+token_pra
        var model:TeachDetailModel = TeachDetailModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<TeachDetailModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
    }



    
    func getcommentlist(fenxId : Int, pageNum : Int,count : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + getcommentlist_api + "fenxId="+"\(fenxId)"+"&pageNum="+"\(pageNum)"+"&count="+"\(count)"+last_pra+token_pra
        var model:GetcommentlistModel = GetcommentlistModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<GetcommentlistModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
    }

}