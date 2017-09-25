//
//  RecordViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let HEARTCELLID_RECORD = "HEARTCELL_RECORD_ID"//
let TEACHCELLID_RECORD = "TEACHCELL__RECORD_ID"//
class RecordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let mainTabelView : UITableView = UITableView()
    let dataVC : CommonDataMangerViewController = CommonDataMangerViewController()
    var dataModel : GetmyfeedlistModel = GetmyfeedlistModel()
    var dataArr : [GetmyfeedlistModel_data_fenxList] = []

    var alertController : UIAlertController!

    var page :Int = 1
    let count : Int = 10
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.SVdismiss()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        self.navigation_title_fontsize(name: "记录", fontsize: 27)
        self.creatTableView()
        self.getData()
    }

    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y: ip7(20), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(20))
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
        mainTabelView.register(RecordHeartTableViewCell.self, forCellReuseIdentifier: HEARTCELLID_RECORD)
        mainTabelView.register(RecordTableViewCell.self.self, forCellReuseIdentifier: TEACHCELLID_RECORD)
        self.view.addSubview(mainTabelView)
        
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
        dataVC.getmyfeedlist(userId: 0, pageNum: page, count: count, completion: { (data) in
            self.SVdismiss()
            weakSelf?.dataModel = data as! GetmyfeedlistModel
            if weakSelf?.dataModel.errno == 0 {
                if (weakSelf?.dataModel.data.fenxList.count)! > 0{
                    for model in (weakSelf?.dataModel.data.fenxList)!{
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
        var headViewHeight = ip7(245)
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
                var cell : RecordTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: TEACHCELLID_RECORD, for: indexPath) as! RecordTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                if (cell == nil)  {
                    cell = RecordTableViewCell(style: .default, reuseIdentifier: HEARTCELLID)
                }
                cell.setUpUIWithModelAndType(model: model)
                weak var weakSelf = self
                cell.delViewBlock = {(delmodel) in
                    KFBLog(message: "删除block")
                    weakSelf?.alertController  = UIAlertController(title: "提示", message: "是否要删除本条分享", preferredStyle: .alert)
                    let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                        //取消
                        weakSelf?.alertController.dismiss(animated: true, completion: {

                        })
                    }
                    let sureAction = UIAlertAction(title: "删除", style: .default) { (action) in
                        //删除
                        self.SVshowLoad()
                        weakSelf?.dataVC.delfenx(fenxId: delmodel.id, completion: { (data) in
                            weakSelf?.SVdismiss()
                            let model :SmsModel = data as! SmsModel
                            if model.errno == 0 {
                                weakSelf?.SVshowSucess(infoStr: "删除成功")
                                weakSelf?.dataArr.remove(at: delmodel.indexRow)
                                weakSelf?.mainTabelView.reloadData()
                            } else {
                                weakSelf?.SVshowErro(infoStr: model.errmsg)
                            }
                        }, failure: { (erro) in
                            weakSelf?.SVshowErro(infoStr: "网络请求失败")
                        })

                    }

                    weakSelf?.alertController.addAction(cancleAction)
                    weakSelf?.alertController.addAction(sureAction)
                    self.present((weakSelf?.alertController)!, animated: true, completion: nil)
                    

                }
                return cell;
            } else {
                //心得
                var cell : RecordHeartTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: HEARTCELLID_RECORD, for: indexPath) as! RecordHeartTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                if (cell == nil)  {
                    cell = RecordHeartTableViewCell(style: .default, reuseIdentifier: HEARTCELLID_RECORD)
                }
                cell.setUpUIWithModelAndType(model: model)
                return cell;
            }
        } else {
            return UITableViewCell()
        }
    }

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
