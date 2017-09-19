//
//  ShouruTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/18.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class ShouruTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpUIWithModel_cellType(model :GetincomelistModl_data_incomeList) {
        let viewH = ip7(155)

        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(27), y:  (viewH - ip7(50))/2, width: ip7(50), height: ip7(50) ))
        iconImageView.kf.setImage(with: URL(string: model.avatar))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.kfb_makeRound()
        self.addSubview(iconImageView)

        let nameWidth = KSCREEN_WIDTH - iconImageView.frame.maxX - ip7(24) - ip7(40) - ip7(120)
        let nameLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(24), y:  ip7(25), width: nameWidth, height: ip7(21)))
        if model.type == 0 {
            nameLabel.text = model.name+"赞赏了您的教学分享"

        } else {
            nameLabel.text = model.name+"赞赏了您的心得分享"
        }
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        nameLabel.font = fzFont_Medium(ip7(21))
        nameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(nameLabel)

        let monyWidth = KSCREEN_WIDTH - ip7(40) - ip7(120)
        let monyLabel : UILabel = UILabel(frame: CGRect(x: monyWidth, y:  ip7(25), width: ip7(120), height: ip7(21)))
        monyLabel.text = "\(model.price)元"
        monyLabel.isUserInteractionEnabled = true
        monyLabel.textColor = dark_3_COLOUR
        monyLabel.font = fzFont_Medium(ip7(21))
        monyLabel.adjustsFontSizeToFitWidth = true
        monyLabel.textAlignment = .right
        self.addSubview(monyLabel)


        let infoLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(24), y: nameLabel.frame.maxY + ip7(22), width: KSCREEN_WIDTH  -  iconImageView.frame.maxX - ip7(24), height: ip7(21)))
        infoLabel.text = model.catalog
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = blue_COLOUR
        infoLabel.textAlignment = .left
        infoLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(infoLabel)


        let timeLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(24), y: infoLabel.frame.maxY + ip7(15), width: ip7(200), height: ip7(18)))
        timeLabel.text = model.createTime
        timeLabel.font = fzFont_Thin(ip7(18))
        timeLabel.textColor  = dark_a_COLOUR
        timeLabel.textAlignment = .left
        self.addSubview(timeLabel)


        let lineView : UIView = UIView(frame: CGRect(x: ip7(27), y: viewH - 0.5, width: KSCREEN_WIDTH - ip7(27), height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        self.addSubview(lineView)
        
    }

}
