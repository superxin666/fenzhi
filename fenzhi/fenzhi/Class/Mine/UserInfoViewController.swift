//
//  UserInfoViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/10.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let HEARTCELLID_USERINFO = "HEARTCELL_USERINFO_ID"//
let TEACHCELLID_USERINFO = "TEACHCELL__USERINFO_ID"//
class UserInfoViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var userId:Int!
    
    let mainTabelView : UITableView = UITableView()
    let topBackView : UserInfoHeadView = UserInfoHeadView()
    
    let dataVC : MineDataManger = MineDataManger()
    var headDataModel : ProfileMineModel = ProfileMineModel()

    let requestVC : CommonDataMangerViewController = CommonDataMangerViewController()
    var dataModel : GetmyfeedlistModel = GetmyfeedlistModel()
    var dataArr : [GetmyfeedlistModel_data_fenxList] = []
    
    var alertController : UIAlertController!
    
    var page :Int = 1
    let count : Int = 10
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }
    override func viewDidLoad() {

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.view.backgroundColor = backView_COLOUR
        self.navigation_title_fontsize(name: "用户详情", fontsize: 27)
        self.navigationBar_leftBtn()
//        self.creatTableView()
        self.creatTopView()
        self.getHeadData()
    }
    
    override func navigationLeftBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y: topBackView.frame.maxY + ip7(10), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - topBackView.frame.maxY - ip7(10))
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        footer.setRefreshingTarget(self, refreshingAction: #selector(RecordViewController.loadMoreData))
        header.setRefreshingTarget(self, refreshingAction: #selector(RecordViewController.freshData))
        mainTabelView.mj_footer = footer
        mainTabelView.mj_header = header
        mainTabelView.register(UserInfoHeartTableViewCell.self, forCellReuseIdentifier: HEARTCELLID_USERINFO)
        mainTabelView.register(UserInfoShareTableViewCell.self, forCellReuseIdentifier: TEACHCELLID_USERINFO)
        self.view.addSubview(mainTabelView)
        
    }
    
    func getHeadData() {
        weak var weakSelf = self
        dataVC.other_user_profile(userId: userId!,completion: { (data) in
            weakSelf?.headDataModel = data as! ProfileMineModel
            if weakSelf?.headDataModel.errno == 0 {
                weakSelf?.headViewSetData()
                weakSelf?.creatTableView()
                weakSelf?.getData()
            }
        }) { (erro) in
            
        }
    }
    
    func headViewSetData() {
        topBackView.setUpData(model: headDataModel.data)
    }
    
    func creatTopView() {
        topBackView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(382+60))
        topBackView.creatHeadView(type: .other)

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
    //MARK:数据请求
    func loadMoreData() {
        page = page + 1
        self.getData()
    }
    
    func freshData() {
        page = 1
        self.dataArr.removeAll()
        self.getData()
    }
    
 func getData() {
        weak var weakSelf = self
        self.SVshowLoad()
        requestVC.getmyfeedlist(userId: userId!, pageNum: page, count: count, completion: { (data) in
            self.SVdismiss()
            weakSelf?.dataModel = data as! GetmyfeedlistModel
            if weakSelf?.dataModel.errno == 0 {
                if (weakSelf?.dataModel.data.fenxList.count)! > 0{
                    for model in (weakSelf?.dataModel.data.fenxList)!{
//                        model.type = 1
                        KFBLog(message: model.content)
                        weakSelf?.getSize(model: model)
                    }
                    KFBLog(message: "数组")
                    weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.fenxList)!
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
            weakSelf?.mainTabelView.mj_header.endRefreshing()

        }) { (erro) in
                weakSelf?.SVshowErro(infoStr: "网络请求失败")
                weakSelf?.mainTabelView.mj_header.endRefreshing()
                weakSelf?.mainTabelView.mj_footer.endRefreshing()

        }
    }

    
    
    func getSize(model : GetmyfeedlistModel_data_fenxList) {
        var headViewHeight = ip7(160+20)
        //文字
        let str = model.content
        let txtW = KSCREEN_WIDTH - ip7(50)
        var txtH :CGFloat = str.getLabHeight(font: fzFont_Thin(ip7(21)), LabelWidth: txtW)
        if txtH > ip7(21) * 4 {
            txtH = ip7(21) * 4
        }
        
        headViewHeight = headViewHeight + txtH
        if model.type == 0 {
            //教学
            if model.coursewares.count > 0 {
                headViewHeight = headViewHeight +  (ip7(80) * CGFloat(model.coursewares.count))
            }
        } else {
            //心得
            if model.images.count > 0 {
                let imageWidth = (KSCREEN_WIDTH - ip7(60) - ip7(20))/2
                let imageHeight = imageWidth * 355/428
                let num = CGFloat((model.images.count/2)) + CGFloat(model.images.count%2)
                headViewHeight = headViewHeight +  ((imageHeight + ip7(20)) * num)
            }
        }
        
        if model.catalog.characters.count > 0 {
            headViewHeight = headViewHeight + ip7(35) + ip7(21)
        }
        model.cellHeight = headViewHeight
    }
    
    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.dataArr.count {
            let model : GetmyfeedlistModel_data_fenxList = self.dataArr[indexPath.row]
            model.indexRow = indexPath.row
            if model.type == 0 {
                //教学
//                var cell : UserInfoShareTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: TEACHCELLID_USERINFO, for: indexPath) as! UserInfoShareTableViewCell
//
//                if (cell == nil)  {
//                    cell = UserInfoShareTableViewCell(style: .default, reuseIdentifier: TEACHCELLID_USERINFO)
//                }
                let  cell = UserInfoShareTableViewCell(style: .default, reuseIdentifier: TEACHCELLID_USERINFO)
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.setUpUIWithModelAndType(model: model)
                return cell;
            } else {
//                //心得
//                var cell : UserInfoHeartTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: HEARTCELLID_USERINFO, for: indexPath) as! UserInfoHeartTableViewCell
//
//                if (cell == nil)  {
//                    cell = UserInfoHeartTableViewCell(style: .default, reuseIdentifier: HEARTCELLID_USERINFO)
//                }
                let cell = UserInfoHeartTableViewCell(style: .default, reuseIdentifier: HEARTCELLID_USERINFO)
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.setUpUIWithModelAndType(model: model)
                return cell;
            }
        } else {
            return UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return topBackView;
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.dataArr.count {
            let model : GetmyfeedlistModel_data_fenxList = self.dataArr[indexPath.row]
            let vc = TeachDetailViewController()
            vc.fenxId = model.id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let model = self.dataArr[indexPath.row]
        return model.cellHeight;
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return ip7(382)
//    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
