//
//  MainTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/10.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpUIWith(name : String, image : UIImage, index : Int) {
        var height = ip7(80)
        //头像
        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(46), y: (height - ip7(30))/2, width: ip7(30), height: ip7(30)))
        iconImageView.image = image
        self.addSubview(iconImageView)
        //名字
        let nameLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(37), y: (height - ip7(21))/2, width: ip7(100), height: ip7(21)))
        nameLabel.text = name
        nameLabel.font = fzFont_Thin(ip7(21))
        nameLabel.textColor  = FZColor(red: 102, green: 102, blue: 102, alpha: 1.0)
        nameLabel.textAlignment = .left
        self.addSubview(nameLabel)

        //头像
        let arrowImageView : UIImageView = UIImageView(frame: CGRect(x:KSCREEN_WIDTH -  ip7(47), y: (height - ip7(20))/2, width: ip7(20), height: ip7(20)))
        arrowImageView.image = #imageLiteral(resourceName: "icon_jt")
        self.addSubview(arrowImageView)

        let lineView = UIView()
        let lineViewY = height - 0.5
        lineView.frame = CGRect(x: 0, y: lineViewY, width: KSCREEN_WIDTH, height: 0.5)
        lineView.backgroundColor = lineView_thin_COLOUR
        if  index == 4{
            lineView.isHidden = true
        } else if index == 3 {
            height = ip7(95)
            lineView.backgroundColor = backView_COLOUR
            lineView.frame = CGRect(x: 0, y: height - 14.5 , width: KSCREEN_WIDTH, height: ip7(15))
        }
        self.addSubview(lineView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
