//
//  TeachReleaseViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/7.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class TeachReleaseViewController: BaseViewController,UITextViewDelegate {
    let textField: UITextView = UITextView()
    let btnBackView :UIView = UIView()
    let nsetBtn : UIButton = UIButton()
    override func viewDidLoad() {

//        self.navigationBar_rightBtn_title(name: "发布")
        // Do any additional setup after loading the view
        super.viewDidLoad()
        self.title = "教学分享"
        self.view.backgroundColor = .white
        self.view.isUserInteractionEnabled = true
        self.navigationBar_leftBtn()
        self.creatUI()


    }

    func creatUI()  {

        let lineView = UIView(frame: CGRect(x: 0, y: LNAVIGATION_HEIGHT, width: KSCREEN_WIDTH, height: ip7(11)))
        lineView.backgroundColor = backView_COLOUR
        self.view.addSubview(lineView)

        //
        textField.frame = CGRect(x: ip7(15), y: lineView.frame.maxY + ip7(25), width: KSCREEN_WIDTH - ip7(30), height: ip7(200))
        textField.textAlignment = .left
        textField.returnKeyType = .done
        textField.delegate = self
        textField.tag = 101
        textField.becomeFirstResponder()
        textField.backgroundColor = .clear
        textField.font =  fzFont_Thin(ip7(18))
        self.view.addSubview(textField)

        self.creatBtnView()
        textField.inputAccessoryView = btnBackView
    }


    func creatBtnView() {
        btnBackView.frame =  CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(55))
        btnBackView.backgroundColor = blue_COLOUR
        //
        nsetBtn.frame = CGRect(x: ip7(25), y: (ip7(55) - ip7(14))/2, width: ip7(25), height: ip7(14))
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_x"), for: .normal)
        nsetBtn.backgroundColor = .clear
        nsetBtn.addTarget(self, action:#selector(TeachReleaseViewController.nestBtnClik), for: .touchUpInside)
        btnBackView.addSubview(nsetBtn)

//        let tdBtn : UIButton = UIButton(frame: CGRect(x: ip7(25), y: (ip7(55) - ip7(14))/2, width: ip7(25), height: ip7(14)))
//        tdBtn.setImage(#imageLiteral(resourceName: "icon_dw2"), for: .normal)
//        tdBtn.backgroundColor = .clear
//        //        nsetBtn.addTarget(self, action:#selector(HomeViewController.heartBtnClick), for: .touchUpInside)
//        btnBackView.addSubview(tdBtn)

        let picBtn : UIButton = UIButton(frame: CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25), y: 0, width: ip7(55), height: ip7(55)))
        picBtn.setImage(#imageLiteral(resourceName: "icon_tp"), for: .normal)
        picBtn.backgroundColor = .clear
//            nsetBtn.addTarget(self, action:#selector(HomeViewController.heartBtnClick), for: .touchUpInside)
        btnBackView.addSubview(picBtn)

        let tdBtn : UIButton = UIButton(frame: CGRect(x: picBtn.frame.origin.x - ip7(60), y: (ip7(55) - ip7(35))/2, width: ip7(35), height: ip7(35)))
        tdBtn.setImage(#imageLiteral(resourceName: "icon_dw2"), for: .normal)
        tdBtn.backgroundColor = .clear
        //        nsetBtn.addTarget(self, action:#selector(HomeViewController.heartBtnClick), for: .touchUpInside)
        btnBackView.addSubview(tdBtn)

        let lineView = UIView(frame: CGRect(x: tdBtn.frame.maxX + ip7(12), y: (ip7(55) - ip7(35))/2, width: 0.5, height: ip7(35)))
        lineView.backgroundColor = .white
        btnBackView.addSubview(lineView)

    }

    func nestBtnClik()  {

    }

    func textViewDidEndEditing(_ textView: UITextView) {

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
