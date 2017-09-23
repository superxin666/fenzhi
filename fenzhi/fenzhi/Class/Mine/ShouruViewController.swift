//
//  ShouruViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/18.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let SHOURUELLID = "SGOURU_ID"//
class ShouruViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var dataModel : GetincomelistModl = GetincomelistModl()//
    let requestVC = MineDataManger()
    var dataArr : [GetincomelistModl_data_incomeList] = []

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
        self.navigation_title_fontsize(name: "我的收入", fontsize: 27)
        self.getData()
        
        
    }

    func getData()  {
        weak var weakSelf = self
        //        self.SVshowLoad()
        requestVC.getgetincomelist(pageNum: page, count: 10, completion: { (data) in
            //            weakSelf?.SVdismiss()
            weakSelf?.dataModel = data as! GetincomelistModl
            if weakSelf?.dataModel.errno == 0 {
                //修改成功
                if (weakSelf?.dataModel.data.incomeList.count)! > 0{
                    KFBLog(message: "数组")
                    weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.incomeList)!
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

        mainTabelView.register(ShouruTableViewCell.self, forCellReuseIdentifier: SHOURUELLID)
        mainTabelView.mj_footer = footer
        footer.setRefreshingTarget(self, refreshingAction: #selector(ShouruViewController.loadMoreData))
        self.view.addSubview(mainTabelView)

    }
    func loadMoreData() {
        page = page + 1
        self.getData()


    }

    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell : ShouruTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: SHOURUELLID, for: indexPath) as! ShouruTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if (cell == nil)  {
            cell = ShouruTableViewCell(style: .default, reuseIdentifier: SHOURUELLID)
        }
        if indexPath.row < self.dataArr.count {
            cell.setUpUIWithModel_cellType(model: self.dataArr[indexPath.row])
        }
        return cell;

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  view = ShouruHeadView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(140)))
        view.backgroundColor = backView_COLOUR
        view.setUpUIWithModel_cellType()
        return view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            return ip7(155)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return ip7(140)
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
