//
//  SearchTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2018/1/20.
//  Copyright © 2018年 Xunqiu. All rights reserved.
//

import UIKit
typealias SearchTableViewCellBlock = (_ model : UserInfoModel)->()
class SearchTableViewCell: UITableViewCell {
    var iconImageViewBlock : SearchTableViewCellBlock!//头像
    var dataModel : UserInfoModel = UserInfoModel()


    func setUpUIWithModel_cellType(model :UserInfoModel) {
        dataModel = model
        let viewH = ip7(95)
//        let userModel : GetmessagelistLikeModel_data_messageList_userInfo = model.userInfo
//        let conentModel : GetmessagelistLikeModel_data_messageList_fenxInfo = model.fenxInfo
        //头像
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(27), y:  (viewH - ip7(50))/2, width: ip7(50), height: ip7(50) ))
        iconImageView.kf.setImage(with: URL(string: model.avatar))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.kfb_makeRound()
        self.addSubview(iconImageView)
        let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchTableViewCell.iconImageClick))
        iconImageView.addGestureRecognizer(iconImageViewTap)

        let nameWidth = KSCREEN_WIDTH - ip7(19) - iconImageView.frame.maxX - ip7(31) - ip7(120)
        let nameLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y:  ip7(25), width: nameWidth, height: ip7(24)))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = model.name
        self.addSubview(nameLabel)
        let nameLabelTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DianzanTableViewCell.iconImageClick))
        nameLabel.addGestureRecognizer(nameLabelTap)


        let infoLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y: nameLabel.frame.maxY + ip7(10), width: KSCREEN_WIDTH  - iconImageView.frame.maxX - ip7(19), height: ip7(21)))
        if model.type == 0 {
            infoLabel.text = model.cityName + " \(model.gradeName)"+model.subjectName+"老师"
        } else {
            infoLabel.text = ""
        }
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

}
