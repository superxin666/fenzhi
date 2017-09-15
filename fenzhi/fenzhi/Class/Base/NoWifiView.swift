//
//  NoWifiView.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/15.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class NoWifiView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setUpNoWifiView() {
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(160), y: ip7(165), width: KSCREEN_WIDTH - ip7(320), height: KSCREEN_WIDTH - ip7(320)))
        iconImageView.image = #imageLiteral(resourceName: "wlyc_wifi")
        self.addSubview(iconImageView)


        let label : UILabel = UILabel(frame: CGRect(x: 0, y: iconImageView.frame.maxY + ip7(60), width: KSCREEN_WIDTH, height: ip7(26)))
        label.text = "页面网络异常"
        label.font = fzFont_Medium(ip7(26))
        label.textColor  = .black
        label.textAlignment = .center
        self.addSubview(label)

        let label2 : UILabel = UILabel(frame: CGRect(x: 0, y: iconImageView.frame.maxY + ip7(7), width: KSCREEN_WIDTH, height: ip7(24)))
        label2.text = "请检查一下网络链接情况！"
        label2.font = fzFont_Thin(ip7(24))
        label2.textColor  = dark_3_COLOUR
        label2.textAlignment = .center
        self.addSubview(label2)

    }

    func setUpNoDta() {
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(160), y: ip7(165), width: KSCREEN_WIDTH - ip7(320), height: KSCREEN_WIDTH - ip7(320)))
        iconImageView.image = #imageLiteral(resourceName: "icon_null")
        self.addSubview(iconImageView)


        let label : UILabel = UILabel(frame: CGRect(x: 0, y: iconImageView.frame.maxY + ip7(60), width: KSCREEN_WIDTH, height: ip7(26)))
        label.text = "页面暂无数据"
        label.font = fzFont_Medium(ip7(26))
        label.textColor  = .black
        label.textAlignment = .center
        self.addSubview(label)
        
    }


}
