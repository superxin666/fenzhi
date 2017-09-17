//
//  UpIconTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/14.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
typealias UpIconViewBlock = ()->()
class UpIconTableViewCell: UITableViewCell {
    let iconImageView : UIImageView = UIImageView()
    var IconImageViewBlock : UpIconViewBlock!
    func setUpUI()  {
        
        //名字
        let viewH = ip7(125)
        
        //用户信息
        let infoLabel : UILabel = UILabel(frame: CGRect(x:ip7(37), y: (viewH - ip7(21))/2, width: ip7(90), height: ip7(21)))
        infoLabel.text = "头像"
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        infoLabel.textAlignment = .left
        self.addSubview(infoLabel)
        
        //头像
        iconImageView.frame =  CGRect(x:KSCREEN_WIDTH - ip7(80) - ip7(40), y: (viewH - ip7(80))/2, width: ip7(80), height: ip7(80))
        iconImageView.image = #imageLiteral(resourceName: "tx_m")
        iconImageView.isUserInteractionEnabled = true
        iconImageView.kfb_makeRound()
        self.addSubview(iconImageView)

        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UpIconTableViewCell.icon_click))

        iconImageView.addGestureRecognizer(tap)


        //点击上传
        let infoLabel2X = iconImageView.frame.origin.x - ip7(120)
        
        let infoLabel2 : UILabel = UILabel(frame: CGRect(x: infoLabel2X, y: (viewH - ip7(21))/2, width: ip7(100), height: ip7(21)))
        infoLabel2.text = "点击上传"
        infoLabel2.font = fzFont_Thin(ip7(21))
        infoLabel2.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        infoLabel2.textAlignment = .left
        self.addSubview(infoLabel2)
        
        
        let lineView2 = UIView()
        lineView2.frame = CGRect(x: 0, y: viewH - 0.5, width: KSCREEN_WIDTH, height: ip7(5))
        lineView2.backgroundColor = backView_COLOUR
        self.addSubview(lineView2)
        
        
    }

    func icon_click() {
        if let _ =  IconImageViewBlock {
            IconImageViewBlock()
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
