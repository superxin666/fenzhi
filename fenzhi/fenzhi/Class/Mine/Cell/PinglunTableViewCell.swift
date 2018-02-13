//
//  PinglunTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/11.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
typealias PinglunTableViewBlock = (_ model : GetcommentlistModel_data_list_commentList)->()


class PinglunTableViewCell: UITableViewCell {
    
    var iconImageBlock : PinglunTableViewBlock!//头像点击
    var returnClickBlock : PinglunTableViewBlock!//回复评论
    
    var dataModel : GetcommentlistModel_data_list_commentList = GetcommentlistModel_data_list_commentList()
    let icoinImageView : UIImageView = UIImageView()//头像
    let nameLabel : UILabel  = UILabel()//名字
    let returnBtn : UIButton = UIButton()//回复
    
    let returnContent : UILabel = UILabel()//回复内容
    let content : UILabel = UILabel()//评论内容
    let dingweiLabel :UILabel = UILabel()//课时定位
    let timeLabel : UILabel = UILabel()//时间
    

//
    
    func setUpUI(model : GetcommentlistModel_data_list_commentList)  {
        dataModel = model
        let viewW = KSCREEN_WIDTH
        
        //头像
        icoinImageView.frame = CGRect(x: ip7(25), y: ip7(23), width: ip7(60), height: ip7(60))
        icoinImageView.kfb_makeRound()
        icoinImageView.kf.setImage(with: URL(string: model.userInfo.avatar))
        icoinImageView.isUserInteractionEnabled = true
        self.addSubview(icoinImageView)
        
        let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PinglunTableViewCell.image_Click))
        icoinImageView.addGestureRecognizer(iconImageViewTap)
        
        let redImageView = UIView(frame: CGRect(x: ip7(25), y: ip7(23), width: ip7(10), height: ip7(10)))
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
        //名字
        let nameWidth = viewW  - icoinImageView.frame.maxX - ip7(25) - ip7(56) - ip7(27)
        nameLabel.frame = CGRect(x: icoinImageView.frame.maxX + ip7(25), y:  ip7(23), width: nameWidth, height: ip7(24))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        if model.fenxInfo.type == 0 {
            nameLabel.text = model.userInfo.name + "   评论了您的教学分享"
        } else {
            nameLabel.text = model.userInfo.name + "   评论了您的心得分享"
        }
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(nameLabel)
        
        let nameTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PinglunTableViewCell.image_Click))
        nameLabel.addGestureRecognizer(nameTap)
        
        
        returnBtn.frame = CGRect(x: viewW - ip7(56) - ip7(27), y: ip7(23), width: ip7(56), height: ip7(31))
        returnBtn.setTitle("回复", for: .normal)
        returnBtn.setTitleColor(.white, for: .normal)
        returnBtn.titleLabel?.font = fzFont_Thin(ip7(18))
        returnBtn.backgroundColor = FZColorFromRGB(rgbValue: 0x8cd851)
        returnBtn.kfb_makeRadius(radius: 4)
        returnBtn.addTarget(self, action:#selector(PinglunTableViewCell.return_click), for: .touchUpInside)
        returnBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ip7(20))
        self.addSubview(returnBtn)
        
        
        //评论
        let returnContentStr = model.commentInfo.content
        let labelW = viewW  - icoinImageView.frame.maxX - ip7(25) - ip7(27)
        let returnContentH :CGFloat = returnContentStr.getLabHeight(font: fzFont_Thin(ip7(18)), LabelWidth: labelW)
        
        returnContent.frame = CGRect(x: icoinImageView.frame.maxX + ip7(25), y:  icoinImageView.frame.maxY + ip7(8), width: labelW, height: returnContentH)
        returnContent.text = returnContentStr
        returnContent.isUserInteractionEnabled = true
        returnContent.textColor = dark_6_COLOUR
        returnContent.font = fzFont_Thin(ip7(18))
        self.addSubview(returnContent)
        
        var lastFream = returnContent.frame
        
        //如果有被评论内容 则是回复我的评论 没有则是评论的分享
        if model.toCommentInfo.content.characters.count > 0 {
            content.frame = CGRect(x: icoinImageView.frame.maxX + ip7(25), y:  returnContent.frame.maxY + ip7(15), width: labelW, height: ip7(53))
            content.isUserInteractionEnabled = true
            content.text =  model.toCommentInfo.content
            content.backgroundColor = dark_f7f7f7_COLOUR
            content.textColor = dark_6_COLOUR
            content.font = fzFont_Thin(ip7(18))
            content.textAlignment = .left
            content.adjustsFontSizeToFitWidth = true
            self.addSubview(content)
            
            lastFream = content.frame
        }

        
        //定位 有定位显示定位 没有定位显示 内容
        if model.fenxInfo.catalog.characters.count > 0 {
            dingweiLabel.frame = CGRect(x: icoinImageView.frame.maxX + ip7(25), y:  lastFream.maxY + ip7(25), width: labelW, height: ip7(21))
            dingweiLabel.isUserInteractionEnabled = true
            dingweiLabel.textColor = blue_COLOUR
            dingweiLabel.font = fzFont_Thin(ip7(21))
            dingweiLabel.adjustsFontSizeToFitWidth = true
            dingweiLabel.text = model.fenxInfo.catalog
            self.addSubview(dingweiLabel)
            lastFream = dingweiLabel.frame
        }
        
        //时间
        timeLabel.frame = CGRect(x: icoinImageView.frame.maxX + ip7(25), y:  lastFream.maxY + ip7(15), width: labelW, height: ip7(18))
        timeLabel.isUserInteractionEnabled = true
        timeLabel.textColor = dark_a_COLOUR
        timeLabel.font = fzFont_Thin(ip7(18))
        timeLabel.text = String.getDate_detail(dateStr: model.createTime)
        timeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(timeLabel)
        
        
        let lineView : UIView = UIView(frame: CGRect(x: ip7(25), y:model.cellHeight - 0.5 , width: viewW - ip7(25), height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        self.addSubview(lineView)
        
    }
    
    func image_Click() {
        if let _ =  iconImageBlock {
            iconImageBlock(self.dataModel)
        }
    }
    
    func return_click() {
        if let _ =  returnClickBlock {
            returnClickBlock(self.dataModel)
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
