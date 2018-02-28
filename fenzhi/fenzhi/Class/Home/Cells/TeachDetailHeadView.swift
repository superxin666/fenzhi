//
//  TeachDetailHeadView.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/19.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//  资料分享头部

import UIKit
import BMPlayer

typealias TeachDetailHeadViewBlock = (_ model:TeachDetailModel_data_coursewares)->()
typealias TeachDetailHeadViewZANSHANGBlock = (_ model:TeachDetailModel)->()
typealias TeachDetailHeadViewImageViewBlock = (_ imageNum:Int)->()
let showNum : Int = 5
let zanImageWidth = ip7(48)

class TeachDetailHeadView: UIView {

    var dataModel : TeachDetailModel = TeachDetailModel()
    var dataVC : HomeDataMangerController = HomeDataMangerController()
    var comVC : CommonDataMangerViewController = CommonDataMangerViewController()
    var dianzanBtn : UIButton = UIButton()
    var shoucangBtn : UIButton = UIButton()
    var fenxinagBtn : UIButton = UIButton()
    var baseVC : BaseViewController = BaseViewController()
    var docBlock : TeachDetailHeadViewBlock!
    var zanshangBlock  : TeachDetailHeadViewZANSHANGBlock!
    var fenxiangBlock : TeachDetailHeadViewZANSHANGBlock!
    var iconImageBlock : TeachDetailHeadViewZANSHANGBlock!
    var imageBlock : TeachDetailHeadViewImageViewBlock!
    var player:BMPlayer!
    var bigBtn : UIButton!
    var videoFream : CGRect!
    
    var lastFream:CGRect!
    var vc : TeachDetailViewController!
    var backView : UIView!
    

    func setUpUIWithModelAndType(model : TeachDetailModel,height : CGFloat,type : Int) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        self.dataModel = model
        let viewW = KSCREEN_WIDTH
        let viewH = height
        //frame:  CGRect(x: 0, y: 0, width: viewW, height: viewH - ip7(10))
        backView = UIView()
        self.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.left.right.equalTo(self).offset(0)
            make.height.equalTo(viewH )
        }
        backView.backgroundColor = .white
        backView.isUserInteractionEnabled = true
  
        //头像
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(25), y: ip7(25), width: ip7(60), height: ip7(60)))
        iconImageView.kf.setImage(with: URL(string: model.data.userInfo.avatar))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.kfb_makeRound()
        backView.addSubview(iconImageView)

        let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.iconImageClick))
        iconImageView.addGestureRecognizer(iconImageViewTap)
        //时间
        let timeLabel : UILabel = UILabel(frame: CGRect(x: viewW - ip7(31) - ip7(90), y: ip7(25), width: ip7(90), height: ip7(20)))
        timeLabel.text = String.getDate_detail(dateStr: model.data.createTime)
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
        //" " + model.data.userInfo.gradeName
        infoLabel.text = model.data.userInfo.cityName + " " + model.data.userInfo.gradeName + model.data.userInfo.subjectName+"老师"
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
        let txtH :CGFloat = str.getLabHeight(font: fzFont_Thin(ip7(21)), LabelWidth: txtW)
//        if txtH > ip7(21) * 4 {
//            txtH = ip7(21) * 4
//        }
        let txtLabel : UILabel = UILabel(frame: CGRect(x: ip7(25), y: infoLabel.frame.maxY + ip7(17), width: txtW, height: txtH))
        txtLabel.text = str
        txtLabel.font = fzFont_Thin(ip7(21))
        txtLabel.textColor  = dark_3_COLOUR
        txtLabel.textAlignment = .left
        txtLabel.numberOfLines = 0
        backView.addSubview(txtLabel)


        lastFream = txtLabel.frame
        videoFream = lastFream
        let appadWidth = ip7(30)

//102 + 文字 +28 + CGFloat(i) * (ip7(65) + ip7(15)）//文件 +
        if type == 0 {
            
            //是否视频
            if model.data.videoInfo.videoUrl.count > 0 {
   

                let playW = KSCREEN_WIDTH
                let playH = KSCREEN_WIDTH * 9.0/16.0
//                let playX = (KSCREEN_WIDTH - playW)/2
                BMPlayerConf.shouldAutoPlay = false
                BMPlayerConf.topBarShowInCase = .horizantalOnly
                BMPlayerConf.enableVolumeGestures = false
                BMPlayerConf.enableBrightnessGestures = false
                player = BMPlayer()
                 backView.addSubview(player)

                player.snp.makeConstraints({ (make) in
                    KFBLog(message: "\(lastFream.maxY)")
                    make.top.equalTo(self).offset(lastFream.maxY + ip7(10))
                    make.left.right.equalTo(self).offset(0)
                    make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(KSCREEN_WIDTH)
                })
                let asset = BMPlayerResource(url: URL(string: model.data.videoInfo.videoUrl)!,
                                             name: model.data.videoInfo.title)
                player.setVideo(resource: asset)
                lastFream = CGRect(x: 0, y: lastFream.maxY + ip7(10), width: playW, height: playH)
                
            }
            
            //资料
            if model.data.coursewares.count > 0 {
                //文件
                let imageX = ip7(30)
                let imageY = ip7(28) + lastFream.maxY

                let imageWidth = viewW - ip7(60)
                let imageHeight = ip7(65)


                for i in 0..<model.data.coursewares.count {
                    let model = model.data.coursewares[i]
                    let view = UIView(frame: CGRect(x: imageX, y: imageY + CGFloat(i) * (imageHeight + ip7(15)), width: imageWidth, height: imageHeight))
                    view.tag = i
                    view.backgroundColor = backView_COLOUR
                    view.isUserInteractionEnabled = true
                    lastFream = view.frame

                    let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TeachDetailHeadView.ppt_click(tap:)))
                    view.addGestureRecognizer(iconImageViewTap)


                    //图片
                    let imageView = UIImageView()
                    if model.type.contains("pdf") {
                        imageView.image = #imageLiteral(resourceName: "pdf")
                        
                    } else if model.type.contains("ppt") {
                        imageView.image = #imageLiteral(resourceName: "pptx")
                    } else if model.type.contains("xls") ||  model.type.contains("exc"){
                        imageView.image = #imageLiteral(resourceName: "icon_ex")
                    } else {
                        imageView.image = #imageLiteral(resourceName: "word")
                    }
                    imageView.frame = CGRect(x: 0, y: 0, width: ip7(65), height: ip7(65))
                    view.addSubview(imageView)
                    //描述
                    let label : UILabel = UILabel(frame: CGRect(x: imageView.frame.maxX + ip7(10), y: (imageHeight - ip7(21))/2, width: imageWidth - imageView.frame.maxX - ip7(10), height: ip7(21)))
                    label.text = model.name.removingPercentEncoding!
                    label.font = fzFont_Thin(ip7(21))
                    label.textColor  = dark_3_COLOUR
                    label.textAlignment = .left
                    view.addSubview(label)
                    backView.addSubview(view)
                }
            }

        } else {
            //心得
            if model.data.images.count > 0 {
                //图片
                let imageX = ip7(30)
                let imageY = ip7(32) + txtLabel.frame.maxY
                let appad = ip7(20)
                let imageWidth = (viewW - ip7(60) - ip7(20))/2
                let imageHeight = imageWidth * 355/428

                for i in 0..<model.data.images.count  {
                    let imageStr :String = model.data.images[i]
                    let imageView = UIImageView()
                    imageView.kf.setImage(with: URL(string: imageStr))
                    imageView.tag = i
                    imageView.isUserInteractionEnabled = true
                    let Y = CGFloat((i/2)) * (imageHeight + ip7(20))
                    let X = ((appad + imageWidth) * CGFloat(i%2))
                    imageView.frame =  CGRect(x: imageX + X, y: imageY + Y, width: imageWidth, height: imageHeight)
                    lastFream = imageView.frame;
                    backView.addSubview(imageView)
                    
                    let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.image_click(sender:)))
                    imageView.addGestureRecognizer(tap)
                }

                
            }

        }

//102 + 文字 +28 + CGFloat(i) * (ip7(65) + ip7(15)）//文件 + // ip(35)+ip(21)//课时定位 +

        if model.data.catalog.count > 0 {
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
        zanshangLabel.text = "如果资料分享对您有帮助，请记得赞赏呦！"
        zanshangLabel.font = fzFont_Thin(ip7(21))
        zanshangLabel.textColor  = dark_3_COLOUR
        zanshangLabel.textAlignment = .center
        backView.addSubview(zanshangLabel)


        let zanBtn : UIButton = UIButton(frame: CGRect(x: (KSCREEN_WIDTH - ip7(145))/2, y: zanshangLabel.frame.maxY + ip7(15), width: ip7(145), height: ip7(50)))
        zanBtn.setTitle("赞赏支持", for: .normal)
        zanBtn.backgroundColor = FZColorFromRGB(rgbValue: 0xfd7acf)
        zanBtn.setTitleColor( .white, for: .normal)
        zanBtn.titleLabel?.font = fzFont_Medium(ip7(21))
        zanBtn.addTarget(self, action:#selector(TeachDetailHeadView.zanshang_click), for: .touchUpInside)
        backView.addSubview(zanBtn)


        //赞赏人view
        var lastfream_bottom = zanBtn.frame

        let userNum = model.data.zanUsers.count
        let showNum : Int = 5
        
        if userNum > 0{
            var backViewNum = userNum / showNum
            if (backViewNum % showNum > 0) {
                backViewNum = userNum / showNum + 1
            }

            let viewWidth  = KSCREEN_WIDTH - appadWidth * 2

            let viewY = lastfream_bottom.maxY + ip7(29)
    

            let zanshangBackView : UIView = UIView(frame: CGRect(x: appadWidth, y: viewY, width: viewWidth, height: zanImageWidth * CGFloat(backViewNum)))
//            zanshangBackView.backgroundColor = .red
            backView.addSubview(zanshangBackView)
            lastfream_bottom = zanshangBackView.frame
        
         
            
            for i in 0..<userNum {
                var X = ((ip7(10) + zanImageWidth) * CGFloat(i%showNum))
                if userNum < showNum {
                    let ap = (viewWidth - (zanImageWidth + ip7(10)) * CGFloat(userNum))/2
                    X = X + ap
                } else {
                    let ap = (viewWidth - (zanImageWidth + ip7(10)) * CGFloat(5))/2
                    X = X + ap
                }
                let Y = CGFloat((i/showNum)) * (zanImageWidth + ip7(10))
                let model = model.data.zanUsers[i]
                let iconImage : UIImageView = UIImageView(frame: CGRect(x: X, y: Y, width: zanImageWidth, height: zanImageWidth))
                iconImage.kf.setImage(with: URL(string: model.avatar))
                iconImage.kfb_makeRound()
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
        backView.bringSubview(toFront: player)

    }

    func btn_click(sender : UIButton) {
        weak var weakSelf = self


        if sender.tag == 0 {
            if dataModel.data.isLike == 1 {
                //已经点过赞

            } else {
                //没有点过赞
                weak var weakSelf = self
                comVC.like(type: 0, objectId: self.dataModel.data.id!, completion: { (data) in
                    let model : LikeModel = data as! LikeModel
                    if model.errno == 0 {
                        weakSelf?.baseVC.SVshowSucess(infoStr: "点赞成功")
                        weakSelf?.dianzanBtn.isSelected = true
                        weakSelf?.dataModel.data.isLike = 1
                        let num = (weakSelf?.dataModel.data.likeNum)! + 1
                        weakSelf?.dataModel.data.likeNum = num
                        weakSelf?.dianzanBtn.setTitle("\(num)点赞", for: .selected)
                    } else {
                        weakSelf?.baseVC.SVshowErro(infoStr: model.errmsg)
                    }

                }) { (erro) in

                }


            }

        } else if sender.tag == 1 {
            //
            if dataModel.data.isFavorite == 1 {
                //已经收藏
                dataVC.delfavorite(fenxId: self.dataModel.data.id!, completion: { (data) in
                    let data : SmsModel = data as! SmsModel
                    if data.errno == 0 {
                        //取消收藏成功

                        weakSelf?.baseVC.SVshowSucess(infoStr: "取消收藏")
                        weakSelf?.dataModel.data.isFavorite = 0
                        weakSelf?.dataModel.data.favoriteNum = (weakSelf?.dataModel.data.favoriteNum)! - 1
                        weakSelf?.shoucangBtn.isSelected = false
                        weakSelf?.shoucangBtn.setTitle("\((weakSelf?.dataModel.data.favoriteNum)!)收藏", for: .normal)
                    } else {
                         weakSelf?.baseVC.SVshowErro(infoStr: data.errmsg)
                    }

                }, failure: { (erro) in

                })

            } else {
                //没有收藏
                dataVC.favorite(fenxId: self.dataModel.data.id!, completion: { (data) in
                    let data : SmsModel = data as! SmsModel
                    if data.errno == 0 {
                        //收藏成功
                        weakSelf?.baseVC.SVshowSucess(infoStr: "收藏成功")
                        weakSelf?.dataModel.data.isFavorite = 1
                        weakSelf?.dataModel.data.favoriteNum = (weakSelf?.dataModel.data.favoriteNum)! + 1
                        weakSelf?.shoucangBtn.isSelected = true
                        weakSelf?.shoucangBtn.setTitle("\((weakSelf?.dataModel.data.favoriteNum)!)收藏", for: .selected)

                    } else {
                         weakSelf?.baseVC.SVshowErro(infoStr: data.errmsg)
                    }

                }, failure: { (erro) in

                })
            }

        } else {
            //分享
            if let _ = fenxiangBlock {
                fenxiangBlock(self.dataModel)
            }
        }

    }


    func ppt_click(tap : UITapGestureRecognizer) {
        let tagNum = tap.view!.tag
        let model = self.dataModel.data.coursewares[tagNum]

        if model.file.count > 0 {
            if let _ = docBlock {
                docBlock(model)
            }
        }

    }
    
    func zanshang_click() {
        if let _ = zanshangBlock {
            zanshangBlock(self.dataModel)
        }
    }
    
    func iconImageClick() {
        if let _ = iconImageBlock {
            iconImageBlock(self.dataModel)
        }
    }
    
    func image_click(sender : UITapGestureRecognizer) {
        let tagNum = sender.view?.tag
        if let _ = imageBlock  {
            imageBlock(tagNum!)
        }
    }
    func bigClick(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            //大
            KFBLog(message: "大")
            player.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT)
        } else {
            //小
            KFBLog(message: "小")
            player.frame = videoFream
        }
    }
    func top() {
        KFBLog(message: "上")
    }
    func bottom() {
        KFBLog(message: "下")
    }
    func receiverNotification() {

        let orient = UIDevice.current.orientation
        
        switch orient {
        case .portrait :
            print("屏幕正常竖向")
    
            vc?.navigationController?.navigationBar.isHidden = false
            KFBLog(message: "高度\(videoFream.maxY)")
            player.snp.removeConstraints()
            player.snp.makeConstraints({ (make) in
                make.top.equalTo(self).offset(videoFream.maxY + ip7(10))
                make.left.right.equalTo(self).offset(0)
                make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(KSCREEN_WIDTH)
            })
            player.layoutIfNeeded()
            player.setNeedsLayout()
            break
        case .portraitUpsideDown:
            print("屏幕倒立")
            break
        case .landscapeLeft:
            print("屏幕左旋转")

                  vc?.navigationController?.navigationBar.isHidden = true
            player.snp.removeConstraints()
            player.snp.makeConstraints({ (make) in
                make.top.equalTo(self).offset(0)
                make.left.right.equalTo(self).offset(0)
                make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(KSCREEN_WIDTH)
//                make.bottom.equalTo(0)
            })
            player.layoutIfNeeded()
            player.setNeedsLayout()
            break
        case .landscapeRight:
            print("屏幕右旋转")
            break
        default:
            break
        }
        backView.layoutIfNeeded()
        backView.setNeedsLayout()
    }
}
