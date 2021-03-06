//
//  GunzhuOtherViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/29.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit



let GUANZHU_OtherELLID = "GUANZHUCELL_ID"//
enum VCType_GUZNHU_Other {
    case guanzhu_vc
    case fensi_vc
}
class GunzhuOtherViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var vctype :VCType_GUZNHU_Other!
    var dataModel : FollowModel = FollowModel()//
    let requestVC = MineDataManger()
    var dataArr : [FollowModel_data_list] = []
    
    var page :Int = 1
    let count : Int = 10
    var isShow :Bool = false
    var userId : Int!
    
    
    
    let mainTabelView : UITableView = UITableView()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.creatTableView()
        if vctype == .guanzhu_vc {
            self.navigation_title_fontsize(name: "关注", fontsize: 27)
            self.getData()
        } else {
            self.navigation_title_fontsize(name: "粉丝", fontsize: 27)
            self.getFensiData()
        }
        
        
        
    }
    
    func getFensiData()  {
        weak var weakSelf = self
        self.SVshowLoad()
        
        requestVC.getfanslist_other(userId:userId,pageNum: page, count: 10, completion: { (data) in
            weakSelf?.SVdismiss()
            weakSelf?.dataModel = data as! FollowModel
            if weakSelf?.dataModel.errno == 0 {
                //修改成功
                if (weakSelf?.dataModel.data.fansList.count)! > 0{
                    KFBLog(message: "数组")
                    weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.fansList)!
                    weakSelf?.mainTabelView.reloadData()
                } else {
                    if weakSelf?.dataArr.count == 0 {
                        weakSelf?.mainTabelView.removeFromSuperview()
                        weakSelf?.view.addSubview(self.showNoData())
                    } else {
                        weakSelf?.SVshowErro(infoStr: "没有数据了")
                    }
                    
                }
                
                
            } else {
                weakSelf?.SVshowErro(infoStr: (weakSelf?.dataModel.errmsg)!)
                
            }
            weakSelf?.mainTabelView.mj_footer.endRefreshing()
            
        }) { (erro) in
            weakSelf?.SVshowErro(infoStr: "请求失败")
        }
    }
    
    func getData()  {
        weak var weakSelf = self
        //        self.SVshowLoad()
        requestVC.getfollowlist_other(userId:userId,pageNum: page, count: 10, completion: { (data) in
            //            weakSelf?.SVdismiss()
            weakSelf?.dataModel = data as! FollowModel
            if weakSelf?.dataModel.errno == 0 {
                //修改成功
                if (weakSelf?.dataModel.data.followList.count)! > 0{
                    KFBLog(message: "数组")
                    weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.followList)!
                    weakSelf?.mainTabelView.reloadData()
                } else {
                    if weakSelf?.dataArr.count == 0 {
                        weakSelf?.mainTabelView.removeFromSuperview()
                        weakSelf?.view.addSubview(self.showNoData())
                    } else {
                        weakSelf?.SVshowErro(infoStr: "没有数据了")
                    }
                    
                }
                
                
            } else {
                weakSelf?.SVshowErro(infoStr: (weakSelf?.dataModel.errmsg)!)
                
            }
            weakSelf?.mainTabelView.mj_footer.endRefreshing()
            
        }) { (erro) in
            weakSelf?.SVshowErro(infoStr: "请求失败")
            
        }
    }
    
    //MARK:tableView
    func creatTableView() {
        self.isShow = true
        mainTabelView.frame = CGRect(x: 0, y: ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(15))
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(GuanzhuTableViewCell.self, forCellReuseIdentifier: GUANZHUELLID)
        mainTabelView.mj_footer = footer
        footer.setRefreshingTarget(self, refreshingAction: #selector(GunzhuViewController.loadMoreData))
        self.view.addSubview(mainTabelView)
        
    }
    func loadMoreData() {
        page = page + 1
        if vctype == .guanzhu_vc {
            self.getData()
        } else {
            self.getFensiData()
        }
        
    }
    
    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell : GuanzhuTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: GUANZHUELLID, for: indexPath) as! GuanzhuTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if (cell == nil)  {
            cell = GuanzhuTableViewCell(style: .default, reuseIdentifier: GUANZHUELLID)
        }
        if indexPath.row < self.dataArr.count {
            cell.setUpUIWithModel_cellType(type: .guanzhu,model:self.dataArr[indexPath.row])
        }
        return cell;
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.dataArr.count {
            let model = self.dataArr[indexPath.row]
            let vc = UserInfoViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.userId = model.userId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return ip7(95);
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
