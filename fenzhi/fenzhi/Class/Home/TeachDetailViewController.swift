//
//  TeachDetailViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/19.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let COMMONTELLID = "COMMONTELL_ID"//
class TeachDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let mainTabelView : UITableView = UITableView()
    let dataVC = HomeDataMangerController()
    var headData : TeachDetailModel = TeachDetailModel()
    var commentlistData : GetcommentlistModel = GetcommentlistModel()
    let headView : TeachDetailHeadView =  TeachDetailHeadView()
    var headViewHeight : CGFloat = 0.0
    var sectionNum = 1
    var hotArr : [GetcommentlistModel_data_list_commentList] = []
    var otherArr : [GetcommentlistModel_data_list_commentList] = []
    var newArr : [GetcommentlistModel_data_list_commentList] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        self.navigation_title_fontsize(name: "教学分享详情", fontsize: 27)
        self.navigationBar_leftBtn()
        self.getHeadData()
//        self.getcommentlistData()
    }

    //MARK:获取分享头部数据
    func getHeadData() {
        weak var weakSelf = self
        self.SVshowLoad()
        dataVC.profile(fenxId: 1, completion: { (data) in
            weakSelf?.SVdismiss()
            weakSelf?.headData = data as! TeachDetailModel
            if weakSelf?.headData.errno == 0 {
                weakSelf?.getSize()
                weakSelf?.cgreatHeadView()
                weakSelf?.getcommentlistData()
            } else {
                weakSelf?.SVshowErro(infoStr: (weakSelf?.headData.errmsg)!)

            }

        }) { (erro) in
                weakSelf?.SVshowErro(infoStr: "请求失败")
        }
    }

    func cgreatHeadView() {
        headView.frame = CGRect(x: 0, y:LNAVIGATION_HEIGHT + ip7(20), width: KSCREEN_WIDTH, height: headViewHeight)
        headView.setUpUIWithModelAndType(model: self.headData, height: self.headViewHeight)
        self.view.addSubview(headView)

    }
    //MARK:获取分享头部尺寸
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

    //MARK:获取评论列表数据
    func getcommentlistData() {
        weak var weakSelf = self
        dataVC.getcommentlist(fenxId: 1, pageNum: 1, count: 10, completion: { (data) in
            weakSelf?.commentlistData = data as! GetcommentlistModel
            if weakSelf?.commentlistData.errno == 0 {
                weakSelf?.getTabelViewSectionNum()
                if weakSelf?.sectionNum == 2 {
                    //1最热评论+其他评论
                    weakSelf?.hotArr = (weakSelf?.commentlistData.data.list[0].commentList)!
                    for model in (weakSelf?.hotArr)! {
                        weakSelf?.getCommentCellHeight(model: model)
                    }
                    weakSelf?.otherArr = (weakSelf?.commentlistData.data.list[1].commentList)!
                    for model in (weakSelf?.otherArr)! {
                        weakSelf?.getCommentCellHeight(model: model)
                    }
                } else  {
                   //1 最新评论
                    weakSelf?.newArr = (weakSelf?.commentlistData.data.list[0].commentList)!
                    for model in (weakSelf?.newArr)! {
                        weakSelf?.getCommentCellHeight(model: model)
                    }
                }

                weakSelf?.creatTableView()
            } else {

                weakSelf?.SVshowErro(infoStr: (weakSelf?.headData.errmsg)!)
            }

        }) { (erro) in
               weakSelf?.SVshowErro(infoStr: "请求失败")
        }

    }

    func getTabelViewSectionNum() {
        var num = 0
        for model in self.commentlistData.data.list {
            KFBLog(message: model.title)
            if model.title != "" {
                num = num + 1
            }
        }
        if num > 1 {
            sectionNum = 2
        } else {
            sectionNum = 1
        }
        KFBLog(message: (sectionNum))
    }

    func getCommentCellHeight(model : GetcommentlistModel_data_list_commentList) {
        let str = model.content
        let txtW = KSCREEN_WIDTH - ip7(25) - ip7(60) - ip7(25) - ip7(50)
        let txtH :CGFloat = str.getLabHeight(font: fzFont_Thin(ip7(21)), LabelWidth: txtW)
        var heiht = ip7(140) + txtH
        if model.toCommentInfo.content.characters.count > 0 {
            heiht = heiht + ip7(78)
        }
        heiht = heiht  + ip7(44)
        model.cellHeight = heiht
    }


    //MARK:tableView
    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y:headView.frame.maxY, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - headView.frame.maxY)
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(commentTableViewCell.self, forCellReuseIdentifier: COMMONTELLID)
        self.view.addSubview(mainTabelView)
    }

    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionNum == 2 {
            if  section == 0{
                return self.hotArr.count
            } else {
                return self.otherArr.count

            }
        } else {
            return self.newArr.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : commentTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: COMMONTELLID, for: indexPath) as! commentTableViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        if (cell == nil)  {
            cell = commentTableViewCell(style: .default, reuseIdentifier: COMMONTELLID)
        }
     
        var model : GetcommentlistModel_data_list_commentList = GetcommentlistModel_data_list_commentList()
        if sectionNum == 2 {
            if  indexPath.section == 0{
                model = self.hotArr[indexPath.row]
            } else {
                model = self.otherArr[indexPath.row]
            }
        } else {
                model = self.newArr[indexPath.row]
        }
        cell.setUpUIWithModel_cellType(model: model)
        return cell;

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view : UIView = UIView()
        let nameLabel : UILabel = UILabel(frame: CGRect(x: ip7(30), y: (ip7(136/2) - ip7(21))/2, width: KSCREEN_WIDTH - ip7(30), height: ip7(21)))
        nameLabel.font = fzFont_Thin(ip7(21))
        nameLabel.textColor = dark_3_COLOUR
        view.addSubview(nameLabel)

        if sectionNum == 2 {
            //两组
            if section == 0 {
                 let str = self.commentlistData.data.list[0].title
                 nameLabel.text = str
            } else {
                let str = self.commentlistData.data.list[1].title
                nameLabel.text = str
            }

        } else {
            //一组
            nameLabel.text = "最新评论"
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ip7(136/2)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if sectionNum == 2 {
            if  indexPath.section == 0{
                let model = self.hotArr[indexPath.row]
                return model.cellHeight
            } else {
                let model = self.otherArr[indexPath.row]
                return model.cellHeight
            }
        } else {
            let model = self.newArr[indexPath.row]
            return model.cellHeight
        }
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
