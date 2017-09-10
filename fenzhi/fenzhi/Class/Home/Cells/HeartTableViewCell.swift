//
//  HeartTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/8.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//  心得分享 cell

import UIKit

class HeartTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpUIWithModel() {
        
        let viewW = KSCREEN_WIDTH - ip7(20)
        let viewH = ip7(300)
        
        
        let backView : UIView = UIView(frame: CGRect(x: ip7(10), y: 0, width: viewW, height: viewH - ip7(10)))
        backView.backgroundColor = .white
        self.addSubview(backView)
        //头像
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(25), y: ip7(25), width: ip7(60), height: ip7(60)))
        iconImageView.image = #imageLiteral(resourceName: "touxiang")
        backView.addSubview(iconImageView)
        
        //时间
        let timeLabel : UILabel = UILabel(frame: CGRect(x: viewW - ip7(31) - ip7(90), y: ip7(25), width: ip7(90), height: ip7(20)))
        timeLabel.text = "24:00"
        timeLabel.font = fzFont_Thin(ip7(15))
        timeLabel.textColor  = FZColor(red: 197, green: 198, blue: 203, alpha: 1.0)
        timeLabel.textAlignment = .right
        timeLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(timeLabel)
        
        //105105105
        //名字
        let nameWidth = viewW - ip7(19) - iconImageView.frame.maxX - ip7(31) - ip7(90)
        let nameLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y:  ip7(25), width: nameWidth, height: ip7(24)))
        nameLabel.text = "尼古拉斯赵四"
        nameLabel.textColor = FZColorFromRGB(rgbValue: 0x333333)
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(nameLabel)

        //用户信息
        let infoLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y: nameLabel.frame.maxY + ip7(14), width: viewW - ip7(19) - iconImageView.frame.maxX, height: ip7(21)))
        infoLabel.text = "北京 三年级语文老师"
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        infoLabel.textAlignment = .left
        infoLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(infoLabel)


        //文字
        let str = "你好赵四我是你刘能你好赵四我是你刘"
        let txtW = viewW - ip7(50)
        var txtH :CGFloat = str.getLabHeight(font: fzFont_Thin(ip7(21)), LabelWidth: txtW)
        if txtH > ip7(21) * 4 {
            txtH = ip7(21) * 4
        }
        let txtLabel : UILabel = UILabel(frame: CGRect(x: ip7(25), y: infoLabel.frame.maxY + ip7(17), width: txtW, height: txtH))
        txtLabel.text = str
        txtLabel.font = fzFont_Thin(ip7(21))
        txtLabel.textColor  = FZColor(red: 102, green: 102, blue: 102, alpha: 1.0)
        txtLabel.textAlignment = .left
        txtLabel.numberOfLines = 0
        backView.addSubview(txtLabel)




        //图片

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
