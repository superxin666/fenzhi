//
//  SearchTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2018/1/20.
//  Copyright © 2018年 Xunqiu. All rights reserved.
//

import UIKit
let SearchTableViewCellH = ip7(188/2)

typealias SearchTableViewCellBlock = (_ model : UserInfoModel)->()
class SearchTableViewCell: UITableViewCell {
     let dataVC = MineDataManger()
    var iconImageViewBlock : SearchTableViewCellBlock!//头像
    var dataModel : UserInfoModel = UserInfoModel()
    var guanzhuBtn :UIButton = UIButton()
    var baseVC : BaseViewController = BaseViewController()
    
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

        //关注按钮
        guanzhuBtn.frame = CGRect(x: KSCREEN_WIDTH - ip7(135), y: (SearchTableViewCellH - ip7(40))/2, width: ip7(125), height: ip7(40))
        guanzhuBtn.setTitle("关注", for: .normal)
        guanzhuBtn.setTitle("已关注", for: .selected)
        guanzhuBtn.backgroundColor = blue_COLOUR
        guanzhuBtn.setTitleColor( .white, for: .normal)
        guanzhuBtn.titleLabel?.font = fzFont_Medium(ip7(21))
        guanzhuBtn.kfb_makeRadius(radius: 4)
        guanzhuBtn.addTarget(self, action:#selector(SearchTableViewCell.gunzhuClick(sender:)), for: .touchUpInside)
        if (model.isFollow) == 1 {
            //已关注
            self.guanzhuBtn.isSelected = true
        } else {
            self.guanzhuBtn.isSelected = false
        }
        self.addSubview(guanzhuBtn)

        let lineView : UIView = UIView(frame: CGRect(x: ip7(27), y: viewH - 0.5, width: KSCREEN_WIDTH - ip7(27), height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        self.addSubview(lineView)

    }

    func iconImageClick()  {
        if let _ =  iconImageViewBlock {
            iconImageViewBlock(self.dataModel)
        }
    }
    //关注点击
    func gunzhuClick(sender:UIButton)  {
        weak var weakSelf = self
        if sender.isSelected {
            //已经关注了 现在取消关注
            dataVC.unfollow(userId: dataModel.id, completion: { (data) in
                let model : SmsModel = data as! SmsModel
                if model.errno == 0 {
                    weakSelf?.baseVC.SVshowSucess(infoStr: "取消关注成功")
                    weakSelf?.guanzhuBtn.isSelected = false
                } else {
                    weakSelf?.baseVC.SVshowErro(infoStr: model.errmsg)
                }
            }, failure: { (erro) in

            })


        } else {
            //没关注 现在关注
            dataVC.follow(userId: dataModel.id, completion: { (data) in
                let model : SmsModel = data as! SmsModel
                if model.errno == 0 {
                    weakSelf?.baseVC.SVshowSucess(infoStr: "关注成功")
                    weakSelf?.guanzhuBtn.isSelected = true
                } else {
                    weakSelf?.baseVC.SVshowErro(infoStr: model.errmsg)
                }
            }, failure: { (erro) in

            })
        }

    }

}
