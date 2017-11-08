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
    
    var fileManager = FileManager.default
    var downloadRequest: DownloadRequest!
    /// 首页feed接口
    ///
    /// - Parameters:
    ///   - pageNum:     页码
    ///   - count:     每页的条数
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func getfeedlist(pageNum : Int,count : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + getfeedlist_api+"pageNum=" + "\(pageNum)"+"&count="+"\(count)"+last_pra+token_pra
        var model:GetmyfeedlistModel = GetmyfeedlistModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<GetmyfeedlistModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }
            
        }
    }
    
    
    
    

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




    /// 获取评论列表接口
    ///
    /// - Parameters:
    ///   - fenxId:     分享id
    ///   - pageNum: 当前的页码 从1开始计数 默认为1
    ///   - count:     每页多少条 默认10
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
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


    /// 发布评论接口
    ///
    /// - Parameters:
    ///   - content:     评论内容
    ///   - fenxId:     分享id
    ///   - toUserId:     被评论用户id，当回复别人的评论时需要传递该参数
    ///   - toCommentId:     被评论的评论id，当回复别人的评论时需要传递该参数
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func submitcomment(content : String,fenxId : Int, toUserId : Int,toCommentId : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let contentStr : String  = RSA.encodeParameter(content)
        var urlStr = ""
        if toUserId != 0 && toCommentId != 0 {
            urlStr = BASER_API + submitcomment_api + "fenxId="+"\(fenxId)"+"&content="+contentStr+"&toUserId="+"\(toUserId)"+"&toCommentId="+"\(toCommentId)" + last_pra + token_pra
        } else {
             urlStr = BASER_API + submitcomment_api + "fenxId="+"\(fenxId)"+"&content="+contentStr + last_pra + token_pra

        }

        var model:SubmitcommentModel = SubmitcommentModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .post).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<SubmitcommentModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }
        }
    }


    /// 删除评论接口
    ///
    /// - Parameters:
    ///   - fenxId:     评论id
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func delcomment(commentId : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + delcomment_api + "commentId="+"\(commentId)"+last_pra+token_pra
        var model:SmsModel = SmsModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<SmsModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
    }



    /// 收藏接口
    ///
    /// - Parameters:
    ///   - fenxId:     分享id
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func favorite(fenxId : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + favorite_api + "fenxId="+"\(fenxId)"+last_pra+token_pra
        var model:SmsModel = SmsModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<SmsModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
    }


    /// 取消收藏接口
    ///
    /// - Parameters:
    ///   - fenxId:     分享id
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func delfavorite(fenxId : Int, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //
        let urlStr = BASER_API + delfavorite_api + "fenxId="+"\(fenxId)"+last_pra+token_pra
        var model:SmsModel = SmsModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> get 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<SmsModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }

        }
    }


    func submitfenx_heart(content : String,catalog_id : String, images : Array<String>, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //

        KFBLog(message: catalog_id)
        let contentStr : String  = RSA.encodeParameter(content)
        var urlStr = BASER_API + submitfenx_api + "content="+contentStr + "&type=" + "\(1)" + "&catalog_id=" + catalog_id + last_pra + token_pra

        if images.count > 0 {
            let data = try? JSONSerialization.data(withJSONObject: images, options: [])
            let jsonStr :String = String(data: data!, encoding: String.Encoding.utf8)!
            let imageUncode : String = RSA.encodeParameter(jsonStr)
            urlStr = BASER_API + submitfenx_api + "content=" + contentStr + "&type=" + "\(1)" + "&catalog_id=" + catalog_id + "&images=" + imageUncode + last_pra + token_pra
        }

        var model:SmsModel = SmsModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .post).responseJSON { (returnResult) in
            print("secondMethod --> post 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<SmsModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }
        }
    }

    func submitfenx_teach(content : String,catalog_id : String, file : Array<Dictionary<String,String>>, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //

        let contentStr : String  = RSA.encodeParameter(content)
        let data = try? JSONSerialization.data(withJSONObject: file, options: [])
        let jsonStr :String = String(data: data!, encoding: String.Encoding.utf8)!
        let filesUncode : String = RSA.encodeParameter(jsonStr)
        let  urlStr = BASER_API + submitfenx_api + "content=" + contentStr + "&type=" + "\(0)" + "&catalog_id=" + catalog_id + "&coursewares=" + filesUncode + last_pra + token_pra
        var model:SmsModel = SmsModel()
        KFBLog(message: urlStr)
        Alamofire.request(urlStr, method: .post).responseJSON { (returnResult) in
            print("secondMethod --> post 请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value {
                model = Mapper<SmsModel>().map(JSON: json as! [String : Any])!
                completion(model)
            } else {
                failure("请求失败")
            }
        }
    }

    func downLoadFile(path : String,name : String, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        //

        
        if fileManager.fileExists(atPath: filePath_downLoad) {
            KFBLog(message: "文件夹已存在")
        } else {
            KFBLog(message: "创建文件夹")
            do {
                try fileManager.createDirectory(atPath: filePath_downLoad, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                KFBLog(message: "创建文件夹失败")
            }
        }
        
        //检查文件是否下载过
        KFBLog(message: path)
        KFBLog(message: name)
        let filePathStr : String = filePath_downLoad + "/" + name
        KFBLog(message: filePathStr)
        if fileManager.fileExists(atPath: filePathStr) {
            KFBLog(message: "文件已存在")

            completion(filePathStr)
            
        } else {
            //需要下载
            
            let vc = BaseViewController()
            
            
            let url  = URL(string: path)
            let fileData = NSData(contentsOf: url!)
            KFBLog(message: "下载文件")
            KFBLog(message: fileData?.length)
            let filePathStr : String = filePath_downLoad + "/" + name
          
//            DispatchQueue.main.async {
//                vc.SVshow(infoStr: "加载中")
//            }
        
            
            DispatchQueue.global().async {
                let isok =  fileData?.write(toFile: filePathStr, atomically: true)
                DispatchQueue.main.async{
//                    vc.SVdismiss()
                    if let _ = isok {
                        KFBLog(message: "文件保存成功")
                        completion(filePathStr)
                    } else {
                        
                        KFBLog(message: "文件保存失败")
                    }
                }
            }
      
        }
       
    }
    
    func downLoadRequest(ulrStr : String,downUrl : String){
        let destination:DownloadRequest.DownloadFileDestination =  { _, response in
            let fileUrl = URL(fileURLWithPath: ulrStr)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        downloadRequest = Alamofire.download(downUrl, to: destination)
        self.downloadRequest.downloadProgress(queue: DispatchQueue.main,
                                              closure: downloadProgress) //下载进度
        self.downloadRequest.responseData(completionHandler: downloadResponse)
    }
    
    func downloadProgress(progress: Progress) {
        //进度条更新

    }
    func downloadResponse(response: DownloadResponse<Data>) {
        switch response.result {
        case .success(let data):
            //self.image = UIImage(data: data)
            print("文件下载完毕: \(response)")
        case .failure:
//            self.cancelledData = response.resumeData //意外终止的话，把已下载的数据储存起来
             print("文件下载失败: \(response)")
        }
    }
    
 
    
}
