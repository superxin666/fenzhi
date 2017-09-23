//
//  TeachDetailHeadView.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/19.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//  教学分享头部

import UIKit
typealias TeachDetailHeadViewBlock = (_ str:String)->()
class TeachDetailHeadView: UIView {

    var dataModel : TeachDetailModel = TeachDetailModel()
    var dataVC : HomeDataMangerController = HomeDataMangerController()
    var dianzanBtn : UIButton = UIButton()
    var shoucangBtn : UIButton = UIButton()
    var fenxinagBtn : UIButton = UIButton()
    var baseVC : BaseViewController = BaseViewController()
    var noticeBlock : TeachDetailHeadViewBlock!


    func setUpUIWithModelAndType(model : TeachDetailModel,height : CGFloat) {
        self.dataModel = model
        let viewW = KSCREEN_WIDTH
        let viewH = height

        let backView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: viewW, height: viewH - ip7(10)))
        backView.backgroundColor = .white
        backView.isUserInteractionEnabled = true
        self.addSubview(backView)
        //头像
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(25), y: ip7(25), width: ip7(60), height: ip7(60)))
        iconImageView.kf.setImage(with: URL(string: model.data.userInfo.avatar))
        iconImageView.isUserInteractionEnabled = true
        backView.addSubview(iconImageView)

//        let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HeartTableViewCell.iconImageClick))
//        iconImageView.addGestureRecognizer(iconImageViewTap)
        //时间
        let timeLabel : UILabel = UILabel(frame: CGRect(x: viewW - ip7(31) - ip7(90), y: ip7(25), width: ip7(90), height: ip7(20)))
        timeLabel.text = model.data.createTime
        timeLabel.font = fzFont_Thin(ip7(15))
        timeLabel.textColor  = dark_6_COLOUR
        timeLabel.textAlignment = .right
        backView.addSubview(timeLabel)

        

        //105105105
        //名字
        let nameWidth = viewW - ip7(19) - iconImageView.frame.maxX - ip7(31) - ip7(90)
        let nameLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y:  ip7(25), width: nameWidth, height: ip7(24)))
        nameLabel.text = model.data.userInfo.name
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(nameLabel)

//        let nameLabelTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HeartTableViewCell.iconImageClick))
//        nameLabel.addGestureRecognizer(nameLabelTap)

        //用户信息
        let infoLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y: nameLabel.frame.maxY + ip7(14), width: viewW - ip7(19) - iconImageView.frame.maxX, height: ip7(21)))
        infoLabel.text = model.data.userInfo.cityName + " " + model.data.userInfo.gradeName+model.data.userInfo.gradeName+"老师"
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = dark_6_COLOUR
        infoLabel.textAlignment = .left
        infoLabel.adjustsFontSizeToFitWidth = true
        backView.addSubview(infoLabel)
//85
//102 + 文字
        //文字
        let str = model.data.content
        let txtW = viewW - ip7(50)
        var txtH :CGFloat = str.getLabHeight(font: fzFont_Thin(ip7(21)), LabelWidth: txtW)
        if txtH > ip7(21) * 4 {
            txtH = ip7(21) * 4
        }
        let txtLabel : UILabel = UILabel(frame: CGRect(x: ip7(25), y: infoLabel.frame.maxY + ip7(17), width: txtW, height: txtH))
        txtLabel.text = str
        txtLabel.font = fzFont_Thin(ip7(21))
        txtLabel.textColor  = dark_3_COLOUR
        txtLabel.textAlignment = .left
        txtLabel.numberOfLines = 0
        backView.addSubview(txtLabel)


        var lastFream = txtLabel.frame;
        let appadWidth = ip7(30)

//102 + 文字 +28 + CGFloat(i) * (ip7(65) + ip7(15)）//文件 +
        if model.data.coursewares.count > 0 {
            //文件
            let imageX = ip7(30)
            let imageY = ip7(28) + txtLabel.frame.maxY

            let imageWidth = viewW - ip7(60)
            let imageHeight = ip7(65)


            for i in 0..<model.data.coursewares.count {
                let model = model.data.coursewares[i]


                let view = UIView(frame: CGRect(x: imageX, y: imageY + CGFloat(i) * (imageHeight + ip7(15)), width: imageWidth, height: imageHeight))
                view.backgroundColor = backView_COLOUR
                lastFream = view.frame

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

        if model.data.catalog.characters.count > 0 {
            //课时定位
            let dingweiImageView : UIImageView = UIImageView(image: #imageLiteral(resourceName: "icon_dingwei"))
            dingweiImageView.frame = CGRect(x: appadWidth, y: lastFream.maxY + ip7(35), width: ip7(20), height: ip7(20))
            backView.addSubview(dingweiImageView)

            let lessonLabel : UILabel = UILabel(frame: CGRect(x: dingweiImageView.frame.maxX + ip7(10), y: lastFream.maxY + ip7(35), width: viewW - dingweiImageView.frame.maxX - ip7(10) , height: ip7(21)))
            lessonLabel.text = model.data.catalog
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

 //102 + 文字 +28 + CGFloat(i) * (ip7(65) + ip7(15)）//文件 + // ip(35)+ip(21)//课时定位 + ip(30) + IP(21) + ip(15) + 1p(50) + // (ip(29) + imageWidth * CGFloat(backViewNum)) + 105
        //赞赏
        let zanshangLabel : UILabel = UILabel(frame: CGRect(x: 0, y: lineView.frame.maxY + ip7(30), width: KSCREEN_WIDTH, height: ip7(21)))
        zanshangLabel.text = "如果教学分享对您有帮助，请记得赞赏呦！"
        zanshangLabel.font = fzFont_Thin(ip7(21))
        zanshangLabel.textColor  = dark_3_COLOUR
        zanshangLabel.textAlignment = .center
        backView.addSubview(zanshangLabel)


        let zanBtn : UIButton = UIButton(frame: CGRect(x: (KSCREEN_WIDTH - ip7(145))/2, y: zanshangLabel.frame.maxY + ip7(15), width: ip7(145), height: ip7(50)))
        zanBtn.setTitle("赞赏支持", for: .normal)
        zanBtn.backgroundColor = FZColorFromRGB(rgbValue: 0xfd7acf)
        zanBtn.setTitleColor( .white, for: .normal)
        zanBtn.titleLabel?.font = fzFont_Medium(ip7(21))
//        zanBtn.addTarget(self, action:#selector(HomeViewController.heartBtnClick), for: .touchUpInside)
        backView.addSubview(zanBtn)


        //赞赏人view
        var lastfream_bottom = zanBtn.frame

        let userNum = model.data.zanUsers.count
        if userNum > 0{
            var backViewNum = userNum / 8
            if (backViewNum % 8 > 0) {
                backViewNum = userNum / 8 + 1
            }

            let viewWidth  = KSCREEN_WIDTH - appadWidth * 2

            let viewY = lastfream_bottom.maxY + ip7(29)
            let imageWidth = (viewWidth - ip7(10) * 7)/8

            let zanshangBackView : UIView = UIView(frame: CGRect(x: appadWidth, y: viewY, width: viewWidth, height: imageWidth * CGFloat(backViewNum)))
            zanshangBackView.backgroundColor = .red
            backView.addSubview(zanshangBackView)

            lastfream_bottom = zanshangBackView.frame

            for i in 0..<userNum {
                let X = ((ip7(10) + imageWidth) * CGFloat(i%8))
                let Y = CGFloat((i/8)) * (imageWidth + ip7(10))
                let model = model.data.zanUsers[i]
                let iconImage : UIImageView = UIImageView(frame: CGRect(x: X, y: Y, width: imageWidth, height: imageWidth))
                iconImage.kf.setImage(with: URL(string: model.avatar))
                zanshangBackView.addSubview(iconImage)
            }
        }

        //三个按钮
        let btnW = (viewW - appadWidth * 2)/3
        let nameArray : Array = ["\(model.data.likeNum!)点赞","\(model.data.favoriteNum!)收藏","\(model.data.shareNum!)分享"]
        let imageArr : Array = [#imageLiteral(resourceName: "icon_dz1"),#imageLiteral(resourceName: "sc2"),#imageLiteral(resourceName: "fx3")]
        let image_selectedArr : Array = [#imageLiteral(resourceName: "icon_dz1_s"),#imageLiteral(resourceName: "shape"),#imageLiteral(resourceName: "fx3_s")]

        for i in 0...2 {
            let btn : UIButton = UIButton(type: .custom)
            btn.tag = i
            if i == 0 {
                dianzanBtn = btn
                //点赞
                if model.data.isLike == 1 {
                    btn.isSelected = true
                } else {
                   btn.isSelected = false
                }
            } else if i == 1 {
                //收藏
                shoucangBtn = btn
                if model.data.isFavorite == 1 {
                    btn.isSelected = true
                } else {
                    btn.isSelected = false
                }

            } else {
                //分享
                fenxinagBtn = btn

            }
            btn.frame = CGRect(x: appadWidth + CGFloat(i) * btnW , y: lastfream_bottom.maxY + ip7(45), width: btnW, height: ip7(60))
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
        weak var weakSelf = self
        var notice : String = ""

        if sender.tag == 0 {
            if dataModel.data.isLike == 1 {
                //已经点过赞

            } else {
                //没有点过赞

            }

        } else if sender.tag == 1 {
            //
            if dataModel.data.isFavorite == 1 {
                //已经收藏
                dataVC.delfavorite(fenxId: self.dataModel.data.id, completion: { (data) in
                    let data : SmsModel = data as! SmsModel
                    if data.errno == 0 {
                        //取消收藏成功

                        weakSelf?.baseVC.SVshowSucess(infoStr: "取消收藏")
                        weakSelf?.dataModel.data.isFavorite = 0
                        weakSelf?.dataModel.data.favoriteNum = (weakSelf?.dataModel.data.favoriteNum)! - 1
                        weakSelf?.shoucangBtn.isSelected = false
                        weakSelf?.shoucangBtn.setTitle("\((weakSelf?.dataModel.data.favoriteNum)!)", for: .normal)
                    } else {
                        KFBLog(message: "取消收藏失败")
                    }

                }, failure: { (erro) in

                })

            } else {
                //没有收藏
                dataVC.favorite(fenxId: self.dataModel.data.id, completion: { (data) in
                    let data : SmsModel = data as! SmsModel
                    if data.errno == 0 {
                        //收藏成功
                        weakSelf?.baseVC.SVshowSucess(infoStr: "收藏成功")
                        weakSelf?.dataModel.data.isFavorite = 1
                        weakSelf?.dataModel.data.favoriteNum = (weakSelf?.dataModel.data.favoriteNum)! + 1
                        weakSelf?.shoucangBtn.isSelected = true
                        weakSelf?.shoucangBtn.setTitle("\((weakSelf?.dataModel.data.favoriteNum)!)", for: .selected)

                    } else {
                        KFBLog(message: "收藏失败")
                    }

                }, failure: { (erro) in

                })
            }

            if let _ = noticeBlock {
                noticeBlock("")
            }

        } else {
            //分享

        }

    }

}
