//
//  MineViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let MAINELLID = "HEARTCELL_ID"//
class MineViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    let mainTabelView : UITableView = UITableView()
    let topBackView : UserInfoHeadView = UserInfoHeadView()
    let cellNameArr = ["我的消息","我的收藏","我的赞赏","我的收入","设置"]
    let cellIconNameArr = [#imageLiteral(resourceName: "icon_wdxx"),#imageLiteral(resourceName: "icon_wdsc"),#imageLiteral(resourceName: "icon_wdzs"),#imageLiteral(resourceName: "icon_wdsr"),#imageLiteral(resourceName: "icon_sz")]
    let requestVC = MineDataManger()
    var dataModel : ProfileMineModel = ProfileMineModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.getData()
    }

 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        self.creatTopView()
        self.creatTableView()
        
    }

    func getData() {
        weak var weakSelf = self
        requestVC.my_user_profile(completion: { (data) in
            weakSelf?.dataModel = data as! ProfileMineModel
            if weakSelf?.dataModel.errno == 0 {
                weakSelf?.headViewSetData()
                self.getNoRedMessage()
                self.mainTabelView.reloadData()
            }
        }) { (erro) in

        }
    }

    func headViewSetData() {
        topBackView.setUpData(model: dataModel.data)

    }
    
    func getNoRedMessage() {
        //去除tab红点
//        let appdel = AppDelegate()

        if !(self.dataModel.data.notify.like == 1) && !(self.dataModel.data.notify.comment == 1) && !(self.dataModel.data.notify.zan == 1){
            KFBLog(message: "不展示")

//            appdel.hideRed()
            self.tabBarController?.tabBar.hideBadgeOnItemIndex(index: 3)
            
        } else {
            KFBLog(message: "展示")
//            appdel.showRed()
            self.tabBarController?.tabBar.showBadgeOnItemIndex(index: 3)

        }
    }

    func creatTopView() {

        let height = iPhoneX ? ip7(392+24):ip7(392)
        topBackView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: height)
        topBackView.creatHeadView(type: .main)
        topBackView.isUserInteractionEnabled = true
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.top_click))
        topBackView.addGestureRecognizer(tap)
        
        topBackView.guanzhuViewBlock = { () in
            let vc :GunzhuViewController = GunzhuViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.vctype = .guanzhu_vc
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        topBackView.fensiViewBlock = { () in
            KFBLog(message: "点击")
            let vc :GunzhuViewController = GunzhuViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.vctype = .fensi_vc
            self.navigationController?.pushViewController(vc, animated: true)

        }

        self.view.addSubview(topBackView)
        
    }
    
    func top_click() {
        let vc = SettingViewController()
        vc.dataModel = self.dataModel
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
   
    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y: topBackView.frame.maxY + ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - topBackView.frame.maxY - ip7(15))
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(MainTableViewCell.self, forCellReuseIdentifier: MAINELLID)
        self.view.addSubview(mainTabelView)

    }

    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.dataModel.userInfo.payHide = 0
        if let payHide =  self.dataModel.userInfo.payHide {
            if payHide == 1 {
                return 2
            } else {
                return 5
            }
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : MainTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: MAINELLID, for: indexPath) as! MainTableViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        if (cell == nil)  {
            cell = MainTableViewCell(style: .default, reuseIdentifier: HEARTCELLID)
        }
        cell.setUpUIWith(name: cellNameArr[indexPath.row], image: cellIconNameArr[indexPath.row], index : indexPath.row)
        
        if indexPath.row == 0 {
            //我的消息
            KFBLog(message: "like --\(self.dataModel.data.notify.like)")
            KFBLog(message: "comment --\(self.dataModel.data.notify.comment)")

            if self.dataModel.data.notify.like == 1 ||  self.dataModel.data.notify.comment == 1  {
                cell.setRedView(isRed: 1)
            }

        } else if indexPath.row == 3 {
            //收入
            KFBLog(message: "zan --\(self.dataModel.data.notify.zan)")

            cell.setRedView(isRed: self.dataModel.data.notify.zan)

        }
        return cell;


    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 3 {
            return ip7(95);
        } else {
            return ip7(80);
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc : XiaoxiViewController = XiaoxiViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
            
        } else if indexPath.row == 1 {
            //shoucang
            let vc : ShoucangViewController = ShoucangViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.vctype = .shoucang_vc
            self.navigationController?.pushViewController(vc, animated: false)

        } else if indexPath.row == 2{
            let vc : ShoucangViewController = ShoucangViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.vctype = .zanshang_vc
            self.navigationController?.pushViewController(vc, animated: false)


        } else if indexPath.row == 3{
            let vc : ShouruViewController = ShouruViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        
        } else {
            let vc : ShezhiViewController = ShezhiViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
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
