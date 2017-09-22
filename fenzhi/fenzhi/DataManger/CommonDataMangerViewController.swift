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



    /// 获取教材列表接口
    ///
    /// - Parameters:
    ///   - version:     教材版本id, id数据可从公共数据接口中获取，目前只支持人教版
    ///   - grade:     年级id, id数据可从公共数据接口中获取
    ///   - subject: 学科id, id数据可从公共数据接口中获取
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
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

    /// 上传图片接口
    ///
    /// - Parameters:
    ///   - uploadimg: 	图片二进制内容
    ///   - type: 	类型, normal: 普通图片 avatar: 头像
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func upLoadImage(uploadimg:UIImage,type:String, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + uploadimg_api + "type=" + type + token_pra
        KFBLog(message: urlStr)
        let imageData = UIImageJPEGRepresentation(uploadimg, 1.0)!

        var model:UploadimgModel = UploadimgModel()
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "imgFile", fileName: "imgFile", mimeType: "image/*")

        },
            to: urlStr,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let json = response.result.value {
                            model = Mapper<UploadimgModel>().map(JSON: json as! [String : Any])!
                            completion(model)
                        } else {
                            failure("请求失败")
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    
    
    
    /// 点赞接口
    ///
    /// - Parameters:
    ///   - type:     类型: 0-分享 1-评论
    ///   - objectId:     对象id, 如果点赞的是分享就是分享id 如果点赞的是评论就是评论id
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func like(type : Int,objectId : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + like_api+"type="+"\(type)"+"&objectId="+"\(objectId)"+last_pra+token_pra
        var model:LikeModel = LikeModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<LikeModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
    }
    

}
