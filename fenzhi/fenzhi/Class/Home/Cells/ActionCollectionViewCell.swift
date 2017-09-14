//
//  ActionCollectionViewCell.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/24.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程详情动作图片 UICollectionViewCell 

import UIKit

class ActionCollectionViewCell: UICollectionViewCell {
    var imageView :UIImageView!
    var label : UILabel!


    override init(frame: CGRect) {
        super.init(frame: frame)
        let itemWidth :CGFloat = ip7(240)
        let itemHeight :CGFloat = ip7(180)

        //图片
        imageView = UIImageView(frame: CGRect(x: ip7(25), y: 0, width: itemWidth - ip7(25), height: itemHeight))
        self.contentView.addSubview(imageView)
        //名字
//        label = UILabel(frame: CGRect(x: 0, y: imageView.frame.maxY + 3, width: self.frame.size.width, height: ip7(25)))
//        label.font = UIFont.systemFont(ofSize: ip7(10))
//        label.numberOfLines = -1
//        label.textAlignment = .center
//        label.textColor = dark_105_COLOUR
//        self.contentView.addSubview(label)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUI(image : UIImage, name : String)  {
         imageView.image = image
//         label.text = name
    }
}
