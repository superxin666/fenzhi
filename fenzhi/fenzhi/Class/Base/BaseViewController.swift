//
//  BaseViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/7.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //左边返回键
    func navigationBar_leftBtn(){
        let btn:UIButton = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setImage(UIImage(named:"button_back"), for:.normal)
        btn.addTarget(self, action:#selector(BaseViewController.navigationLeftBtnClick), for: .touchUpInside)
        let item:UIBarButtonItem = UIBarButtonItem(customView:btn)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,action: nil)
        spacer.width = -15;

        //        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.leftBarButtonItems = [spacer,item]
    }

    func navigationBar_rightBtn_title(name:String, textColour:UIColor = .black){
        let btn:UIButton = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        btn.setTitle(name, for: .normal)
        btn.setTitleColor(textColour, for: .normal)
        btn.addTarget(self, action:#selector(BaseViewController.navigationRightBtnClick), for: .touchUpInside)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        let item:UIBarButtonItem = UIBarButtonItem(customView:btn)
        self.navigationItem.rightBarButtonItem = item
    }

    func navigationLeftBtnClick() {

    }

    func navigationRightBtnClick() {

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
