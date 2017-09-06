//
//  HomeViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let topBackView : UIView = UIView()//头部view背景图


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "首页"
        self.view.backgroundColor = .white
        self.creatTopView()
    }

    func creatTopView() {
        let viewHeight  = ip6(66)
        topBackView.frame = CGRect(x: 0, y: LNAVIGATION_HEIGHT, width: KSCREEN_WIDTH, height: viewHeight + ip6(20))
        topBackView.backgroundColor = .white
        self.view.addSubview(topBackView)

        //教学分享  
        let height = ip6(21)
        let btnY = (viewHeight - height)/2
        let stBtn : UIButton = UIButton(frame: CGRect(x: 0, y: btnY, width: KSCREEN_WIDTH/2, height: height))
        stBtn.setTitle("教学分享", for: .normal)
        stBtn.setTitleColor(FZColor(red: 102, green: 102, blue: 102, alpha: 1.0), for: .normal)
        stBtn.titleLabel?.font = UIFont.systemFont(ofSize: ip6(21))
        stBtn.backgroundColor = .clear
        topBackView.addSubview(stBtn)

        let lineView = UIView()
        let lineViewY = (ip6(66) - ip6(20))/2

        lineView.frame = CGRect(x: KSCREEN_WIDTH/2, y: lineViewY, width: 0.5, height: ip6(20))
        lineView.backgroundColor = FZColor(red: 102, green: 102, blue: 102, alpha: 1.0)
        topBackView.addSubview(lineView)


        //心得分享
        let hertBtn : UIButton = UIButton(frame: CGRect(x: KSCREEN_WIDTH/2, y: btnY, width: KSCREEN_WIDTH/2, height: height))
        hertBtn.setTitle("心得分享", for: .normal)
        hertBtn.backgroundColor = .clear
        hertBtn.setTitleColor(FZColor(red: 102, green: 102, blue: 102, alpha: 1.0), for: .normal)
        hertBtn.titleLabel?.font = UIFont.systemFont(ofSize: ip6(21))
        topBackView.addSubview(hertBtn)

        //
        let lineView2 = UIView()
        lineView2.frame = CGRect(x: 0, y: ip6(66), width: KSCREEN_WIDTH, height: ip6(20))
        lineView2.backgroundColor = FZColorFromRGB(rgbValue: 0xf4f8f9)
        topBackView.addSubview(lineView2)

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
