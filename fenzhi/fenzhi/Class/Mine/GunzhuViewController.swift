//
//  GunzhuViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/15.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let GUANZHUELLID = "GUANZHUCELL_ID"//

class GunzhuViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    let mainTabelView : UITableView = UITableView()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigation_title_fontsize(name: "关注", fontsize: 27)
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.creatTableView()
        
    }
    
    //MARK:tableView
    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y: ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(15))
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(GuanzhuTableViewCell.self, forCellReuseIdentifier: GUANZHUELLID)
        self.view.addSubview(mainTabelView)
        
    }
    
    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell : GuanzhuTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: GUANZHUELLID, for: indexPath) as! GuanzhuTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if (cell == nil)  {
            cell = GuanzhuTableViewCell(style: .default, reuseIdentifier: GUANZHUELLID)
        }
        cell.setUpUIWithModel_cellType(type: .guanzhu)
        weak var weakself = self
//        cell.IconImageViewBlock = { () in
//            print("头像点击")
//            let vc = UserInfoViewController()
//            vc.hidesBottomBarWhenPushed = true
//            weakself?.navigationController?.pushViewController(vc, animated: true)
//        }
        return cell;
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return ip7(95);
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
