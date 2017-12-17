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

        let str1f = NSAttributedString(string: "Hi 您好！欢迎使用纷知。使用纷知iOS版上传文件，只需要以下几步：")
        mutableStr.append(str1f)

        let str1 = NSAttributedString(string: "\n1、打开需要上传的文件，例如在「QQ」里打开，先点击右上角")
        mutableStr.append(str1)

        let attachment1 = NSTextAttachment()
        attachment1.image = #imageLiteral(resourceName: "icon_fx2-1")
        attachment1.bounds = CGRect(x: 0, y: 0, width: ip7(28), height: ip7(37))
        let attIcon1 = NSAttributedString(attachment: attachment1)
        mutableStr.append(attIcon1)

        let str1s = NSAttributedString(string: "按钮")
        mutableStr.append(str1s)
        //第二部分
        let str2 = NSAttributedString(string: "\n2、选择「其他应用打开」。")
        mutableStr.append(str2)

        
        //第三部分
        let str3 = NSAttributedString(string: "\n3、找到「拷贝至纷知")
        mutableStr.append(str3)
        
        let attachment2 = NSTextAttachment()
        attachment2.image = #imageLiteral(resourceName: "icon_kb-1")
        attachment2.bounds = CGRect(x: 0, y: 0, width: ip7(33), height: ip7(33))
        let attIcon2 = NSAttributedString(attachment: attachment2)
        mutableStr.append(attIcon2)

        let str3s = NSAttributedString(string: "」并点选。")
        mutableStr.append(str3s)

        //第四部分
        let str4 = NSAttributedString(string: "\n4、发布成功。")
        mutableStr.append(str4)

        let str5 = NSAttributedString(string: "\n温馨提示：上官网发布带文件的分享更便捷，官网：www.fenzhi-edu.com")
        mutableStr.append(str5)
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
