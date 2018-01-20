//
//  SearchViewController.swift
//  fenzhi
//
//  Created by lvxin on 2018/1/9.
//  Copyright © 2018年 Xunqiu. All rights reserved.
//  搜索页面

import UIKit

class SearchViewController: BaseViewController,UISearchBarDelegate {
    var searchBar : UISearchBar!
    var iteamBarBackView : UIView = UIView()
    var lastBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        self.creatSearchBar()
        self.iteamBar()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.


    }
    func creatSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: ip7(20), y: 0, width: KSCREEN_WIDTH - ip7(40), height: ip7(44)))
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        for view in searchBar.subviews[0].subviews {
            KFBLog(message: view.self)
            if view is UIButton {
                let btn : UIButton = view as! UIButton
                btn.setTitle("取消", for: .normal)
            }
        }
        searchBar.placeholder = "搜索 内容 资料 用户"
        searchBar.barStyle = .default
        searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchBar
    }
    
    func iteamBar() {
        let viewHeight  = ip7(66)
        iteamBarBackView.frame = CGRect(x: 0, y: LNAVIGATION_HEIGHT + ip7(20), width: KSCREEN_WIDTH, height: viewHeight)
        iteamBarBackView.backgroundColor = .white
        self.view.addSubview(iteamBarBackView)
        let nameArr = ["内容","资料","用户"]
        
        let btnW = KSCREEN_WIDTH/3
        for i in 0..<3 {
            let stBtn : UIButton = UIButton(frame: CGRect(x:CGFloat(i) * btnW, y: 0, width: btnW, height: viewHeight))
            stBtn.setTitle(nameArr[i], for: .normal)
            stBtn.tag = i
            if i == 0{
                lastBtn = stBtn
                stBtn.isSelected = true
            }
            stBtn.setTitleColor(FZColor(red: 102, green: 102, blue: 102, alpha: 1.0), for: .normal)
            stBtn.setTitleColor(blue_COLOUR, for: .selected)
            stBtn.titleLabel?.font = fzFont_Medium(ip7(21))
            stBtn.backgroundColor = .clear
            stBtn.addTarget(self, action:#selector(self.btnClick(sender:)), for: .touchUpInside)
        
            iteamBarBackView.addSubview(stBtn)
            
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: ip7(65), width: KSCREEN_WIDTH, height: 1))
        lineView.backgroundColor = lineView_thin_COLOUR
        iteamBarBackView .addSubview(lineView);
    }
    // MARK: searchBarDelegate 代理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        KFBLog(message: "开始所搜")
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        KFBLog(message: "结束输入文字")
        KFBLog(message: searchBar.text)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        KFBLog(message: "搜索取消")
        searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        KFBLog(message: "开始输入文字")
//        searchBar.showsCancelButton = true
//        for view in searchBar.subviews[0].subviews {
//            KFBLog(message: view.self)
//            KFBLog(message: "222")
//            if view is UIButton {
//                KFBLog(message: "1111")
//                let btn : UIButton = view as! UIButton
//                btn.setTitle("取消", for: .normal)
//            }
//        }

    }
    
    // MARK: - event respoonse
    func btnClick(sender:UIButton) {
        if sender.isSelected {
            return
        }
        
        lastBtn.isSelected = false
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 0 {
            //"内容"
            KFBLog(message: "内容")
        } else if sender.tag == 1{
            //"资料"
            KFBLog(message: "资料")
        } else {
            //"用户
             KFBLog(message: "用户")
        }
        lastBtn = sender
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
