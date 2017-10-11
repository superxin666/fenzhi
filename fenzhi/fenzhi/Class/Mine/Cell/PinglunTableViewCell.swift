//
//  PinglunTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/11.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class PinglunTableViewCell: UITableViewCell {
    var dataModel : GetcommentlistModel_data_list_commentList = GetcommentlistModel_data_list_commentList()
    
    
    
    func setUpUI(model : GetcommentlistModel_data_list_commentList)  {
        dataModel = model
        
        
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
