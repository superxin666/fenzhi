//
//  XiaoxiViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/29.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class XiaoxiViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    let leftBtn : UIButton = UIButton()
    let rightBtn : UIButton = UIButton()

    var dataModel : GetmessagelistLikeModel = GetmessagelistLikeModel()//
    let requestVC = MineDataManger()
    var dataArr : [GetmessagelistLikeModel_data_messageList] = []
    let mainTabelView : UITableView = UITableView()
    let topBaclView : UIView = UIView()
    var page :Int = 1
    let count : Int = 10

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
        self.navigation_title_fontsize(name: "我的消息", fontsize: 27)
        self.creatTopView()
        self.creatTableView()
        self.getData()

    }

    func getData()  {
        weak var weakSelf = self
                self.SVshowLoad()
        requestVC.getmessagelist(typeStr : "like",pageNum: page, count: 10, completion: { (data) in
                        weakSelf?.SVdismiss()
            weakSelf?.dataModel = data as! GetmessagelistLikeModel
            if weakSelf?.dataModel.errno == 0 {
                //修改成功
                if (weakSelf?.dataModel.data.messageList.count)! > 0{
                    KFBLog(message: "数组")
                    weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.messageList)!
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

    //MARK:头部
    func creatTopView() {
        topBaclView.frame = CGRect(x: 0, y:  5, width: KSCREEN_WIDTH, height: ip7(65))
        topBaclView.backgroundColor = .white
        self.view.addSubview(topBaclView)

        leftBtn.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH/2, height: ip7(65)) 
        leftBtn.setTitle("点赞", for: .normal)
        leftBtn.setTitleColor(dark_3_COLOUR, for: .normal)
        leftBtn.titleLabel?.font = fzFont_Thin(ip7(24))
        leftBtn.backgroundColor = .clear
        topBaclView.addSubview(leftBtn)
//        leftBtn.addTarget(self, action:#selector(HomeViewController.teachBtnClik), for: .touchUpInside)

        rightBtn.frame = CGRect(x:  KSCREEN_WIDTH/2, y: 0, width: KSCREEN_WIDTH/2, height: ip7(65))
        rightBtn.setTitle("评论", for: .normal)
        rightBtn.setTitleColor(dark_3_COLOUR, for: .normal)
        rightBtn.titleLabel?.font = fzFont_Thin(ip7(24))
        rightBtn.backgroundColor = .clear
        topBaclView.addSubview(rightBtn)
        //        leftBtn.addTarget(self, action:#selector(HomeViewController.teachBtnClik), for: .touchUpInside)

    }
    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y: topBaclView.frame.maxY + ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(15))
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

//        var cell : ShouruTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: SHOURUELLID, for: indexPath) as! ShouruTableViewCell
//
//        if (cell == nil)  {
//            cell = ShouruTableViewCell(style: .default, reuseIdentifier: SHOURUELLID)
//        }
        let cell = DianzanTableViewCell(style: .default, reuseIdentifier: "DIANZANCELLIS")
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row < self.dataArr.count {
            cell.setUpUIWithModel_cellType(model: self.dataArr[indexPath.row])
        }
        weak var weakSelf = self
        cell.iconImageViewBlock = {(click_model) in
            let vc = UserInfoViewController()
            vc.userId  = click_model.userInfo.userId
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell;

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return ip7(188/2)
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
