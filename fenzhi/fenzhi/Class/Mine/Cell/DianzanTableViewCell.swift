//
//  DianzanTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/29.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
typealias DianzanTableViewBlock = (_ model : GetmessagelistLikeModel_data_messageList)->()
class DianzanTableViewCell: UITableViewCell {

     var iconImageViewBlock : DianzanTableViewBlock!//头像
     var dataModel : GetmessagelistLikeModel_data_messageList = GetmessagelistLikeModel_data_messageList()

    func setUpUIWithModel_cellType(model :GetmessagelistLikeModel_data_messageList) {
        dataModel = model
        let viewH = ip7(95)
        let userModel : GetmessagelistLikeModel_data_messageList_userInfo = model.userInfo
        let conentModel : GetmessagelistLikeModel_data_messageList_fenxInfo = model.fenxInfo
        //头像
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(27), y:  (viewH - ip7(50))/2, width: ip7(50), height: ip7(50) ))
        iconImageView.kf.setImage(with: URL(string: userModel.avatar))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.kfb_makeRound()
        self.addSubview(iconImageView)
        let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DianzanTableViewCell.iconImageClick))
        iconImageView.addGestureRecognizer(iconImageViewTap)

        let redImageView = UIView(frame: CGRect(x: ip7(27), y:  (viewH - ip7(50))/2, width: ip7(10), height: ip7(10)))
        redImageView.backgroundColor = .red
        redImageView.kfb_makeRound()
        self.addSubview(redImageView)
        if model.status == 1 {
            //
            redImageView.isHidden = true
        } else {
            //
            redImageView.isHidden = false
        }
        
        
        let nameWidth = KSCREEN_WIDTH - ip7(19) - iconImageView.frame.maxX - ip7(31) - ip7(120)
        let nameLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y:  ip7(25), width: nameWidth, height: ip7(24)))
        if conentModel.type == 0 {
            nameLabel.text = userModel.name + "   点赞了您的资料分享"
        } else {
            nameLabel.text = userModel.name + "   点赞了您的心得分享"
        }

        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(nameLabel)
        let nameLabelTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DianzanTableViewCell.iconImageClick))
        nameLabel.addGestureRecognizer(nameLabelTap)

        let timeLabel : UILabel = UILabel(frame: CGRect(x: KSCREEN_WIDTH - ip7(31) - ip7(120), y: ip7(25), width: ip7(120), height: ip7(20)))
        timeLabel.text = String.getDate_detail(dateStr: model.createTime)
        timeLabel.font = fzFont_Thin(ip7(15))
        timeLabel.textColor  = dark_a_COLOUR
        timeLabel.textAlignment = .right
        self.addSubview(timeLabel)


        let infoLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y: nameLabel.frame.maxY + ip7(10), width: KSCREEN_WIDTH  - iconImageView.frame.maxX - ip7(19), height: ip7(21)))
        infoLabel.text = conentModel.content
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = dark_6_COLOUR
        infoLabel.textAlignment = .left
        infoLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(infoLabel)

        let lineView : UIView = UIView(frame: CGRect(x: ip7(27), y: viewH - 0.5, width: KSCREEN_WIDTH - ip7(27), height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        self.addSubview(lineView)

    }

    func iconImageClick()  {
        if let _ =  iconImageViewBlock {
            iconImageViewBlock(self.dataModel)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
