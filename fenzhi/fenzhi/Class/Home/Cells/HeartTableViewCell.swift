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
        timeLabel.font = fzFont_Medium(15)
        timeLabel.textAlignment = .right
        timeLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(timeLabel)
        
        
        //名字
        let nameLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y:  ip7(25), width: 0, height: ip7(24)))
        nameLabel.text = "尼古拉斯赵四"
        nameLabel.font = fzFont_Medium(24)
        nameLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(nameLabel)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
