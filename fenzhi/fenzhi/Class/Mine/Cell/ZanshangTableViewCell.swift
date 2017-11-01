//
//  ZanshangTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class ZanshangTableViewCell: UITableViewCell {


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func setUpUIWithModel_cellType(model :GetzanlistModel_data_list) {
        let viewH = ip7(155)

        let label : UILabel = UILabel(frame: CGRect(x:ip7(27), y:  ip7(25), width: ip7(63), height: ip7(21)))
        label.text = "赞赏了"
        label.isUserInteractionEnabled = true
        label.textColor = dark_6_COLOUR
        label.font = fzFont_Thin(ip7(21))
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)

        let nameWidth = KSCREEN_WIDTH - ip7(17) - label.frame.maxX - ip7(31) - ip7(90)
        let nameLabel : UILabel = UILabel(frame: CGRect(x: label.frame.maxX + ip7(17), y:  ip7(25), width: nameWidth, height: ip7(21)))
        nameLabel.text = model.name
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        nameLabel.font = fzFont_Medium(ip7(21))
        nameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(nameLabel)
//model.price = 200
        let monyWidth = KSCREEN_WIDTH - ip7(40) - ip7(120)
        let monyLabel : UILabel = UILabel(frame: CGRect(x: monyWidth, y:  ip7(25), width: ip7(120), height: ip7(21)))
        monyLabel.text = "\(model.price/100)元"
        monyLabel.isUserInteractionEnabled = true
        monyLabel.textColor = dark_3_COLOUR
        monyLabel.font = fzFont_Medium(ip7(21))
        monyLabel.adjustsFontSizeToFitWidth = true
        monyLabel.textAlignment = .right
        self.addSubview(monyLabel)


        let typeLabel : UILabel = UILabel(frame: CGRect(x: ip7(27), y: nameLabel.frame.maxY + ip7(22), width: ip7(110), height: ip7(21)))
        if model.type == 0 {
            typeLabel.text = "教学分享："
        } else {
            typeLabel.text = "心得分享："

        }
        typeLabel.font = fzFont_Thin(ip7(21))
        typeLabel.textColor  = dark_6_COLOUR
        typeLabel.textAlignment = .left
        self.addSubview(typeLabel)


        let infoLabel : UILabel = UILabel(frame: CGRect(x: typeLabel.frame.maxX, y: nameLabel.frame.maxY + ip7(22), width: KSCREEN_WIDTH  - typeLabel.frame.maxX, height: ip7(21)))
        infoLabel.text = model.catalog
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = blue_COLOUR
        infoLabel.textAlignment = .left
        infoLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(infoLabel)


        let timeLabel : UILabel = UILabel(frame: CGRect(x: ip7(27), y: infoLabel.frame.maxY + ip7(15), width: ip7(200), height: ip7(18)))
        timeLabel.text = model.createTime
        timeLabel.font = fzFont_Thin(ip7(18))
        timeLabel.textColor  = dark_a_COLOUR
        timeLabel.textAlignment = .left
        self.addSubview(timeLabel)


        let lineView : UIView = UIView(frame: CGRect(x: ip7(27), y: viewH - 0.5, width: KSCREEN_WIDTH - ip7(27), height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        self.addSubview(lineView)

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
