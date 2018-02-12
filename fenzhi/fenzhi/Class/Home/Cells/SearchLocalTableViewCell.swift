//
//  SearchLocalTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2018/2/11.
//  Copyright © 2018年 Xunqiu. All rights reserved.
//  搜索历史记录 cell

import UIKit
let SearchLocalTableViewCellH = ip7(55)

class SearchLocalTableViewCell: UITableViewCell {
    var label : UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatUI() {
        label = UILabel(frame: CGRect(x: ip7(10), y: 0, width: KSCREEN_WIDTH - ip7(10), height: SearchLocalTableViewCellH))
        label.textColor = dark_6_COLOUR
        label.font = fzFont_Thin(ip7(15))
        self.addSubview(label)
        
        let lineView = UIView(frame: CGRect(x: ip7(10), y: SearchLocalTableViewCellH - 1, width: KSCREEN_WIDTH - ip7(10), height: 1))
        lineView.backgroundColor = lineView_thin_COLOUR
        self.addSubview(lineView)
        
    }
    func setData(title:String) {
        label.text = title
    }

}
