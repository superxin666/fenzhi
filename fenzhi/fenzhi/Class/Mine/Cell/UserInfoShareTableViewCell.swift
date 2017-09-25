//
//  UserInfoShareTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/25.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class UserInfoShareTableViewCell: UITableViewCell {
    
    
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
    
//    var delViewBlock : RecordTableViewCellBlock!
    
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
        timeLabel.frame = CGRect(x: viewW - ip7(31) - ip7(300), y: txtLabel.frame.origin.y + ip7(17), width: ip7(300), height: ip7(20))
        timeLabel.text = "分享时间：" + String.getDate_userinfo_cell(dateStr: model.createTime)
        timeLabel.font = fzFont_Thin(ip7(15))
        timeLabel.textColor  = dark_6_COLOUR
        timeLabel.textAlignment = .right
        backView.addSubview(timeLabel)
        
        lastFream = timeLabel.frame
        
        //102 + 文字 +28 + CGFloat(i) * (ip7(65) + ip7(15)）//文件 +
        if model.coursewares.count > 0 {
            //文件
            let imageX = ip7(30)
            let imageY = ip7(28) + lastFream.maxY
            
            let imageWidth = viewW - ip7(60)
            let imageHeight = ip7(65)
            
            
            for i in 0..<model.coursewares.count {
                let model = model.coursewares[i]
                let view = UIView(frame: CGRect(x: imageX, y: imageY + CGFloat(i) * (imageHeight + ip7(15)), width: imageWidth, height: imageHeight))
                view.tag = i
                view.backgroundColor = backView_COLOUR
                view.isUserInteractionEnabled = true
                lastFream = view.frame
                
                let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TeachDetailHeadView.ppt_click(tap:)))
                view.addGestureRecognizer(iconImageViewTap)
                
                
                //图片
                let imageView = UIImageView(image: #imageLiteral(resourceName: "pdf"))
                imageView.frame = CGRect(x: 0, y: 0, width: ip7(65), height: ip7(65))
                view.addSubview(imageView)
                
                //描述
                let label : UILabel = UILabel(frame: CGRect(x: imageView.frame.maxX + ip7(10), y: (imageHeight - ip7(21))/2, width: imageWidth - imageView.frame.maxX - ip7(10), height: ip7(21)))
                label.text = model.name
                label.font = fzFont_Thin(ip7(21))
                label.textColor  = dark_3_COLOUR
                label.textAlignment = .left
                view.addSubview(label)
                backView.addSubview(view)
            }
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
        
        //三个按钮
        let btnW = (viewW - appadWidth * 2)/3
        let nameArray : Array = ["\(model.likeNum!)点赞","\(model.commentNum!)评论","\(model.zanNum!)赞赏"]
        let imageArr : Array = [#imageLiteral(resourceName: "icon_dz1"),#imageLiteral(resourceName: "icon_pl1"),#imageLiteral(resourceName: "icon_zs")]
        let image_selectedArr : Array = [#imageLiteral(resourceName: "icon_dz1_s"),#imageLiteral(resourceName: "icon_pl1_s"),#imageLiteral(resourceName: "icon_zs_s")]
        
        for i in 0...2 {
            let btn : UIButton = UIButton(type: .custom)
            btn.tag = i
            if i == 0 {
                dianzanBtn = btn
                //点赞
                if model.isLike == 1 {
                    btn.isSelected = true
                } else {
                    btn.isSelected = false
                }
            } else if i == 1 {
                
            } else {
                //赞赏
                fenxinagBtn = btn
                
            }
            btn.frame = CGRect(x: appadWidth + CGFloat(i) * btnW , y: lastFream.maxY + ip7(45), width: btnW, height: ip7(60))
            btn.titleLabel?.font = fzFont_Thin(18)
            btn.tag = i
            btn.addTarget(self, action: #selector(btn_click(sender:)), for: .touchUpInside)
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
    
    func btn_click(sender : UIButton) {
        if sender.tag == 0 {
            if dataModel.isLike == 1 {
                //已经点过赞
                
            } else {
                //没有点过赞
                weak var weakSelf = self
                comVC.like(type: 0, objectId: self.dataModel.id!, completion: { (data) in
                    let model : LikeModel = data as! LikeModel
                    if model.errno == 0 {
                        weakSelf?.baseVC.SVshowSucess(infoStr: "点赞成功")
                        weakSelf?.dianzanBtn.isSelected = true
                        weakSelf?.dataModel.isLike = 1
                        let num = (weakSelf?.dataModel.likeNum)! + 1
                        weakSelf?.dataModel.likeNum = num
                        weakSelf?.dianzanBtn.setTitle("\(num)点赞", for: .selected)
                    } else {
                        weakSelf?.baseVC.SVshowErro(infoStr: model.errmsg)
                    }
                    
                }) { (erro) in
                    
                }
                
                
            }
            
        } else if sender.tag == 1 {
            
        } else {
            //赞赏
            
        }
        
    }
    
//    func del_click() {
//        KFBLog(message: "删除")
//        if let _ =  delViewBlock {
//            delViewBlock(self.dataModel)
//        }
//
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
