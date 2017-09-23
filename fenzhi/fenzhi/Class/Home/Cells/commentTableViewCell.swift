//
//  commentTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/20.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
typealias commentTableViewCellBlock = (_ model:GetcommentlistModel_data_list_commentList)->()
class commentTableViewCell: UITableViewCell {
    let iconImageView:UIImageView = UIImageView()//头像
    let nameLabel : UILabel = UILabel()//姓名

    let timeLabel : UILabel = UILabel()//时间
    let zanBtn : UIButton = UIButton()//点赞
    let zanNumLabel : UILabel = UILabel()//点赞数
    
    let pinglunBtn : UIButton = UIButton()//评论
    
    let contentLabel : UILabel = UILabel()//内容

    let toUserName : UILabel = UILabel()//底下姓名
    let toContent : UILabel = UILabel()//底下评论内容

    let backView : UIView = UIView()
    let lineView : UIView = UIView()
    
    let dataVC = CommonDataMangerViewController()
    var dataModel : GetcommentlistModel_data_list_commentList = GetcommentlistModel_data_list_commentList()
    var pinglunViewBlock : commentTableViewCellBlock!
    var delViewBlock : commentTableViewCellBlock!

    let delbtn : UIButton = UIButton()
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatUI() {
        let viewW = KSCREEN_WIDTH
        //头像
        iconImageView.frame = CGRect(x: ip7(25), y: ip7(50), width: ip7(60), height: ip7(60))
        iconImageView.kfb_makeRound()
        iconImageView.isUserInteractionEnabled = true
        self.addSubview(iconImageView)

        let iconImageViewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentTableViewCell.image_Click))
        iconImageView.addGestureRecognizer(iconImageViewTap)

        //名字
        let nameWidth = viewW - ip7(19) - iconImageView.frame.maxX - ip7(31) - ip7(90)
        nameLabel.frame = CGRect(x: iconImageView.frame.maxX + ip7(25), y:  ip7(50), width: nameWidth, height: ip7(24))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(nameLabel)
        
        let nameTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentTableViewCell.image_Click))
        nameLabel.addGestureRecognizer(nameTap)

        //时间
        timeLabel.frame = CGRect(x: iconImageView.frame.maxX + ip7(25), y: nameLabel.frame.maxY + ip7(5), width: ip7(90), height: ip7(15))

        timeLabel.font = fzFont_Thin(ip7(15))
        timeLabel.textColor  = dark_6_COLOUR
        timeLabel.textAlignment = .left
        self.addSubview(timeLabel)
        
        //点赞
        zanBtn.frame = CGRect(x: KSCREEN_WIDTH - ip7(25) - ip7(25), y: nameLabel.frame.maxY + ip7(5), width: ip7(25), height: ip7(25))
        zanBtn.setImage(#imageLiteral(resourceName: "icon_dz1"), for: .normal)
        zanBtn.setImage(#imageLiteral(resourceName: "icon_dz1_s"), for: .selected)
        self.addSubview(zanBtn)
        //点赞数目
        zanNumLabel.frame = CGRect(x: zanBtn.frame.origin.x - ip7(42), y: nameLabel.frame.maxY + ip7(8), width: ip7(30), height: ip7(15))
        zanNumLabel.font = fzFont_Thin(ip7(15))
        zanNumLabel.textColor  = dark_6_COLOUR
        zanNumLabel.textAlignment = .right
//        zanNumLabel.backgroundColor = .red
        self.addSubview(zanNumLabel)
        
        //评论
        pinglunBtn.frame = CGRect(x: zanNumLabel.frame.origin.x - ip7(37+25), y: nameLabel.frame.maxY + ip7(5), width: ip7(25), height: ip7(25))
        pinglunBtn.setImage(#imageLiteral(resourceName: "icon_pl1"), for: .normal)
        pinglunBtn.addTarget(self, action: #selector(commentTableViewCell.pinglun_Click), for: .touchUpInside)
        self.addSubview(pinglunBtn)
        
        //文字
        contentLabel.font = fzFont_Thin(ip7(21))
        contentLabel.textColor  = FZColor(red: 102, green: 102, blue: 102, alpha: 1.0)
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 0
        self.addSubview(contentLabel)

        lineView.backgroundColor = lineView_thin_COLOUR
        self.addSubview(lineView)
        
        
    }

    func setUpUIWithModel_cellType(model : GetcommentlistModel_data_list_commentList) {
        dataModel = model;
        let viewW = KSCREEN_WIDTH
        iconImageView.kf.setImage(with: URL(string: model.userInfo.avatar))//头像
        nameLabel.text = model.userInfo.name//名字
        timeLabel.text = String.getDate_detail_cell(dateStr: model.createTime)//时间
        zanNumLabel.text = "\(model.likeNum!)"//赞数目
        if model.isLike == 1 {
            //已经赞过
            zanBtn.isSelected = true
        } else {
            //没赞过
            zanBtn.isSelected = false
            zanBtn.addTarget(self, action: #selector(commentTableViewCell.zan_Click), for: .touchUpInside)
        }
        //内容
        let str = model.content
        let txtW = viewW - iconImageView.frame.maxX - ip7(25)  - ip7(50)
        let txtH :CGFloat = str.getLabHeight(font: fzFont_Thin(ip7(21)), LabelWidth: txtW)

        contentLabel.frame = CGRect(x: iconImageView.frame.maxX + ip7(25), y: timeLabel.frame.maxY + ip7(31), width: txtW, height: txtH)
        contentLabel.text = str
        //是否有回复内容
        if model.toCommentInfo.content.characters.count>0 {

            backView.frame = CGRect(x: iconImageView.frame.maxX + ip7(25), y: contentLabel.frame.maxY + ip7(29), width: KSCREEN_WIDTH - iconImageView.frame.maxX - ip7(50), height: ip7(53))
            backView.backgroundColor = FZColorFromRGB(rgbValue: 0xf7f7f7)
            self.addSubview(backView)
            //删除按钮
            delbtn.frame = CGRect(x: backView.frame.size.width - ip7(60), y: 0, width: ip7(60), height: ip7(53))
            delbtn.setTitle("删除", for: .normal)
            delbtn.backgroundColor = .white
            delbtn.setTitleColor(blue_COLOUR, for: .normal)
            delbtn.titleLabel?.font = fzFont_Medium(ip7(21))
            delbtn.addTarget(self, action:#selector(commentTableViewCell.del_click), for: .touchUpInside)
            backView.addSubview(delbtn)
//            KFBLog(message: "\(model.userId)")
//            KFBLog(message: LoginModelMapper.getLoginIdAndTokenInUD().loginId)
            if "\(model.userId!)" == LoginModelMapper.getLoginIdAndTokenInUD().loginId{
                delbtn.isHidden = false
            } else {
                delbtn.isHidden = true
            }

            //名字
            let str : String  = model.toUserInfo.name+"："
            let attributeStr = NSMutableAttributedString(string: str)
            let range : NSRange = NSRange.init(location: 0, length: str.characters.count)
            attributeStr.addAttribute(NSForegroundColorAttributeName, value: blue_COLOUR, range: range)
            let str2 : String  = model.toCommentInfo.content
            let attributeStr2 = NSMutableAttributedString(string: str2)
            let range2 : NSRange = NSRange.init(location: 0, length: str2.characters.count)
            attributeStr2.addAttribute(NSForegroundColorAttributeName, value: dark_6_COLOUR, range: range2)
            attributeStr.append(attributeStr2)

            toUserName.frame = CGRect(x:0, y:  ip7(16), width: backView.frame.size.width, height: ip7(21))
            toUserName.attributedText = attributeStr
            toUserName.isUserInteractionEnabled = true
//            toUserName.textColor = dark_6_COLOUR
            toUserName.font = fzFont_Thin(ip7(21))
            toUserName.adjustsFontSizeToFitWidth = true
            backView.addSubview(toUserName)

        } else {
            //判断有没有删除按钮
            //删除按钮
            delbtn.frame = CGRect(x: KSCREEN_WIDTH - ip7(60) - ip7(25), y: contentLabel.frame.maxY + ip7(10), width: ip7(60), height: ip7(21))
            delbtn.setTitle("删除", for: .normal)
            delbtn.backgroundColor = .clear
            delbtn.setTitleColor(blue_COLOUR, for: .normal)
            delbtn.titleLabel?.font = fzFont_Medium(ip7(21))
            delbtn.addTarget(self, action:#selector(commentTableViewCell.del_click), for: .touchUpInside)
            self.addSubview(delbtn)
            //            KFBLog(message: "\(model.userId)")
            //            KFBLog(message: LoginModelMapper.getLoginIdAndTokenInUD().loginId)
            if "\(model.userId!)" == LoginModelMapper.getLoginIdAndTokenInUD().loginId{
                delbtn.isHidden = false
            } else {
                delbtn.isHidden = true
            }

            backView.removeFromSuperview()
        }
        //横线
        lineView.frame = CGRect(x: 0, y: model.cellHeight - 0.5, width: KSCREEN_WIDTH, height: 0.5)
        
    }
    
    func zan_Click() {
        if self.dataModel.isLike == 1 {
            return
        }
        KFBLog(message: "赞点击")
        weak var weakSelf = self
        dataVC.like(type: 1, objectId: self.dataModel.id!, completion: { (data) in
            let model : LikeModel = data as! LikeModel
            if model.errno == 0 {
                weakSelf?.zanBtn.isSelected = true
                weakSelf?.dataModel.isLike = 1
                let num = (weakSelf?.dataModel.likeNum)! + 1
                weakSelf?.dataModel.isLike = num
                weakSelf?.zanNumLabel.text = "\(num)"
            } else {
                KFBLog(message: "点赞失败")
            }
            
        }) { (erro) in
            
        }
    }
    func image_Click() {
        KFBLog(message: "头像点击")
    }

    func pinglun_Click() {
         KFBLog(message: "评论点击")
        if let _ =  pinglunViewBlock {
            pinglunViewBlock(self.dataModel)
        }
    }

    func del_click()  {
        KFBLog(message: "删除评论")
        if let _ =  delViewBlock {
            delViewBlock(self.dataModel)
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
