//
//  HeartTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/8.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//  心得分享 cell

import UIKit
//typealias InjuryHeadViewBlock = (_ model : commonInjuriesModel) ->()
typealias HeartCellViewBlock = (_ model : GetmyfeedlistModel_data_fenxList)->()
enum CellType {
    case home
    case record
}
class HeartTableViewCell: UITableViewCell {
    var IconImageViewBlock : HeartCellViewBlock!//头像 名字点击
    var detailBlock : HeartCellViewBlock!//评论点击
    var zanshangBlock : HeartCellViewBlock!//赞赏点击
    
    var dataModel : GetmyfeedlistModel_data_fenxList = GetmyfeedlistModel_data_fenxList()
    var dataVC : HomeDataMangerController = HomeDataMangerController()
    var comVC : CommonDataMangerViewController = CommonDataMangerViewController()
    var dianzanBtn : UIButton = UIButton()
    var shoucangBtn : UIButton = UIButton()
    var fenxinagBtn : UIButton = UIButton()
    var baseVC : BaseViewController = BaseViewController()
   
    
    let iconImageView:UIImageView = UIImageView()
    let moreImageView:UIImageView = UIImageView()
    let timeLabel : UILabel = UILabel()
    let nameLabel : UILabel = UILabel()
    let infoLabel : UILabel = UILabel()
    let txtLabel : UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpUIWithModel_cellType(model : GetmyfeedlistModel_data_fenxList) {
        
        self.dataModel = model
        let viewW = KSCREEN_WIDTH
        let viewH = model.cellHeight
        
        let backView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: viewW, height: viewH - ip7(10)))
        backView.backgroundColor = .white
        backView.isUserInteractionEnabled = true
        self.addSubview(backView)
        //头像
        iconImageView.frame = CGRect(x: ip7(25), y: ip7(25), width: ip7(60), height: ip7(60))
//        iconImageView.kf.setImage(with: URL(string: model.userInfo.avatar))
        iconImageView.setImage_kf(imageName:  model.userInfo.avatar, placeholderImage: #imageLiteral(resourceName: "tx_m"))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.kfb_makeRound()
        backView.addSubview(iconImageView)
        
        let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HeartTableViewCell.iconImageClick))
        iconImageView.addGestureRecognizer(iconImageViewTap)

        //首页
        timeLabel.frame = CGRect(x: viewW - ip7(31) - ip7(90), y: ip7(25), width: ip7(90), height: ip7(20))
        timeLabel.text = String.getDate_detail(dateStr: model.createTime)
        timeLabel.font = fzFont_Thin(ip7(15))
        timeLabel.textColor  = dark_6_COLOUR
        timeLabel.textAlignment = .right
        backView.addSubview(timeLabel)


        
        //105105105
        //名字
        let nameWidth = ip7(200)
        nameLabel.frame = CGRect(x: iconImageView.frame.maxX + ip7(19), y:  ip7(25), width: nameWidth, height: ip7(24))
        nameLabel.text = model.userInfo.name
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(nameLabel)
        
        let nameLabelTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HeartTableViewCell.iconImageClick))
        nameLabel.addGestureRecognizer(nameLabelTap)
        
        //用户信息
        infoLabel.frame = CGRect(x: iconImageView.frame.maxX + ip7(19), y: nameLabel.frame.maxY + ip7(14), width: viewW - ip7(19) - iconImageView.frame.maxX, height: ip7(21))
        infoLabel.text = model.userInfo.cityName + " " + model.userInfo.gradeName+model.userInfo.subjectName+"老师"
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = dark_6_COLOUR
        infoLabel.textAlignment = .left
        infoLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(infoLabel)
        

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

        //102 + 文字 +28 + CGFloat(i) * (ip7(65) + ip7(15)）//文件 +
        //图片
        let imageX = ip7(30)
        let imageY = ip7(32) + txtLabel.frame.maxY
        let appad = ip7(20)
        let imageWidth = (viewW - ip7(60) - ip7(20))/2
        let imageHeight = imageWidth * 355/428
        
        for i in 0..<model.images.count  {
            let imageStr :String = model.images[i]
            let imageView = UIImageView()
//            imageView.kf.setImage(with: URL(string: imageStr))
            imageView.setImage_kf(imageName: imageStr, placeholderImage: #imageLiteral(resourceName: "loding"))
            imageView.tag = i
            let Y = CGFloat((i/2)) * (imageHeight + ip7(20))
            let X = ((appad + imageWidth) * CGFloat(i%2))
            imageView.frame =  CGRect(x: imageX + X, y: imageY + Y, width: imageWidth, height: imageHeight)
            lastFream = imageView.frame;
            backView.addSubview(imageView)
        }
        //102 + 文字 +28 + CGFloat(i) * (ip7(65) + ip7(15)）//文件 + // ip(35)+ip(21)//课时定位 +
        
        if model.catalog.count > 0 {
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
        lineView.backgroundColor = lineView_thin_COLOUR
        backView.addSubview(lineView)
        
        
        var shoNum :Int = 3
        
        let payHide : String =  UserDefaults.standard.object(forKey: "payHide") as! String
          KFBLog(message: "adf8888\(payHide)")
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
        for i in 0...count {
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
            //评论 跳转详情
            if let _ =  detailBlock {
                detailBlock(self.dataModel)
            }
    
        } else {
            //赞赏  跳转详情
            if let _ =  zanshangBlock {
                zanshangBlock(self.dataModel)
            }
        }
        
    }

    func iconImageClick()  {
        if let _ =  IconImageViewBlock {
            IconImageViewBlock(self.dataModel)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
