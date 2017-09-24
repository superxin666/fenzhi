//
//  RecordViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class RecordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let mainTabelView : UITableView = UITableView()
    let dataVC : CommonDataMangerViewController = CommonDataMangerViewController()
    var dataModel : GetmyfeedlistModel = GetmyfeedlistModel()
    var dataArr : [GetmyfeedlistModel_data_fenxList] = []



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
//        mainTabelView.register(RecordTableViewCell.self, forCellReuseIdentifier: HEARTCELLID)
        mainTabelView.register(RecordTableViewCell.self.self, forCellReuseIdentifier: TEACHCELLID)
        self.view.addSubview(mainTabelView)
        
    }

    func loadMoreData() {

    }

    func getData() {
        weak var weakSelf = self
        dataVC.getmyfeedlist(userId: 0, pageNum: 1, count: 10, completion: { (data) in
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

        }) { (erro) in
                weakSelf?.SVshowErro(infoStr: "网络请求失败")
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
        //教学
        if model.coursewares.count > 0 {
            headViewHeight = headViewHeight +  (ip7(80) * CGFloat(model.coursewares.count))
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
            if model.type == 0 {
                //教学
                var cell : RecordTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: TEACHCELLID, for: indexPath) as! RecordTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                if (cell == nil)  {
                    cell = RecordTableViewCell(style: .default, reuseIdentifier: HEARTCELLID)
                }
                cell.setUpUIWithModelAndType(model: model)
                return cell;
            } else {
                //心得
                let cell = UITableViewCell()
                return cell
            }
        } else {
            return UITableViewCell()
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
