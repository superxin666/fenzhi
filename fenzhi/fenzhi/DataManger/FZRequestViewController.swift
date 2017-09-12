//
//  FZRequestViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/12.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class FZRequestViewController: UIViewController {

    // MARK: 公共部分
    /// 获取版本号
    ///
    /// - returns: 版本号
    func getAppVersion() -> String  {
        let infoDict = Bundle.main.infoDictionary
        if let info = infoDict {
            let appVersion = info["CFBundleShortVersionString"] as! String!
            return ("ios_" + appVersion!)
        } else {
            return ""
        }
    }

}
