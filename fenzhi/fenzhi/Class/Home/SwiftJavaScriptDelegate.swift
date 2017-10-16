//
//  SwiftJavaScriptDelegate.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//
import JavaScriptCore

@objc protocol SwiftJavaScriptDelegate : JSExport{
    func save_click(selCatalogId : String,selCatalogName:String)
    func cancle_click()
}
