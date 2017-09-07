//
//  TeachReleaseViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/7.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class TeachReleaseViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "教学分享"
        self.view.backgroundColor = .white
        self.navigationBar_leftBtn()
        self.navigationBar_rightBtn_title(name: "发布")
        // Do any additional setup after loading the view.
    }

    override func navigationLeftBtnClick() {
        self.dismiss(animated: true) { 
            
        }
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
