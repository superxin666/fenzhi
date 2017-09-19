//
//  ShouruHeadView.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/18.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class ShouruHeadView: UIView {
    let label:UILabel = UILabel()



    func setUpUIWithModel_cellType() {
        let viewH = ip7(120)

        let backView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: viewH))
        backView.backgroundColor = .white
        self.addSubview(backView)



        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(15), y:  (viewH - ip7(65))/2, width: ip7(50), height: ip7(65) ))
        iconImageView.image = #imageLiteral(resourceName: "icon_wdsr-1")
        backView.addSubview(iconImageView)

        label.frame = CGRect(x:iconImageView.frame.maxX +  ip7(25), y:  (viewH - ip7(65))/2, width: ip7(24*4), height: ip7(24))
        label.text = "当前收入"
        label.textColor = dark_3_COLOUR
        label.font = fzFont_Medium(ip7(24))
        backView.addSubview(label)

        let monyLabel : UILabel = UILabel(frame: CGRect(x: label.frame.maxX + ip7(10), y:  (viewH - ip7(65))/2, width: ip7(120), height:ip7(25) ))
        monyLabel.text = "\(90)元"
        monyLabel.isUserInteractionEnabled = true
        monyLabel.textColor = blue_COLOUR
        monyLabel.font = fzFont_Medium(ip7(27))
        monyLabel.adjustsFontSizeToFitWidth = true
        monyLabel.textAlignment = .right
        backView.addSubview(monyLabel)


        let infoLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX +  ip7(25), y: monyLabel.frame.maxY + ip7(12), width: KSCREEN_WIDTH - label.frame.maxX - ip7(10), height: ip7(21)))
        infoLabel.font = fzFont_Medium(ip7(21))
        infoLabel.textColor  = dark_6_COLOUR
        infoLabel.textAlignment = .left
        infoLabel.text = "提现请联系客服qq：814038418"
        backView.addSubview(infoLabel)

    }



    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */


}
