//
//  DingweiViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/14.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
typealias DingweiViewControllerBloke = (_ name:String) -> ()
class DingweiViewController: BaseViewController {
    var sureBlock : DingweiViewControllerBloke!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigation_title_fontsize(name: "课时定位", fontsize: 27)
        self.navigationBar_leftBtn()
        // Do any additional setup after loading the view.
    }
    
    override func navigationLeftBtnClick() {
        if let _ = sureBlock {
            sureBlock("第二课 我爱你塞北的学")
        }
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
