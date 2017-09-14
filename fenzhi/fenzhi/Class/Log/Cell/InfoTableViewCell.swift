//
//  InfoTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/14.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    
    func setUpUI_name(name:String,pla:String)  {
        
        //名字
        let viewH = ip7(90)
        
        //用户信息
        let infoLabel : UILabel = UILabel(frame: CGRect(x:ip7(37), y: (viewH - ip7(21))/2, width: ip7(100), height: ip7(21)))
        infoLabel.text = name
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        infoLabel.textAlignment = .left
        self.addSubview(infoLabel)
        
        
        //
        let infoLabel2 : UILabel = UILabel(frame: CGRect(x:infoLabel.frame.maxX + ip7(50), y: (viewH - ip7(21))/2, width: KSCREEN_WIDTH - infoLabel.frame.maxX - ip7(50), height: ip7(21)))
        infoLabel2.text = pla
        infoLabel2.font = fzFont_Thin(ip7(21))
        infoLabel2.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        infoLabel2.textAlignment = .left
        self.addSubview(infoLabel2)
        
        let lineView2 = UIView()
        lineView2.frame = CGRect(x: 0, y: viewH - 0.5, width: KSCREEN_WIDTH, height: 0.5)
        lineView2.backgroundColor = backView_COLOUR
        self.addSubview(lineView2)
        
        
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
