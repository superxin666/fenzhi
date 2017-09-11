//
//  HeartTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/8.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//  心得分享 cell

import UIKit
//typealias InjuryHeadViewBlock = (_ model : commonInjuriesModel) ->()
typealias HeartCellViewBlock = ()->()
enum CellType {
    case home
    case record
}
class HeartTableViewCell: UITableViewCell {
    var IconImageViewBlock : HeartCellViewBlock!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpUIWithModel_cellType(celltype : CellType) {
        
        let viewW = KSCREEN_WIDTH - ip7(20)
        let viewH = ip7(700)
        
        
        let backView : UIView = UIView(frame: CGRect(x: ip7(10), y: 0, width: viewW, height: viewH - ip7(10)))
        backView.backgroundColor = .white
        backView.isUserInteractionEnabled = true
        self.addSubview(backView)
        //头像
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(25), y: ip7(25), width: ip7(60), height: ip7(60)))
        iconImageView.image = #imageLiteral(resourceName: "touxiang")
        iconImageView.isUserInteractionEnabled = true
        backView.addSubview(iconImageView)

        let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HeartTableViewCell.iconImageClick))
        iconImageView.addGestureRecognizer(iconImageViewTap)
        //时间
        if celltype == .home {
            //首页
            let timeLabel : UILabel = UILabel(frame: CGRect(x: viewW - ip7(31) - ip7(90), y: ip7(25), width: ip7(90), height: ip7(20)))
            timeLabel.text = "24:00"
            timeLabel.font = fzFont_Thin(ip7(15))
            timeLabel.textColor  = FZColor(red: 197, green: 198, blue: 203, alpha: 1.0)
            timeLabel.textAlignment = .right
            timeLabel.adjustsFontSizeToFitWidth = true
            backView.addSubview(timeLabel)
        } else {
            //记录 更多
            let moreImageView:UIImageView = UIImageView(frame: CGRect(x: viewW - ip7(5) - ip7(37), y: ip7(25), width: ip7(5), height: ip7(20)))
            moreImageView.image = #imageLiteral(resourceName: "button_more")
            moreImageView.isUserInteractionEnabled = true
            backView.addSubview(moreImageView)
        
        }

        
        //105105105
        //名字
        let nameWidth = viewW - ip7(19) - iconImageView.frame.maxX - ip7(31) - ip7(90)
        let nameLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y:  ip7(25), width: nameWidth, height: ip7(24)))
        nameLabel.text = "尼古拉斯赵四"
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = FZColorFromRGB(rgbValue: 0x333333)
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(nameLabel)

        let nameLabelTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HeartTableViewCell.iconImageClick))
        nameLabel.addGestureRecognizer(nameLabelTap)

        //用户信息
        let infoLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y: nameLabel.frame.maxY + ip7(14), width: viewW - ip7(19) - iconImageView.frame.maxX, height: ip7(21)))
        infoLabel.text = "北京 三年级语文老师"
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        infoLabel.textAlignment = .left
        infoLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(infoLabel)
        if celltype == .record {
            infoLabel.frame.size.width = viewW - ip7(19) - iconImageView.frame.maxX - ip7(150)
            //信息旁边是 时间
            let timeLabel : UILabel = UILabel(frame: CGRect(x: viewW - ip7(31) - ip7(150), y: infoLabel.frame.origin.y, width: ip7(150), height: ip7(20)))
            timeLabel.text = "01.12 24:00"
            timeLabel.font = fzFont_Thin(ip7(15))
            timeLabel.textColor  = FZColor(red: 197, green: 198, blue: 203, alpha: 1.0)
            timeLabel.textAlignment = .right
            timeLabel.adjustsFontSizeToFitWidth = true
            backView.addSubview(timeLabel)
        }


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
        let imageX = ip7(30)
        let imageY = ip7(32) + txtLabel.frame.maxY
        let appad = ip7(20)
        let imageWidth = (viewW - ip7(60) - ip7(20))/2
        let imageHeight = imageWidth * 355/428
        var lastImageFream = txtLabel.frame;

        for i in 0...3 {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "icon_tu_01"))
            imageView.tag = i
            let Y = CGFloat((i/2)) * (imageHeight + ip7(20))
            let X = ((appad + imageWidth) * CGFloat(i%2))
            imageView.frame =  CGRect(x: imageX + X, y: imageY + Y, width: imageWidth, height: imageHeight)
            lastImageFream = imageView.frame;
            backView.addSubview(imageView)
        }

        //课时定位
        let dingweiImageView : UIImageView = UIImageView(image: #imageLiteral(resourceName: "icon_dingwei"))
        dingweiImageView.frame = CGRect(x: imageX, y: lastImageFream.maxY + ip7(35), width: ip7(20), height: ip7(20))
        backView.addSubview(dingweiImageView)

        let lessonLabel : UILabel = UILabel(frame: CGRect(x: dingweiImageView.frame.maxX + ip7(10), y: lastImageFream.maxY + ip7(35), width: viewW - dingweiImageView.frame.maxX - ip7(10) , height: ip7(21)))
        lessonLabel.text = "第二单元 第三课时 《鹅鹅鹅》"
        lessonLabel.font = fzFont_Thin(ip7(21))
        lessonLabel.textColor  = FZColor(red: 88, green: 165, blue: 255, alpha: 1.0)
        lessonLabel.textAlignment = .left
        lessonLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(lessonLabel)

        //三个按钮
        let lineView : UIView = UIView(frame: CGRect(x: imageX, y: lessonLabel.frame.maxY + ip7(27), width: viewW - imageX * 2, height: 0.5))
        lineView.backgroundColor = FZColor(red: 102, green: 102, blue: 102, alpha: 1.0)
        backView.addSubview(lineView)

        let btnW = (viewW - imageX * 2)/3
        let nameArray : Array = ["123点赞","68评论","12赞赏"]
        let imageArr : Array = [#imageLiteral(resourceName: "icon_dz1"),#imageLiteral(resourceName: "icon_pl1"),#imageLiteral(resourceName: "icon_zs")]

        for i in 0...2 {
            let btn : UIButton = UIButton(type: .custom)
            btn.tag = i
            btn.frame = CGRect(x: imageX + CGFloat(i) * btnW , y: lineView.frame.maxY, width: btnW, height: ip7(60))
            btn.titleLabel?.font = fzFont_Thin(18)
            btn.setTitleColor(FZColor(red: 102, green: 102, blue: 102, alpha: 1.0), for: .normal)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ip7(20))
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.setTitle(nameArray[i], for: .normal)
            btn.setImage(imageArr[i], for: .normal)
            backView.addSubview(btn)
        }


    }

    func iconImageClick()  {
        if let _ =  IconImageViewBlock {
            IconImageViewBlock()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
