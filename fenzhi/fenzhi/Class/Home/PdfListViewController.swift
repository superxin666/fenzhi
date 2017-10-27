//
//  PdfListViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/26.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class PdfListViewController: BaseViewController {

    let textView : UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        self.navigation_title_fontsize(name: "文件列表", fontsize: 27)
        self.navigationBar_leftBtn()
        self.creatUI()
        
    }
    
    func creatUI()  {
        
        let backView = UIView(frame: CGRect(x: 0, y:LNAVIGATION_HEIGHT +  ip7(20), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(20)))
        backView.backgroundColor = .white
        self.view.addSubview(backView)
        
        textView.frame = CGRect(x: ip7(13), y: ip7(17), width: KSCREEN_WIDTH - ip7(26), height: ip7(400))
        textView.font = fzFont_Thin(ip7(24))
        textView.textColor = dark_6_COLOUR
        textView.textAlignment = .natural
        backView.addSubview(textView)
        
        //第一部分
        let mutableStr = NSMutableAttributedString()
        let str1 = NSAttributedString(string: "Ios选择添加文件发布需要先打开文件，例如，先在邮箱里打开要发布的文件，点击右上角")
        mutableStr.append(str1)
 
        let attachment1 = NSTextAttachment()
        attachment1.image = #imageLiteral(resourceName: "icon_fx2-1")
        attachment1.bounds = CGRect(x: 0, y: 0, width: ip7(28), height: ip7(37))
        let attIcon1 = NSAttributedString(attachment: attachment1)
        mutableStr.append(attIcon1)
        
        //第二部分
        let str2 = NSAttributedString(string: "选择底部的“其他应用打开“")
        mutableStr.append(str2)
        
        let attachment2 = NSTextAttachment()
        attachment2.image = #imageLiteral(resourceName: "icon_qtyy-1")
        attachment2.bounds = CGRect(x: 0, y: 0, width: ip7(33), height: ip7(33))
        let attIcon2 = NSAttributedString(attachment: attachment2)
        mutableStr.append(attIcon2)
        
        
        
        //第三部分
        let str3 = NSAttributedString(string: "，再选择“拷贝到纷知”拷贝到纷知")
        mutableStr.append(str3)

        let attachment3 = NSTextAttachment()
        attachment3.image = #imageLiteral(resourceName: "icon_kb-1")
        attachment3.bounds = CGRect(x: 0, y: 0, width: ip7(48), height: ip7(48))
        let attIcon3 = NSAttributedString(attachment: attachment3)
        mutableStr.append(attIcon3)
        
        let str4 = NSAttributedString(string: "\n建议：上官网发布带文件的分享更方便，官网：www.fenzhi-edu.com")
        mutableStr.append(str4)

        textView.attributedText = mutableStr
    
    }
    override func navigationLeftBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
