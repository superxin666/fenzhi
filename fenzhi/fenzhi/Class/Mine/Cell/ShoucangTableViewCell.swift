//
//  ShoucangTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class ShoucangTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func setUpUIWithModel_cellType(model :GetzanlistModel_data_list) {
        let viewH = ip7(95)
        //头像
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(27), y:  (viewH - ip7(50))/2, width: ip7(50), height: ip7(50) ))
        iconImageView.kf.setImage(with: URL(string: model.avatar))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.kfb_makeRound()
        self.addSubview(iconImageView)


        let nameWidth = KSCREEN_WIDTH - ip7(19) - iconImageView.frame.maxX - ip7(31) - ip7(120)
        let nameLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y:  ip7(25), width: nameWidth, height: ip7(24)))
        nameLabel.text = model.name
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(nameLabel)

        let timeLabel : UILabel = UILabel(frame: CGRect(x: KSCREEN_WIDTH - ip7(31) - ip7(120), y: ip7(25), width: ip7(120), height: ip7(20)))
        timeLabel.text = model.createTime
        timeLabel.font = fzFont_Thin(ip7(15))
        timeLabel.textColor  = dark_a_COLOUR
        timeLabel.textAlignment = .right
        self.addSubview(timeLabel)

        let typeLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y: nameLabel.frame.maxY + ip7(14), width: ip7(125), height: ip7(24)))
        if model.type == 0 {
            typeLabel.text = "教学分享："
        } else {
            typeLabel.text = "心得分享："

        }
        typeLabel.font = fzFont_Thin(ip7(24))
        typeLabel.textColor  = dark_6_COLOUR
        typeLabel.textAlignment = .left
        self.addSubview(typeLabel)


        let infoLabel : UILabel = UILabel(frame: CGRect(x: typeLabel.frame.maxX, y: nameLabel.frame.maxY + ip7(14), width: KSCREEN_WIDTH  - typeLabel.frame.maxX, height: ip7(21)))
        infoLabel.text = model.catalog
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = blue_COLOUR
        infoLabel.textAlignment = .left
        infoLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(infoLabel)


        let lineView : UIView = UIView(frame: CGRect(x: ip7(27), y: viewH - 0.5, width: KSCREEN_WIDTH - ip7(27), height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        self.addSubview(lineView)
        
        
    }


}
