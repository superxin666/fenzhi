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
    var dataModel : LoginModelMapper = LoginModelMapper()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        requestVC.info(completion: { (data) in
            weakSelf?.dataModel = data as! LoginModelMapper
            if weakSelf?.dataModel.errno == 0 {
                weakSelf?.headViewSetData()
            }
        }) { (erro) in

        }
    }

    func headViewSetData() {
        topBackView.setUpData(model: dataModel.data)

    }

    
    func creatTopView() {
        topBackView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(382))
        topBackView.creatHeadView()
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
            return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : MainTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: MAINELLID, for: indexPath) as! MainTableViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        if (cell == nil)  {
            cell = MainTableViewCell(style: .default, reuseIdentifier: HEARTCELLID)
        }
        cell.setUpUIWith(name: cellNameArr[indexPath.row], image: cellIconNameArr[indexPath.row], index : indexPath.row)
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
            
        } else if indexPath.row == 1 {
            //shoucang
            let vc : ShoucangViewController = ShoucangViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.vctype = .shoucang_vc
            self.navigationController?.pushViewController(vc, animated: true)

        } else if indexPath.row == 2{
            let vc : ShoucangViewController = ShoucangViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.vctype = .zanshang_vc
            self.navigationController?.pushViewController(vc, animated: true)


        } else if indexPath.row == 3{
        
        
        } else {
            let vc : SettingViewController = SettingViewController()
    
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
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
