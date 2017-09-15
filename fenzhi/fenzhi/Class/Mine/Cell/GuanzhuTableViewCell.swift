//
//  GuanzhuTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/15.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

enum GUANZHU_FENSI_CellType {
    case guanzhu
    case fensi
}
class GuanzhuTableViewCell: UITableViewCell {
    
    
    
    
    func setUpUIWithModel_cellType(type : GUANZHU_FENSI_CellType) {
        let viewH = ip7(95)
        //头像
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(27), y:  (viewH - ip7(50))/2, width: ip7(50), height: ip7(50) ))
        iconImageView.image = #imageLiteral(resourceName: "touxiang")
        iconImageView.isUserInteractionEnabled = true
        self.addSubview(iconImageView)
        
    
        let nameWidth = KSCREEN_WIDTH - ip7(19) - iconImageView.frame.maxX - ip7(31) - ip7(90)
        let nameLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y:  ip7(25), width: nameWidth, height: ip7(24)))
        nameLabel.text = "尼古拉斯赵四"
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = FZColorFromRGB(rgbValue: 0x333333)
        nameLabel.font = fzFont_Medium(ip7(24))
        nameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(nameLabel)
        
        let timeLabel : UILabel = UILabel(frame: CGRect(x: KSCREEN_WIDTH - ip7(31) - ip7(90), y: ip7(25), width: ip7(90), height: ip7(20)))
        timeLabel.text = "24:00"
        timeLabel.font = fzFont_Thin(ip7(15))
        timeLabel.textColor  = FZColor(red: 197, green: 198, blue: 203, alpha: 1.0)
        timeLabel.textAlignment = .right
        timeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(timeLabel)
        
        
        let infoLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(19), y: nameLabel.frame.maxY + ip7(14), width: KSCREEN_WIDTH - ip7(19) - iconImageView.frame.maxX, height: ip7(21)))
        infoLabel.text = "北京 三年级语文老师"
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        infoLabel.textAlignment = .left
        infoLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(infoLabel)
    
        
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
