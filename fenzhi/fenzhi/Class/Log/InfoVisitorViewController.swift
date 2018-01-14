//
//  InfoVisitorViewController.swift
//  fenzhi
//
//  Created by lvxin on 2018/1/14.
//  Copyright © 2018年 Xunqiu. All rights reserved.
//  游客

import UIKit
enum InfoVisitor_Type {
    case res_first
    case other
}
class InfoVisitorViewController: BaseViewController {
    var type :InfoView_Type!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.navigation_title_fontsize(name: "完善资料", fontsize: 27)
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.creatUI()
    }


    func creatUI()  {

    }
    override func navigationLeftBtnClick() {
        self.SVdismiss()
        if type == .res_first {
            self.navigationController?.popViewController(animated: true)
        } else {
            let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
            dele.showLogin()
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
