//
//  SearchViewController.swift
//  fenzhi
//
//  Created by lvxin on 2018/1/9.
//  Copyright © 2018年 Xunqiu. All rights reserved.
//  搜索页面

import UIKit
import QuickLook
let SEARCHUSERCELLID = "SEARCHUSERCELLID_ID"

class SearchViewController: BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    let mainTabelView : UITableView = UITableView()
    var searchBar : UISearchBar!
    var iteamBarBackView : UIView = UIView()
    var lastBtn : UIButton!
    var page = 0
    var queryStr = ""
    
    
    /// 0 是内容 1是资料 2是用户
    var searchType = 0
    
    let dataVC = HomeDataMangerController()
    var dataModel : SearchModel = SearchModel()
    /// 动态 资料
    var dataArr : [Any] = []
    /// 用户 数据
    var userDataArr : [UserInfoModel] = []
    
    let quickLookController = QLPreviewController()
    var qucikModel = GetmyfeedlistModel_data_fenxList()
    var openFileUrl :String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        self.creatSearchBar()
        self.iteamBar()
        self.creatTableView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.


    }
    func creatSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: ip7(20), y: 0, width: KSCREEN_WIDTH - ip7(40), height: ip7(44)))
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        for view in searchBar.subviews[0].subviews {
            KFBLog(message: view.self)
            if view is UIButton {
                let btn : UIButton = view as! UIButton
                btn.setTitle("取消", for: .normal)
                btn.setTitleColor(blue_COLOUR, for: .normal)
            }
        }
        searchBar.placeholder = "搜索 内容 资料 用户"
        searchBar.barStyle = .default
        searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchBar
    }
    
    func iteamBar() {
        let viewHeight  = ip7(66)
        iteamBarBackView.frame = CGRect(x: 0, y: LNAVIGATION_HEIGHT + ip7(20), width: KSCREEN_WIDTH, height: viewHeight)
        iteamBarBackView.backgroundColor = .white
        self.view.addSubview(iteamBarBackView)
        let nameArr = ["内容","资料","用户"]
        
        let btnW = KSCREEN_WIDTH/3
        for i in 0..<3 {
            let stBtn : UIButton = UIButton(frame: CGRect(x:CGFloat(i) * btnW, y: 0, width: btnW, height: viewHeight))
            stBtn.setTitle(nameArr[i], for: .normal)
            stBtn.tag = i
            if i == 0{
                lastBtn = stBtn
                stBtn.isSelected = true
            }
            stBtn.setTitleColor(FZColor(red: 102, green: 102, blue: 102, alpha: 1.0), for: .normal)
            stBtn.setTitleColor(blue_COLOUR, for: .selected)
            stBtn.titleLabel?.font = fzFont_Medium(ip7(21))
            stBtn.backgroundColor = .clear
            stBtn.addTarget(self, action:#selector(SearchViewController.btnClick(sender:)), for: .touchUpInside)
        
            iteamBarBackView.addSubview(stBtn)
            
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: ip7(65), width: KSCREEN_WIDTH, height: 1))
        lineView.backgroundColor = lineView_thin_COLOUR
        iteamBarBackView .addSubview(lineView);
    }
    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y: iteamBarBackView.frame.maxY, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - iteamBarBackView.frame.maxY)
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        footer.setRefreshingTarget(self, refreshingAction: #selector(SearchViewController.loadMoreData))
        //        header.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.freshData))
        mainTabelView.mj_footer = footer
        //        mainTabelView.mj_header = header
        mainTabelView.register(HeartTableViewCell.self, forCellReuseIdentifier: HEARTCELLID)
        mainTabelView.register(TeachTableViewCell.self, forCellReuseIdentifier: TEACHCELLID)
        mainTabelView.register(TeachTableViewCell.self, forCellReuseIdentifier: SEARCHUSERCELLID)
        self.view.addSubview(mainTabelView)

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

        if model.catalog.count > 0 {
            headViewHeight = headViewHeight + ip7(35) + ip7(21)
        }
        model.cellHeight = headViewHeight
    }
    // MARK: net
    func loadMoreData() {
        if !(queryStr.count>0) {

            self.SVshowErro(infoStr: "请输入搜索内容")
            return
        }
        page = page + 1
        self.getData()
    }
    func getData() {
        weak var weakSelf = self
        self.SVshowLoad()
        self.noDataView.removeFromSuperview()
        self.mainTabelView.isHidden = false
        dataVC.searchlist(type: searchType, query: queryStr, pageNum: page, count: 10, completion: { (data) in
            self.SVdismiss()
            weakSelf?.dataModel = data as! SearchModel
            if weakSelf?.dataModel.errno == 0 {
                if (weakSelf?.dataModel.data.fenx.list.count)! > 0 || (weakSelf?.dataModel.data.user.list.count)! > 0{
                    if (weakSelf?.searchType == 0) || (weakSelf?.searchType == 1){
                        for model in (weakSelf?.dataModel.data.fenx.list)!{
                            KFBLog(message: model.content)
                            weakSelf?.getSize(model: model)
                        }
                        KFBLog(message: "数组")
                        weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.fenx.list)!
                    } else {
                        weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.user.list)!
                    }

                    weakSelf?.mainTabelView.reloadData()
                } else {
                    if weakSelf?.dataArr.count == 0 {
                        weakSelf?.mainTabelView.isHidden = true
                        weakSelf?.view.addSubview(self.showNoData(fream: CGRect(x: 0, y: self.iteamBarBackView.frame.maxY, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - self.iteamBarBackView.frame.maxY)))
                    } else {
                        weakSelf?.SVshowErro(infoStr: "没有数据了")
                    }
                }
            } else {
                weakSelf?.SVshowErro(infoStr: (weakSelf?.dataModel.errmsg)!)
            }
            weakSelf?.mainTabelView.mj_footer.endRefreshing()
        }) { (erro) in
            weakSelf?.SVshowErro(infoStr: "网络请求失败")
            //            weakSelf?.mainTabelView.mj_header.endRefreshing()
            weakSelf?.mainTabelView.mj_footer.endRefreshing()
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
        if searchType == 0 ||  searchType == 1{
            //动态
            if indexPath.row < self.dataArr.count {
                let model : GetmyfeedlistModel_data_fenxList = self.dataArr[indexPath.row] as! GetmyfeedlistModel_data_fenxList
                
                if model.type == 0 {
                    //教学
                    //                var cell : TeachTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: TEACHCELLID, for: indexPath) as! TeachTableViewCell
                    //
                    //                if (cell == nil)  {
                    //                    cell = TeachTableViewCell(style: .default, reuseIdentifier: TEACHCELLID)
                    //                }
                    
                    let cell = TeachTableViewCell(style: .default, reuseIdentifier: TEACHCELLID)
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    cell.setUpUIWithModelAndType(model: model)
                    weak var weakSelf = self
                    cell.iconImageViewBlock = {(click_model,indexFile) in
                        let vc = UserInfoViewController()
                        vc.userId  = click_model.userId
                        vc.hidesBottomBarWhenPushed = true
                        weakSelf?.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.detailBlock = {(click_model,indexFile )in
                        let vc = TeachDetailViewController()
                        vc.fenxId = click_model.id
                        vc.hidesBottomBarWhenPushed = true
                        weakSelf?.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    cell.zanshangBlock = {(click_model,indexFile) in
                        let vc = TeachDetailViewController()
                        vc.fenxId = click_model.id
                        vc.isshowzanshang = true
                        vc.hidesBottomBarWhenPushed = true
                        weakSelf?.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.fileBlock = {click_model,indexFile in
                        let urlStr : String = click_model.coursewares[indexFile].file
                        let name : String = click_model.coursewares[indexFile].name.removingPercentEncoding!
                        
                        weakSelf?.dataVC.downLoadFile(path: urlStr,name:name, completion: { (data) in
                            
                            weakSelf?.openFileUrl = data as! String
                            if  (self.openFileUrl.count > 0) {
                                KFBLog(message: "下载成功"+self.openFileUrl)
                                
                                weakSelf?.quickLookController.dataSource = self
                                weakSelf?.quickLookController.delegate = self
                                weakSelf?.quickLookController.hidesBottomBarWhenPushed =  true
                                weakSelf?.quickLookController.reloadData()
                                weakSelf?.quickLookController.navigationController?.navigationItem.leftBarButtonItem = self.getBarIteam()
                                //                                weakSelf?.quickLookController.navigationItem.leftBarButtonItem = self.getBarIteam()
                                weakSelf?.navigationController?.pushViewController((weakSelf?.quickLookController)!, animated: true)
                            } else {
                                KFBLog(message: "加载失败")
                                weakSelf?.SVshowErro(infoStr: "加载失败")
                            }
                        }, failure: { (erro) in
                            
                        })
                        
                    }
                    return cell;
                    
                } else {
                    //心得
                    //                var cell : HeartTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: HEARTCELLID, for: indexPath) as! HeartTableViewCell
                    //
                    //                if (cell == nil)  {
                    //                    cell = HeartTableViewCell(style: .default, reuseIdentifier: HEARTCELLID)
                    //                }
                    
                    let cell = HeartTableViewCell(style: .default, reuseIdentifier: HEARTCELLID)
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    cell.setUpUIWithModel_cellType(model: model)
                    weak var weakSelf = self
                    cell.IconImageViewBlock = {click_model in
                        let vc = UserInfoViewController()
                        vc.userId  = click_model.userId
                        vc.hidesBottomBarWhenPushed = true
                        weakSelf?.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    cell.detailBlock = {click_model in
                        let vc = TeachDetailViewController()
                        vc.fenxId = click_model.id
                        vc.hidesBottomBarWhenPushed = true
                        weakSelf?.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    cell.zanshangBlock = {click_model in
                        let vc = TeachDetailViewController()
                        vc.fenxId = click_model.id
                        vc.isshowzanshang = true
                        vc.hidesBottomBarWhenPushed = true
                        weakSelf?.navigationController?.pushViewController(vc, animated: true)
                    }
                    return cell;
                    
                    
                }
            } else {
                return UITableViewCell()
            }
        } else {
            //用户
            if indexPath.row < self.dataArr.count {
                let model : UserInfoModel = self.dataArr[indexPath.row] as! UserInfoModel

                let cell = SearchTableViewCell(style: .default, reuseIdentifier: SEARCHUSERCELLID)
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.setUpUIWithModel_cellType(model: model)
                weak var weakSelf = self
                cell.iconImageViewBlock = {(click_model) in
                    let vc = UserInfoViewController()
                    vc.userId  = click_model.id
                    vc.hidesBottomBarWhenPushed = true
                    weakSelf?.navigationController?.pushViewController(vc, animated: true)
                }
                return cell

            } else {
                return UITableViewCell()
            }

        }
       
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchType == 2 {

        } else {
            if indexPath.row < self.dataArr.count {
                let model : GetmyfeedlistModel_data_fenxList = self.dataArr[indexPath.row] as! GetmyfeedlistModel_data_fenxList
                let vc = TeachDetailViewController()
                vc.fenxId = model.id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)

            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if self.searchType == 2 {
            return SearchTableViewCellH
        } else {
            let model : GetmyfeedlistModel_data_fenxList = self.dataArr[indexPath.row] as! GetmyfeedlistModel_data_fenxList
            return model.cellHeight;
        }

    }
    
    
    // MARK: searchBarDelegate 代理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        KFBLog(message: "开始所搜")
        searchBar.resignFirstResponder()
        queryStr = searchBar.text!
        self.loadMoreData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        KFBLog(message: "结束输入文字")
        KFBLog(message: searchBar.text)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        KFBLog(message: "搜索取消")
        searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        KFBLog(message: "开始输入文字")
//        searchBar.showsCancelButton = true
//        for view in searchBar.subviews[0].subviews {
//            KFBLog(message: view.self)
//            KFBLog(message: "222")
//            if view is UIButton {
//                KFBLog(message: "1111")
//                let btn : UIButton = view as! UIButton
//                btn.setTitle("取消", for: .normal)
//            }
//        }

    }
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url : NSURL =  NSURL(fileURLWithPath: openFileUrl)
        KFBLog(message: url)
        return url
    }
    // MARK: - event respoonse
    func btnClick(sender:UIButton) {
//        if sender.isSelected {
//            return
//        }

        lastBtn.isSelected = false
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 0 {
            //"内容"
            KFBLog(message: "内容")
            searchType = 0
            page = 0
            if self.dataArr.count > 0{
                self.dataArr.removeAll()
                self.mainTabelView.reloadData()
            } else {

            }
            queryStr = searchBar.text!
            if queryStr.count > 0{
                self.loadMoreData()
            } else {

            }



        } else if sender.tag == 1{
            //"资料"
            KFBLog(message: "资料")
            searchType = 1
            page = 0
            if self.dataArr.count > 0{
                self.dataArr.removeAll()
                self.mainTabelView.reloadData()
            } else {

            }
            queryStr = searchBar.text!

            if queryStr.count > 0{
                self.loadMoreData()
            } else {

            }

        } else {
            //"用户
            KFBLog(message: "用户")
            searchType = 2
            page = 0
            if self.dataArr.count > 0{
                self.dataArr.removeAll()
                self.mainTabelView.reloadData()
            } else {

            }

            queryStr = searchBar.text!
            if queryStr.count > 0{
                self.loadMoreData()
            } else {

            }

        }
        lastBtn = sender
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
