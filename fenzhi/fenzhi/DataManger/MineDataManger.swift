//
//  MineDataManger.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/15.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

class MineDataManger: FZRequestViewController {



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

    func getfanslist(pageNum : Int, count : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + getfanslist_api + "pageNum="+"\(pageNum)"+"&count="+"\(count)"+last_pra
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



}
