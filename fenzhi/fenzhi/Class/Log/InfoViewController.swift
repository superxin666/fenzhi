//
//  InfoViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/13.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let ICONCELLID = "ICONCELL_ID"//
let INFOCELLID = "INFOCELLL_ID"//

enum InfoView_Type {
    case res_first
    case other
}

class InfoViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    var type :InfoView_Type!
    
    
    let mainTabelView : UITableView = UITableView()
    let nameArr = ["","姓名","地区","学校","年级","学科","教材版本",]
    let plaNameArr = ["","输入您的名字","请选择您所在的地区","请选择您所在学校","请选择您所在学校年级","请选择您所教学科","请选择您所用教材版本",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.navigation_title_fontsize(name: "完善资料", fontsize: 27)
        
        self.creatUI()
        // Do any additional setup after loading the view.
    }
    
    func creatUI()  {
        mainTabelView.frame = CGRect(x: 0, y: ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(15))
        mainTabelView.backgroundColor = UIColor.white
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(UpIconTableViewCell.self, forCellReuseIdentifier: ICONCELLID)
        mainTabelView.register(InfoTableViewCell.self, forCellReuseIdentifier: INFOCELLID)
        self.view.addSubview(mainTabelView)
    }
    
    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            var cell : UpIconTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: ICONCELLID, for: indexPath) as! UpIconTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if (cell == nil)  {
                cell = UpIconTableViewCell(style: .default, reuseIdentifier: ICONCELLID)
            }
            cell.setUpUI()
            return cell;
        } else {
            var cell : InfoTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: INFOCELLID, for: indexPath) as! InfoTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if (cell == nil)  {
                cell = InfoTableViewCell(style: .default, reuseIdentifier: INFOCELLID)
            }
            cell.setUpUI_name(name: nameArr[indexPath.row], pla: plaNameArr[indexPath.row])
            return cell;
    
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0 {
            return ip7(130);
        } else {
            return ip7(90);
        }
        
    }
    
    
    
    
    override func navigationLeftBtnClick() {
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
