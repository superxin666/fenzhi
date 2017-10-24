//
//  SettingViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/11.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    let topBackImageView : UIImageView = UIImageView()
    let iconImageView : UIImageView = UIImageView()
    let mainTabelView : UITableView = UITableView()
    let nameArr = ["姓名","地区","学校","年级","学科","教材版本",]
//    let plaNameArr = ["输入您的名字","请选择您所在的地区","请选择您所在学校","请选择您所在学校年级","请选择您所教学科","请选择您所用教材版本",]
    var plaNameArr = Array<String>()
    
    
    var dataModel :ProfileMineModel!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationbar_transparency()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        self.navigation_title_fontsize(name: "个人信息", fontsize: 27)
        self.navigationBar_leftBtn()
        plaNameArr.append(dataModel.data.name)
        plaNameArr.append(dataModel.data.districtName)
        plaNameArr.append(dataModel.data.schoolName)
        plaNameArr.append(dataModel.data.gradeName)
        plaNameArr.append(dataModel.data.subjectName)
        plaNameArr.append(dataModel.data.versionName)
        self.crearUI()
    }
    
    //MARK: 创建视图
    func crearUI() {
        topBackImageView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(234))
        topBackImageView.image = #imageLiteral(resourceName: "bg1")
        self.view.addSubview(topBackImageView)
        
        iconImageView.frame = CGRect(x: (KSCREEN_WIDTH - ip7(63))/2, y: LNAVIGATION_HEIGHT, width: ip7(63), height: ip7(63))
        iconImageView.kf.setImage(with: URL(string: dataModel.data.avatar))
        iconImageView.kfb_makeRound()
        topBackImageView.addSubview(iconImageView)
        
        mainTabelView.frame = CGRect(x: 0, y: topBackImageView.frame.maxY + ip7(20), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(20) - topBackImageView.frame.maxY )
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : InfoTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: INFOCELLID, for: indexPath) as! InfoTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if (cell == nil)  {
            cell = InfoTableViewCell(style: .default, reuseIdentifier: INFOCELLID)
        }
        if indexPath.row == 1 {
            cell.setUpUI_name_txtFiled(name: nameArr[indexPath.row], pla: plaNameArr[indexPath.row])
        } else {
            cell.setUpUI_name(name: nameArr[indexPath.row], pla: plaNameArr[indexPath.row])
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            return ip7(90);
    }
    
    override func navigationLeftBtnClick() {
         self.SVdismiss()
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
