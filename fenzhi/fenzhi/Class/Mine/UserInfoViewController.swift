//
//  UserInfoViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/10.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class UserInfoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigation_title_fontsize(name: "用户详情", fontsize: 27)
        self.navigationBar_leftBtn()
    
        // Do any additional setup after loading the view.
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
