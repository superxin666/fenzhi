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
    
    func navigation_title_fontsize(name:String, fontsize:Int) {
        self.title = name
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: fzFont_Thin(ip7(fontsize))]
        
    
    }

    func navigationLeftBtnClick() {

    }

    func navigationRightBtnClick() {

    }
    
    func KfbShowWithInfo(titleString:String) {
        
//        if self.isShowing {
//            return
//        }
//        
//        self.isShowing = true
//        
//        activityView.backgroundColor = green_COLOUR
//        activityView.alpha = 0.9
//        self.view.addSubview(activityView)
//        
//        activityLabel.text = titleString
//        activityLabel.textColor = UIColor.white
//        activityLabel.font = UIFont.systemFont(ofSize: 15)
//        activityLabel.textAlignment = NSTextAlignment.center
//        let activityStrWidth = getLabWidth(labelStr: titleString as String, font: activityLabel.font, height: activityView.frame.size.height)
//        
//        
//        activityLabel.frame = CGRect(x:KSCREEN_WIDTH/2 - activityStrWidth/2,y:0,width:activityStrWidth,height:activityView.frame.size.height)
//        
//        activityView.addSubview(activityLabel)
//        
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//            self.activityView.frame.origin.y = 0
//        }) { (finished) in
//            
//            self.perform(#selector(self.KfbShowStop), with: self, afterDelay: 1.5)
//        }
        
        
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
