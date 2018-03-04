//
//  UserInfoHeadView.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/15.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
typealias UserInfoHeadViewBlock = ()->()
enum viewType {
    case main
    case other
}
class UserInfoHeadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let dataVC = MineDataManger()
    var baseVC : BaseViewController = BaseViewController()
    
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
    var guanzhuBtn :UIButton = UIButton()

    var dataModel = ProfileMineModel_data()
    

    func creatHeadView(type : viewType) {
        self.backgroundColor = .white
        //背景图
        var height = ip7(290+24)
        if type == .other {
            height = ip7(340+24)
        }
        height = iPhoneX ? height + ip7(24) :height

        let backImageView : UIImageView = UIImageView(image: #imageLiteral(resourceName: "bg1"))
        backImageView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: height)
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
        if type == .other {
            // 关注
            guanzhuBtn.frame = CGRect(x: (KSCREEN_WIDTH - ip7(125))/2, y: infoLabel.frame.maxY + ip7(20), width: ip7(125), height: ip7(40))
            guanzhuBtn.setTitle("关注", for: .normal)
            guanzhuBtn.setTitle("已关注", for: .selected)
            guanzhuBtn.backgroundColor = blue_COLOUR
            guanzhuBtn.setTitleColor( .white, for: .normal)
            guanzhuBtn.titleLabel?.font = fzFont_Medium(ip7(21))
            guanzhuBtn.kfb_makeRadius(radius: 4)
            guanzhuBtn.addTarget(self, action:#selector(UserInfoHeadView.gunzhuClick(sender:)), for: .touchUpInside)
            self.addSubview(guanzhuBtn)
        }

        
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
            lable.text = ""
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
        if model.avatar.count > 0 {
            dataModel = model
            iconImageView.kf.setImage(with: URL(string: model.avatar))
            nameLabel.text = model.name
            dressLabel.text = model.cityName+" "+model.districtName+" "+model.schoolName+" "+model.gradeName
            infoLabel.text = model.subjectName+" "+model.versionName
            guanzhuLabel.text = "\(model.followNum!)"
            fensiLabel.text = "\(model.fansNum!)"
            zanLabel.text = "\(model.likeNum!)"
            shoucangLabel.text = "\(model.favoriteNum!)"
            
            
            if (model.isFollow) == 1 {
                //已关注
                self.guanzhuBtn.isSelected = true
            } else {
                self.guanzhuBtn.isSelected = false
            }
            
        }
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
