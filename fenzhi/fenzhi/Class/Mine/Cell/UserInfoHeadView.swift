//
//  UserInfoHeadView.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/15.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
typealias UserInfoHeadViewBlock = ()->()
class UserInfoHeadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var guanzhuViewBlock : UserInfoHeadViewBlock!
    var fensiViewBlock : UserInfoHeadViewBlock!

    var iconImageView :UIImageView!
    var nameLabel :UILabel!
    var dressLabel :UILabel!
    var infoLabel :UILabel!

    var guanzhuLabel :UILabel!
    var fensiLabel :UILabel!
    var zanLabel :UILabel!
    var shoucangLabel :UILabel!



    func creatHeadView() {
        self.backgroundColor = .white
        //背景图
        let backImageView : UIImageView = UIImageView(image: #imageLiteral(resourceName: "bg1"))
        backImageView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(290))
        self.addSubview(backImageView)
        
        //头像
        iconImageView = UIImageView(image: #imageLiteral(resourceName: "touxiang"))
        iconImageView.frame = CGRect(x: (KSCREEN_WIDTH - ip7(70))/2, y: LNAVIGATION_HEIGHT, width: ip7(70), height: ip7(70))
        iconImageView.kfb_makeRound()
        self.addSubview(iconImageView)

        //名字
        nameLabel = UILabel(frame: CGRect(x: 0, y:  iconImageView.frame.maxY +  ip7(15), width: KSCREEN_WIDTH, height: ip7(26)))
//        nameLabel.text = "尼古拉斯赵四"
        nameLabel.textColor = .white
        nameLabel.font = fzFont_Medium(ip7(26))
        nameLabel.textAlignment = .center
        self.addSubview(nameLabel)
        //住址
        dressLabel  = UILabel(frame: CGRect(x: 0, y:  nameLabel.frame.maxY +  ip7(15), width: KSCREEN_WIDTH, height: ip7(21)))
//        dressLabel.text = "北京 东城区 红磨坊小学 三年级"
        dressLabel.textColor = .white
        dressLabel.font = fzFont_Thin(ip7(21))
        dressLabel.textAlignment = .center
        self.addSubview(dressLabel)
        
        //信息
        infoLabel = UILabel(frame: CGRect(x: 0, y:  dressLabel.frame.maxY +  ip7(5), width: KSCREEN_WIDTH, height: ip7(21)))
//        infoLabel.text = "语文老师 人教版"
        infoLabel.textColor = .white
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textAlignment = .center
        self.addSubview(infoLabel)
        
        let nameArr = ["关注","粉丝","被赞","被收藏",]
        let viewWidth = KSCREEN_WIDTH / 4
        //底部按钮
        for i in 0...3 {
            
            let view = UIView(frame: CGRect(x: viewWidth * CGFloat(i), y: backImageView.frame.maxY, width: viewWidth, height: ip7(92)))
            view.tag = i
            view.isUserInteractionEnabled = true
            
            
            let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserInfoHeadView.iconImageClick(tapGesture:)))
        
            
            view.addGestureRecognizer(tap)
            
            let lable : UILabel = UILabel(frame: CGRect(x: 0, y:  ip7(19), width: viewWidth, height: ip7(21)))
            lable.font = fzFont_Thin(ip7(21))
            lable.text = "--"
            lable.textColor = dark_6_COLOUR
            lable.textAlignment = .center
            lable.adjustsFontSizeToFitWidth = true
            view.addSubview(lable)
            switch i {
            case 0:
                guanzhuLabel = lable
            case 1:
                fensiLabel = lable
            case 2:
                zanLabel = lable
            default:
                shoucangLabel = lable
            }


            let lable2 : UILabel = UILabel(frame: CGRect(x: 0, y: lable.frame.maxY + ip7(10), width: viewWidth, height: ip7(21)))
            lable2.text = nameArr[i]
            lable2.font = fzFont_Thin(ip7(21))
            lable2.textColor = dark_a_COLOUR
            lable2.textAlignment = .center
            lable2.adjustsFontSizeToFitWidth = true
            view.addSubview(lable2)
            self.addSubview(view)
            
        }
        
    }

    func setUpData(model : ProfileMineModel_data) {
        iconImageView.kf.setImage(with: URL(string: model.avatar))
        nameLabel.text = model.name
        dressLabel.text = model.cityName+" "+model.districtName+" "+model.schoolName+" "+model.gradeName
        infoLabel.text = model.subjectName+" "+model.versionName

        guanzhuLabel.text = "\(model.followNum!)"
        fensiLabel.text = "\(model.fansNum!)"
        zanLabel.text = "\(model.likeNum!)"
        shoucangLabel.text = "\(model.favoriteNum!)"

    }
    
    
    func iconImageClick(tapGesture:UITapGestureRecognizer) {
        let tagNum = tapGesture.view!.tag
        if tagNum == 0 {
            KFBLog(message: "关注")
            if let _ = guanzhuViewBlock  {
                guanzhuViewBlock()
            }
            
        } else if tagNum == 1{
            
            KFBLog(message: "粉丝")
            if let _ = fensiViewBlock  {
                fensiViewBlock()
            }
        
        }
        
    
    }


}
