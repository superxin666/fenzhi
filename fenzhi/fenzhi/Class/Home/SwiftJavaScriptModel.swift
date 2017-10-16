//
//  SwiftJavaScriptModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import JavaScriptCore

class SwiftJavaScriptModel: NSObject,SwiftJavaScriptDelegate {
     weak var controller: UIViewController?
     weak var jsContext: JSContext?
    
    func save_click(selCatalogId: String, selCatalogName: String) {
        KFBLog(message: selCatalogId)
        KFBLog(message: selCatalogName)
    }
    
    func cancle_click() {
        KFBLog(message: "取消")
    }
}
