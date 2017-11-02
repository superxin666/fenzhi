//
//  InfoTableViewCell.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/14.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell,UITextFieldDelegate {
    let infoLabel2:UILabel = UILabel()
    let infoLabel : UILabel = UILabel()
    let _nameTextField : UITextField = UITextField()//手机号
    var nameStr :String = ""

    func setUpUI_name(name:String,pla:String)  {
        
        //名字
        let viewH = ip7(90)
        
        //用户信息
        infoLabel.frame = CGRect(x:ip7(37), y: (viewH - ip7(21))/2, width: ip7(100), height: ip7(21))
        infoLabel.text = name
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = dark_3_COLOUR
        infoLabel.textAlignment = .left
//        self.addSubview(infoLabel)
        self.contentView.addSubview(infoLabel)
        
        //
        infoLabel2.frame = CGRect(x:infoLabel.frame.maxX + ip7(50), y: (viewH - ip7(21))/2, width: KSCREEN_WIDTH - infoLabel.frame.maxX - ip7(50), height: ip7(21))
        infoLabel2.text = pla
        infoLabel2.font = fzFont_Thin(ip7(21))
        infoLabel2.textColor  = dark_6_COLOUR
        infoLabel2.textAlignment = .left
//        self.addSubview(infoLabel2)
        self.contentView.addSubview(infoLabel2)
        
        let lineView2 = UIView()
        lineView2.frame = CGRect(x: 0, y: viewH - 0.5, width: KSCREEN_WIDTH, height: 0.5)
        lineView2.backgroundColor = backView_COLOUR
//        self.addSubview(lineView2)
        self.contentView.addSubview(lineView2)
        
    }
    
    
    func setUpUI_name_txtFiled(name:String,pla:String)  {
        
        //名字
        let viewH = ip7(90)
        
        //用户信息
        let infoLabel : UILabel = UILabel(frame: CGRect(x:ip7(37), y: (viewH - ip7(21))/2, width: ip7(100), height: ip7(21)))
        infoLabel.text = name
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textColor  = dark_3_COLOUR
        infoLabel.textAlignment = .left
        self.addSubview(infoLabel)
        
        
        //
        _nameTextField.frame = CGRect(x:infoLabel.frame.maxX + ip7(50), y: (viewH - ip7(21))/2, width: KSCREEN_WIDTH - infoLabel.frame.maxX - ip7(50), height: ip7(21))
        //      设置placeholder的属性
//        var attributes2:[String : Any] = NSDictionary() as! [String : Any]
//        attributes2[NSFontAttributeName] = fzFont_Thin(ip7(18))
//        let string2:NSAttributedString = NSAttributedString.init(string: "请输入6-20位密码", attributes: attributes2)
//        _nameTextField.attributedPlaceholder = name
        
        _nameTextField.font = fzFont_Thin(ip7(21))
        _nameTextField.placeholder = pla
        _nameTextField.textColor = dark_6_COLOUR
        _nameTextField.adjustsFontSizeToFitWidth = true
        _nameTextField.textAlignment = .left
//        _nameTextField.returnKeyType = .done
        _nameTextField.delegate = self
        _nameTextField.tag = 101
      

        let inputView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: 45))
        inputView.backgroundColor = backView_COLOUR
        let rightBtn = UIButton(frame: CGRect(x: KSCREEN_WIDTH - 60, y: 0, width: 45, height: 45))
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.setTitleColor(dark_3_COLOUR, for: .normal)
        inputView.addSubview(rightBtn)
        rightBtn.addTarget(self, action: #selector(self.textFieldShouldReturn(_:)), for: .touchUpInside)
        _nameTextField.inputAccessoryView = inputView
        self.addSubview(_nameTextField)
        
        let lineView2 = UIView()
        lineView2.frame = CGRect(x: 0, y: viewH - 0.5, width: KSCREEN_WIDTH, height: 0.5)
        lineView2.backgroundColor = backView_COLOUR
        self.addSubview(lineView2)
        
    }

    func setUpName(name : String) {
        infoLabel2.text = name
    }
    
    
    
    // MARK: textFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("名字：\(String(describing: textField.text))")
        nameStr = textField.text!
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _nameTextField.resignFirstResponder()
        return true
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
