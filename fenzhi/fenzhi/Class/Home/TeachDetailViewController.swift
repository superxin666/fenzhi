//
//  TeachDetailViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/19.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class TeachDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let mainTabelView : UITableView = UITableView()
    let dataVC = HomeDataMangerController()
    var headData : TeachDetailModel = TeachDetailModel()
    var headViewHeight : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        self.navigation_title_fontsize(name: "教学分享详情", fontsize: 27)
        self.navigationBar_leftBtn()
        self.getHeadData()
    }

    func getHeadData() {
        weak var weakSelf = self
        self.SVshowLoad()
        dataVC.profile(fenxId: 1, completion: { (data) in
            weakSelf?.SVdismiss()
            weakSelf?.headData = data as! TeachDetailModel
            if weakSelf?.headData.errno == 0 {
                self.getSize()
                weakSelf?.cgreatHeadView()
            } else {
                weakSelf?.SVshowErro(infoStr: (weakSelf?.headData.errmsg)!)

            }

        }) { (erro) in
                weakSelf?.SVshowErro(infoStr: "请求失败")
        }
    }

    func cgreatHeadView() {
        let headView : TeachDetailHeadView = TeachDetailHeadView(frame: CGRect(x: 0, y:LNAVIGATION_HEIGHT + ip7(20), width: KSCREEN_WIDTH, height: headViewHeight))
        headView.setUpUIWithModelAndType(model: self.headData, height: self.headViewHeight)
        self.view.addSubview(headView)

    }

    func getSize() {
        headViewHeight = ip7(380)
        //文字
        let str = self.headData.data.content
        let txtW = KSCREEN_WIDTH - ip7(50)
        var txtH :CGFloat = str.getLabHeight(font: fzFont_Thin(ip7(21)), LabelWidth: txtW)
        if txtH > ip7(21) * 4 {
            txtH = ip7(21) * 4
        }

        headViewHeight = headViewHeight + txtH

        //教学
        if self.headData.data.coursewares.count > 0 {
          headViewHeight = headViewHeight +  (ip7(80) * CGFloat(self.headData.data.coursewares.count))
        }

        if self.headData.data.catalog.characters.count > 0 {
            headViewHeight = headViewHeight + ip7(35) + ip7(21)
        }

        if self.headData.data.zanUsers.count > 0 {
            let userNum = self.headData.data.zanUsers.count
            var backViewNum = userNum / 8
            if (backViewNum % 8 > 0) {
                backViewNum = userNum / 8 + 1
            }
            let viewWidth  = KSCREEN_WIDTH - ip7(30) * 2
            let imageWidth = (viewWidth - ip7(10) * 7)/8
            headViewHeight = headViewHeight + ip7(29) + (imageWidth * CGFloat(backViewNum))
        }
    }

    //MARK:tableView
    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y:LNAVIGATION_HEIGHT +  ip7(20), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(20) - LNAVIGATION_HEIGHT)
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(HeartTableViewCell.self, forCellReuseIdentifier: HEARTCELLID)
        mainTabelView.register(TeachTableViewCell.self, forCellReuseIdentifier: TEACHCELLID)
        self.view.addSubview(mainTabelView)
    }

    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : TeachTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: TEACHCELLID, for: indexPath) as! TeachTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if (cell == nil)  {
            cell = TeachTableViewCell(style: .default, reuseIdentifier: TEACHCELLID)
        }
        cell.setUpUIWithModelAndType(cellType: .home_Teach)
        return cell;

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return ip7(700);
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
