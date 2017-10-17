//
//  PinglunTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/11.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class PinglunTableViewCell: UITableViewCell {
    var dataModel : GetcommentlistModel_data_list_commentList = GetcommentlistModel_data_list_commentList()
    let icoinImageView : UIImageView = UIImageView()//头像
    let nameLabel : UILabel  = UILabel()//名字
    let returnBtn : UIButton = UIButton()//回复
    
    let returnContent : UILabel = UILabel()//回复内容
    let content : UILabel = UILabel()//评论内容
    let dingweiLabel :UILabel = UILabel()//课时定位
    let timeLabel : UILabel = UILabel()//时间
    
    func setUpUI(model : GetcommentlistModel_data_list_commentList)  {
        dataModel = model
        let viewH  = ip7(275)
        let viewW = KSCREEN_WIDTH
        
        //头像
        icoinImageView.frame = CGRect(x: ip7(25), y: ip7(23), width: ip7(60), height: ip7(60))
        icoinImageView.kfb_makeRound()
        icoinImageView.isUserInteractionEnabled = true
        self.addSubview(icoinImageView)
        
//        let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentTableViewCell.image_Click))
//        iconImageView.addGestureRecognizer(iconImageViewTap)
        
        //名字
        let nameWidth = viewW  - icoinImageView.frame.maxX - ip7(25) - ip7(56) - ip7(27)
        nameLabel.frame = CGRect(x: icoinImageView.frame.maxX + ip7(25), y:  ip7(23), width: nameWidth, height: ip7(24))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(nameLabel)
        
//        let nameTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentTableViewCell.image_Click))
//        nameLabel.addGestureRecognizer(nameTap)
        
        
        returnBtn.frame = CGRect(x: viewW - ip7(56) - ip7(27), y: ip7(23), width: ip7(56), height: ip7(31))
        returnBtn.setTitle("回复", for: .normal)
        returnBtn.setTitleColor(dark_6_COLOUR, for: .normal)
        returnBtn.titleLabel?.font = fzFont_Thin(ip7(18))
        returnBtn.backgroundColor = FZColorFromRGB(rgbValue: 0x8cd851)
        returnBtn.kfb_makeRadius(radius: 8)
        returnBtn.addTarget(self, action:#selector(HomeViewController.teachBtnClik), for: .touchUpInside)
        returnBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ip7(20))
        self.addSubview(returnBtn)
        
       let labelW = viewW  - icoinImageView.frame.maxX - ip7(25) - ip7(27)
        returnContent.frame = CGRect(x: icoinImageView.frame.maxX + ip7(25), y:  icoinImageView.frame.maxY + ip7(8), width: labelW, height: ip7(18))
        returnContent.isUserInteractionEnabled = true
        returnContent.textColor = dark_6_COLOUR
        returnContent.font = fzFont_Thin(ip7(18))
        returnContent.adjustsFontSizeToFitWidth = true
        self.addSubview(returnContent)
        
        content.frame = CGRect(x: icoinImageView.frame.maxX + ip7(25), y:  returnContent.frame.maxY + ip7(15), width: labelW, height: ip7(53))
        content.isUserInteractionEnabled = true
        content.backgroundColor = dark_3_COLOUR
        content.textColor = dark_6_COLOUR
        content.font = fzFont_Thin(ip7(18))
        content.textAlignment = .left
        content.adjustsFontSizeToFitWidth = true
        self.addSubview(content)
        
        dingweiLabel.frame = CGRect(x: icoinImageView.frame.maxX + ip7(25), y:  content.frame.maxY + ip7(25), width: labelW, height: ip7(21))
        dingweiLabel.isUserInteractionEnabled = true
        dingweiLabel.textColor = blue_COLOUR
        dingweiLabel.font = fzFont_Thin(ip7(21))
        dingweiLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(dingweiLabel)
        
        
        timeLabel.frame = CGRect(x: icoinImageView.frame.maxX + ip7(25), y:  dingweiLabel.frame.maxY + ip7(15), width: labelW, height: ip7(18))
        timeLabel.isUserInteractionEnabled = true
        timeLabel.textColor = dark_a_COLOUR
        timeLabel.font = fzFont_Thin(ip7(18))
        timeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(timeLabel)
        
        
        let lineView : UIView = UIView(frame: CGRect(x: ip7(25), y:viewH - 0.5 , width: viewW - ip7(25), height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        self.addSubview(lineView)
        
        
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
