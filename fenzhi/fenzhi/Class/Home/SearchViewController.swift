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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
       self.navigationItem.hidesBackButton = true
        self.creatSearchBar()

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
            KFBLog(message: "222")
            if view is UIButton {
                KFBLog(message: "1111")
                let btn : UIButton = view as! UIButton
                btn.setTitle("取消", for: .normal)
            }
        }
        searchBar.placeholder = "搜索 用户/文章/教材"
        searchBar.barStyle = .default
        searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchBar
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
