//
//  pch.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let KSCREEN_WIDTH = UIScreen.main.bounds.size.width
let KSCREEN_HEIGHT = UIScreen.main.bounds.size.height
let LNAVIGATION_HEIGHT = CGFloat(44+20)


var fzFont_Thin = { (num : CGFloat) ->  UIFont in
    return  UIFont.init(name: "HelveticaNeue-Thin", size: num)!
}

var fzFont_Medium = { (num : CGFloat) ->  UIFont in
    return  UIFont.init(name: "HelveticaNeue-Medium", size: num)!
}


var ip7 = { (num : Int) ->  CGFloat in
    return CGFloat(num)/540 * CGFloat(KSCREEN_WIDTH)
}
/// 输入三色值返回颜色
///
/// - parameter red:   红的
/// - parameter green: 绿
/// - parameter blue:  蓝
/// - parameter alpha: 透明度
///
/// - returns: UIColor
func FZColor(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

/// 输入16进制返回颜色
///
/// - parameter rgbValue: 16进制颜色
///
/// - returns: UIColor
func FZColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

let blue_COLOUR = FZColor(red: 21, green: 165, blue: 234, alpha: 1)






