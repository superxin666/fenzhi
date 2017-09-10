//
//  fzStr.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/10.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//
//import Foundation
import UIKit


extension String {

    /// 测文字的高度
    ///
    /// - parameter width: 宽度限制
    /// - parameter font:  字体
    ///
    /// - returns: 高度
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }


    func widthWithConstrainedWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width:  CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }


    //    由字符串获取label高度
    func getLabHeight(font:UIFont,LabelWidth:CGFloat) -> CGFloat {
        let statusLabelText: NSString = self as NSString
        let size = CGSize(width:LabelWidth,height: 900)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.height
    }

    //    由字符串获取label宽度
    func getLabWidth(labelStr:String,font:UIFont,LabelHeight:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width:900,height: LabelHeight)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.width
    }

}
