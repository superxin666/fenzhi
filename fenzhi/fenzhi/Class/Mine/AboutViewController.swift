//
//  AboutViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/24.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigation_title_fontsize(name: "关于我们", fontsize: 27)
        self.navigationBar_leftBtn()
        self.view.backgroundColor = backView_COLOUR
        self.creatUI()
    }
    
    func creatUI() {
        let backView = UIView()
        backView.backgroundColor = .white
        backView.frame = CGRect(x: ip7(10), y:LNAVIGATION_HEIGHT + ip7(15), width: KSCREEN_WIDTH - ip7(20), height: KSCREEN_HEIGHT - ip7(15))
        self.view.addSubview(backView)
        
        let iconImageView = UIImageView(frame: CGRect(x: (KSCREEN_WIDTH - ip7(104))/2, y: ip7(50), width: ip7(104), height: ip7(104)))
        iconImageView.kfb_makeRound()
        iconImageView.image = #imageLiteral(resourceName: "logo512")
        backView.addSubview(iconImageView)
        
        let textView = UITextView(frame: CGRect(x: ip7(31), y: iconImageView.frame.maxY + ip7(36), width: KSCREEN_WIDTH - ip7(62), height: ip7(300)))
        textView.font = fzFont_Thin(ip7(21))
        textView.textColor = dark_3_COLOUR
        textView.text = "纷知是由汇智星辰（北京）教育科技有限公司于2017年创立，致力于将老师们缤纷的教学知识和教学心得传递给国内更多其他的老师。公司核心团队来自百度，360，美团等国内一线互联网科技公司。创始人对于教育行业有深厚的情结，希望为国内教育信息、教育公平化做出一些自己的贡献。\n温馨提示：上官网发布带文件的分享更便捷，还支持发布视频，官网：www.fenzhi-edu.com"
        backView.addSubview(textView)
        
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
