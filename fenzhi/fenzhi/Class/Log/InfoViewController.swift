//
//  InfoViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/13.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class InfoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.navigation_title_fontsize(name: "完善资料", fontsize: 27)

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
