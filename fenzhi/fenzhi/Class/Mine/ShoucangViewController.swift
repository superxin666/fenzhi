//
//  ShoucangViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let SHOUCANGELLID = "SHOUCANG_ID"//
let ZANGSHANGELLID = "ZANGSHANG_ID"//
enum VCType_SHOUCANG{
    case shoucang_vc
    case zanshang_vc
}
class ShoucangViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {

    var vctype :VCType_SHOUCANG!
    var dataModel : GetzanlistModel = GetzanlistModel()//
    let requestVC = MineDataManger()
    var dataArr : [GetzanlistModel_data_list] = []

    var page :Int = 1
    let count : Int = 10
    var isShow :Bool = false




    let mainTabelView : UITableView = UITableView()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.creatTableView()
        if vctype == .shoucang_vc {
            self.navigation_title_fontsize(name: "我的收藏", fontsize: 27)
            self.getData()
        } else {
            self.navigation_title_fontsize(name: "我的赞赏", fontsize: 27)
            self.getzanData()
        }



    }

    func getzanData()  {
        weak var weakSelf = self
        //        self.SVshowLoad()
        requestVC.getzanlistlist(pageNum: page, count: 10, completion: { (data) in
            //            weakSelf?.SVdismiss()
            weakSelf?.dataModel = data as! GetzanlistModel
            if weakSelf?.dataModel.errno == 0 {
                //修改成功
                if (weakSelf?.dataModel.data.zanList.count)! > 0{
                    KFBLog(message: "数组")
                    weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.zanList)!
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
        requestVC.getfavoritelist(pageNum: page, count: 10, completion: { (data) in
            //            weakSelf?.SVdismiss()
            weakSelf?.dataModel = data as! GetzanlistModel
            if weakSelf?.dataModel.errno == 0 {
                //修改成功
                if (weakSelf?.dataModel.data.favoriteList.count)! > 0{
                    KFBLog(message: "数组")
                    weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.favoriteList)!
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
        mainTabelView.backgroundColor = UIColor.white
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(ShoucangTableViewCell.self, forCellReuseIdentifier: SHOUCANGELLID)
        mainTabelView.register(ZanshangTableViewCell.self, forCellReuseIdentifier: ZANGSHANGELLID)
        mainTabelView.mj_footer = footer
        footer.setRefreshingTarget(self, refreshingAction: #selector(ShoucangViewController.loadMoreData))
        self.view.addSubview(mainTabelView)

    }
    func loadMoreData() {
        page = page + 1
        if vctype == .shoucang_vc {
            self.getData()
        } else {
            self.getzanData()
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

        if vctype == .shoucang_vc {
            var cell : ShoucangTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: SHOUCANGELLID, for: indexPath) as! ShoucangTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if (cell == nil)  {
                cell = ShoucangTableViewCell(style: .default, reuseIdentifier: SHOUCANGELLID)
            }
            if indexPath.row < self.dataArr.count {
                cell.setUpUIWithModel_cellType(model: self.dataArr[indexPath.row])
            }
            return cell;
        } else {
            var cell : ZanshangTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: ZANGSHANGELLID, for: indexPath) as! ZanshangTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if (cell == nil)  {
                cell = ZanshangTableViewCell(style: .default, reuseIdentifier: ZANGSHANGELLID)
            }
            if indexPath.row < self.dataArr.count {
                cell.setUpUIWithModel_cellType(model: self.dataArr[indexPath.row])
            }
            return cell;
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.dataArr.count {
            let model : GetzanlistModel_data_list = self.dataArr[indexPath.row]
            let vc = TeachDetailViewController()
            vc.fenxId = model.fenxId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if vctype == .shoucang_vc {
            return ip7(95);
        } else {
            return ip7(155);
        }

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func navigationLeftBtnClick() {
        self.SVdismiss()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
