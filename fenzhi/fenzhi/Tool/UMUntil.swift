//
//  UMUntil.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/23.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let UMKEY = "59ce05e265b6d66f26000235"
let WECHATKEY = "wx62e8de46fa3ca72c"
let WECHASECRET = "3514a03fffff6336853162c87e2665b5"

typealias SHAREBLOCK = (_ type: UMSocialPlatformType)->()

class UMUntil: NSObject {
    var platform : UMSocialPlatformType!
    
    
    func getShareUI_BottomAndIconAndBGRadius() {
        UMSocialUIManager.removeAllCustomPlatformWithoutFilted()
        UMSocialShareUIConfig.shareInstance().sharePageGroupViewConfig.sharePageGroupViewPostionType = .bottom
        UMSocialShareUIConfig.shareInstance().sharePageScrollViewConfig.shareScrollViewPageItemStyleType = .iconAndBGRadius
    }
    
    func setPreDefinePlatforms() {
        UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.QQ,UMSocialPlatformType.qzone,UMSocialPlatformType.wechatTimeLine,UMSocialPlatformType.wechatSession])
    }
    
   static func setUpUM() {
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = UMKEY
        UMSocialManager.default().setPlaform(.wechatSession, appKey: WECHATKEY, appSecret: WECHASECRET, redirectURL: nil)
        UMSocialManager.default().setPlaform(.QQ, appKey: "", appSecret: "", redirectURL: nil)
    }
    
    
    func shareWebUrlToPlatformWithUrl(webUlr : String,controller:UIViewController,thumbUrl : String,title : String,des : String)  {
        let messageObject :UMSocialMessageObject = UMSocialMessageObject()
        let shareObject : UMShareWebpageObject = UMShareWebpageObject()
        let imageData = NSData(contentsOf: URL(string: thumbUrl)!)
        let image = UIImage(data: imageData! as Data)
        shareObject.thumbImage = image
        shareObject.title = title
        shareObject.descr = des
        shareObject.webpageUrl = webUlr
        messageObject.shareObject = shareObject
        
        UMSocialManager.default().share(to: platform, messageObject: messageObject, currentViewController: controller) { (data, error) in
            if (error != nil) {
                KFBLog(message: error)
                
            } else {
                if data is UMSocialShareResponse {
                    let resp :UMSocialShareResponse  = data as! UMSocialShareResponse
                    KFBLog(message: resp.message)
                }
            }
        }
        
    }
    
    func sharClick(share : @escaping SHAREBLOCK)  {
        self.setPreDefinePlatforms()
        self.getShareUI_BottomAndIconAndBGRadius()
        UMSocialUIManager.showShareMenuViewInWindow { (platformtype, userInfo) in
            KFBLog(message: "点击平台\(platformtype)")
            self.platform = platformtype
            share(platformtype)
        }
    }
    
}
