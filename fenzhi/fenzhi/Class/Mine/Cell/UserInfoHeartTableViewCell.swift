//
//  UserInfoHeartTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/25.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class UserInfoHeartTableViewCell: UITableViewCell {
    
    var dataModel : GetmyfeedlistModel_data_fenxList = GetmyfeedlistModel_data_fenxList()
    var dataVC : HomeDataMangerController = HomeDataMangerController()
    var comVC : CommonDataMangerViewController = CommonDataMangerViewController()
    var dianzanBtn : UIButton = UIButton()
    var shoucangBtn : UIButton = UIButton()
    var fenxinagBtn : UIButton = UIButton()
    var baseVC : BaseViewController = BaseViewController()
    var docBlock : TeachDetailHeadViewBlock!
    
    let iconImageView:UIImageView = UIImageView()
    let moreImageView:UIImageView = UIImageView()
    let timeLabel : UILabel = UILabel()
    let nameLabel : UILabel = UILabel()
    let infoLabel : UILabel = UILabel()
    let txtLabel : UILabel = UILabel()
    
    func setUpUIWithModelAndType(model : GetmyfeedlistModel_data_fenxList) {
        self.dataModel = model
        let viewW = KSCREEN_WIDTH
        let viewH = model.cellHeight
        
        let backView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: viewW, height: viewH - ip7(10)))
        backView.backgroundColor = .white
        backView.isUserInteractionEnabled = true
        self.addSubview(backView)
        //85
        //102 + 文字
        //文字
        let str = model.content
        let txtW = viewW - ip7(50)
        var txtH :CGFloat = str.getLabHeight(font: fzFont_Thin(ip7(21)), LabelWidth: txtW)
        if txtH > ip7(21) * 4 {
            txtH = ip7(21) * 4
        }
        txtLabel.frame = CGRect(x: ip7(25), y: infoLabel.frame.maxY + ip7(17), width: txtW, height: txtH)
        txtLabel.text = str
        txtLabel.font = fzFont_Thin(ip7(21))
        txtLabel.textColor  = dark_3_COLOUR
        txtLabel.textAlignment = .left
        txtLabel.numberOfLines = 0
        backView.addSubview(txtLabel)
        
        var lastFream = txtLabel.frame;
        let appadWidth = ip7(30)
        
        
        //文字底部 时间
        timeLabel.frame = CGRect(x: viewW - ip7(31) - ip7(300), y: lastFream.maxY + ip7(17), width: ip7(300), height: ip7(20))
        timeLabel.text = "分享时间：" + String.getDate_detail(dateStr: model.createTime)
        timeLabel.font = fzFont_Thin(ip7(15))
        timeLabel.textColor  = dark_6_COLOUR
        timeLabel.textAlignment = .right
        backView.addSubview(timeLabel)
        
        lastFream = timeLabel.frame;
        
        //102 + 文字 +28 + CGFloat(i) * (ip7(65) + ip7(15)）//文件 +
        //图片
        let imageX = ip7(30)
        let imageY = ip7(32) + lastFream.maxY
        let appad = ip7(20)
        let imageWidth = (viewW - ip7(60) - ip7(20))/2
        let imageHeight = imageWidth * 355/428
        
        for i in 0..<model.images.count  {
            let imageStr :String = model.images[i]
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: imageStr))
            imageView.tag = i
            let Y = CGFloat((i/2)) * (imageHeight + ip7(20))
            let X = ((appad + imageWidth) * CGFloat(i%2))
            imageView.frame =  CGRect(x: imageX + X, y: imageY + Y, width: imageWidth, height: imageHeight)
            lastFream = imageView.frame;
            backView.addSubview(imageView)
        }
        //102 + 文字 +28 + CGFloat(i) * (ip7(65) + ip7(15)）//文件 + // ip(35)+ip(21)//课时定位 +
        
        if model.catalog.characters.count > 0 {
            //课时定位
            let dingweiImageView : UIImageView = UIImageView(image: #imageLiteral(resourceName: "icon_dingwei"))
            dingweiImageView.frame = CGRect(x: appadWidth, y: lastFream.maxY + ip7(35), width: ip7(20), height: ip7(20))
            backView.addSubview(dingweiImageView)
            
            let lessonLabel : UILabel = UILabel(frame: CGRect(x: dingweiImageView.frame.maxX + ip7(10), y: lastFream.maxY + ip7(35), width: viewW - dingweiImageView.frame.maxX - ip7(10) , height: ip7(21)))
            lessonLabel.text = model.catalog
            lessonLabel.font = fzFont_Thin(ip7(21))
            lessonLabel.textColor  = FZColor(red: 88, green: 165, blue: 255, alpha: 1.0)
            lessonLabel.textAlignment = .left
            lessonLabel.adjustsFontSizeToFitWidth = true
            backView.addSubview(lessonLabel)
            
            lastFream = lessonLabel.frame
            
        }
        
        //横线
        let lineView : UIView = UIView(frame: CGRect(x: appadWidth, y: lastFream.maxY + ip7(27), width: viewW - appadWidth * 2, height: 0.5))
        lineView.backgroundColor = FZColor(red: 102, green: 102, blue: 102, alpha: 1.0)
        backView.addSubview(lineView)
        let payHide : String =  UserDefaults.standard.object(forKey: "payHide") as! String
        var shoNum :Int = 3
        if payHide == "1"{
            KFBLog(message: "隐藏")
            shoNum = 2
        } else {
        }

        //三个按钮
        let btnW = (viewW - appadWidth * 2)/CGFloat(shoNum)
        let nameArray : Array = ["\(model.likeNum!)点赞","\(model.commentNum!)评论","\(model.zanNum!)赞赏"]
        let imageArr : Array = [#imageLiteral(resourceName: "icon_dz1"),#imageLiteral(resourceName: "icon_pl1"),#imageLiteral(resourceName: "icon_zs")]
        let image_selectedArr : Array = [#imageLiteral(resourceName: "icon_dz1_s"),#imageLiteral(resourceName: "shape"),#imageLiteral(resourceName: "fx3_s")]
        let count = shoNum - 1
        for i in 0...count - 1 {
            let btn : UIButton = UIButton(type: .custom)
            btn.tag = i
//            if i == 0 {
//                dianzanBtn = btn
//                //点赞
//                if model.isLike == 1 {
//                    btn.isSelected = true
//                } else {
//                    btn.isSelected = false
//                }
//            } else if i == 1 {
//                //评论
//                shoucangBtn = btn
//
//
//            } else {
//                //赞赏
//                fenxinagBtn = btn
//
//            }
            btn.frame = CGRect(x: appadWidth + CGFloat(i) * btnW , y: lastFream.maxY + ip7(45), width: btnW, height: ip7(60))
            btn.titleLabel?.font = fzFont_Thin(18)
            btn.tag = i
            //            btn.addTarget(self, action: #selector(btn_click(sender:)), for: .touchUpInside)
            btn.setTitleColor(dark_6_COLOUR, for: .normal)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ip7(20))
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.setTitle(nameArray[i], for: .normal)
            btn.setTitle(nameArray[i], for: .selected)
            btn.setImage(imageArr[i], for: .normal)
            btn.setImage(image_selectedArr[i], for: .selected)
            backView.addSubview(btn)
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
