//
//  PayView.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/19.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class PayView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let icoinImageView : UIImageView = UIImageView()//头像
    let nameLabel : UILabel  = UILabel()//名字
    let noticeBtn_top : UIButton = UIButton()//上面提示语
    let noticeLabel : UILabel  = UILabel()//提示语
    let cancleBtn : UIButton = UIButton()//取消
    let sureBtn : UIButton = UIButton()//赞赏
    let noticeBtn_bottom : UIButton = UIButton()//底部提示语
    var btnArr = Array<UIButton>()//按钮数组
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func creatUI()  {
//        let viewH = ip7(554)
//        let viewW = KSCREEN_WIDTH
        self.backgroundColor = .white
        
        //头像
        icoinImageView.frame = CGRect(x: (KSCREEN_WIDTH - ip7(48))/2, y: ip7(50), width: ip7(48), height: ip7(48))
        icoinImageView.kfb_makeRound()
//        icoinImageView.kf.setImage(with: URL(string: model.userInfo.avatar))
        icoinImageView.isUserInteractionEnabled = true
        self.addSubview(icoinImageView)
        //名字
        nameLabel.frame = CGRect(x:0, y:   icoinImageView.frame.maxY + ip7(10), width: KSCREEN_WIDTH, height: ip7(21))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = dark_3_COLOUR
        nameLabel.text = "王二小"
        nameLabel.font = fzFont_Medium(ip7(21))
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(nameLabel)
        //上部提示语
        noticeBtn_top.frame = CGRect(x: ip7(170), y:nameLabel.frame.maxY + ip7(19), width: KSCREEN_WIDTH - ip7(340), height: ip7(18))
        noticeBtn_top.setTitle("你的赞赏，我的动力", for: .normal)
        noticeBtn_top.setTitleColor(dark_6_COLOUR, for: .normal)
        noticeBtn_top.titleLabel?.font = fzFont_Thin(ip7(18))
        self.addSubview(noticeBtn_top)
        
        //价格按钮
        let btnBackView = UIView(frame: CGRect(x: 0, y: noticeBtn_top.frame.maxY + ip7(43), width: KSCREEN_WIDTH, height: ip7(136)))
        btnBackView.backgroundColor = .clear
        self.addSubview(btnBackView)
    
        let nameArr = ["2","5","10","20","30","50",]
        let imageWidth = ip7(130)
        let imageHeight = ip7(50)
        let appad = (KSCREEN_WIDTH - imageWidth * 3)/4

        for i in 0..<6 {
            let btn = UIButton(type: .custom)
            btn.tag = i
            btnArr.append(btn)
            let Y = CGFloat((i/3)) * (imageHeight + ip7(36))
            let X = ((appad + imageWidth) * CGFloat(i%3))
            btn.frame = CGRect(x:appad + X, y:Y, width: imageWidth, height: imageHeight)
            btn.addTarget(self, action: #selector(self.btnclcik(sender:)), for: .touchUpInside)
            btn.setTitle(nameArr[i]+"元", for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.kfb_makeRadius(radius: 4)
            btn.kfb_makeBorderWithBorderWidth(width: 0.5, color: FZColorFromRGB(rgbValue: 0x979797))
            btn.titleLabel?.font = fzFont_Thin(ip7(21))
            btn.backgroundColor = .white
            if i == 0 {
                btn.backgroundColor = blue_COLOUR
            }
            btnBackView.addSubview(btn)
        }
        
        //分割线
        let lineView = UIView(frame: CGRect(x: 0 , y: btnBackView.frame.maxY + ip7(43), width: KSCREEN_WIDTH, height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        self.addSubview(lineView)
        
        //支付按钮
        cancleBtn.frame = CGRect(x: ip7(68), y:lineView.frame.maxY + ip7(32), width: ip7(180), height: ip7(51))
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(.white, for: .normal)
        cancleBtn.titleLabel?.font = fzFont_Thin(ip7(21))
        cancleBtn.backgroundColor = FZColorFromRGB(rgbValue: 0x8cd851)
        self.addSubview(cancleBtn)

        sureBtn.frame = CGRect(x: KSCREEN_WIDTH - ip7(68) - ip7(180), y:lineView.frame.maxY + ip7(32), width: ip7(180), height: ip7(51))
        sureBtn.setTitle("赞赏", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.titleLabel?.font = fzFont_Thin(ip7(21))
        sureBtn.backgroundColor = blue_COLOUR
        self.addSubview(sureBtn)
        
        //提示2
        noticeBtn_bottom.frame = CGRect(x: ip7(195), y:sureBtn.frame.maxY + ip7(32), width: KSCREEN_WIDTH - ip7(390), height: ip7(21))
        noticeBtn_bottom.setTitle("默认微信支付", for: .normal)
        noticeBtn_bottom.setTitleColor(.black, for: .normal)
        noticeBtn_bottom.titleLabel?.font = fzFont_Thin(ip7(21))
        noticeBtn_bottom.backgroundColor = .clear
        self.addSubview(noticeBtn_bottom)
    }
    
    func setUpData(name : String,iconStr : String)  {
        icoinImageView.kf.setImage(with: URL(string: iconStr))
        nameLabel.text = name
    }
    
    func btnclcik(sender : UIButton) {
        let tagNum = sender.tag
        for btn in self.btnArr {
            if btn.tag == tagNum {
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = blue_COLOUR
            } else {
                btn.setTitleColor(.black, for: .normal)
                btn.backgroundColor = .white
            }
        }
    }
}
