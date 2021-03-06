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
let localData_conent = "localData_conent"
let localData_user = "localData_user"
let localData_book = "localData_book"

class SearchViewController: BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    var mainTabelView : UITableView!
    var searchBar : UISearchBar!
    var iteamBarBackView : UIView = UIView()
    var lastBtn : UIButton!
    var page = 1
    var queryStr = ""
    
    let dataVC = HomeDataMangerController()
    /// 0 是内容 1是资料 2是用户
    var searchType = 0
    /// 搜索模型
    var dataModel : SearchModel = SearchModel()
    var dataArr : [Any] = []

    /// 内容
    var searchLastModel_conent : [Any] = []
    /// 资料
    var searchLastModel_book : [Any] = []
    /// 用户
    var searchLastModel_user : [Any] = []
    
    /// 当前上次搜索历史
    var currectSearchLastModel : [Any] = []
    
    /// 用户 数据
    var userDataArr : [UserInfoModel] = []
    
    let quickLookController = QLPreviewController()
    var qucikModel = GetmyfeedlistModel_data_fenxList()
    var openFileUrl :String!
    
    var localDataArr: [String]! = []

    var isSearch = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        self.creatSearchBar()
        self.iteamBar()
        self.creatTableView()
        searchType = 0
        self.getDataFromLoacl()

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
        mainTabelView = UITableView(frame: CGRect(x: 0, y: iteamBarBackView.frame.maxY, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - iteamBarBackView.frame.maxY), style: .plain)
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
//        footer.setRefreshingTarget(self, refreshingAction: #selector(SearchViewController.loadMoreData))
        mainTabelView.mj_footer = self.creactFoot()
        mainTabelView.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(SearchViewController.loadMoreData))
        mainTabelView.register(HeartTableViewCell.self, forCellReuseIdentifier: HEARTCELLID)
        mainTabelView.register(TeachTableViewCell.self, forCellReuseIdentifier: TEACHCELLID)
        mainTabelView.register(TeachTableViewCell.self, forCellReuseIdentifier: SEARCHUSERCELLID)
        mainTabelView.register(TeachTableViewCell.self, forCellReuseIdentifier: "loaclcell")

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
            //资料
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
    
    
    
    /// 获取本地历史记录
    func getDataFromLoacl() {
//        self.mainTabelView.mj_footer.isHidden = true
        self.noDataView.removeFromSuperview()
        self.mainTabelView.isHidden = false
        if localDataArr.count > 0 {
            localDataArr.removeAll()
        }
        
        if searchType == 0 {
            let arr =  UserDefaults.standard.object(forKey: localData_conent)
            if arr != nil {
                localDataArr = arr as! [String]
            }
        } else if searchType == 1 {
            let arr =  UserDefaults.standard.object(forKey: localData_book)
            if arr != nil {
                localDataArr = arr as! [String]
            }
        } else {
            let arr =  UserDefaults.standard.object(forKey: localData_user)
            if arr != nil {
                localDataArr = arr as! [String]
            }
        }
        KFBLog(message: "历史数据数组---\(localDataArr.count)")
        if localDataArr.count == 0 {
            mainTabelView.isHidden = true
            self.view.addSubview(self.showNoData(fream: CGRect(x: 0, y: self.iteamBarBackView.frame.maxY, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - self.iteamBarBackView.frame.maxY)))
        }
        UserDefaults.standard.synchronize()
        
        self.mainTabelView.reloadData()
    }
    func setDataToLoacl()  {

        if !localDataArr.contains(queryStr) {
            localDataArr.append(queryStr)
        }
        if searchType == 0 {
            UserDefaults.standard.set(localDataArr, forKey: localData_conent)
        } else if searchType == 1 {
            UserDefaults.standard.set(localDataArr, forKey: localData_book)
        } else {
             UserDefaults.standard.set(localDataArr, forKey: localData_user)
        }
    }
    
    func setNULLToLocal() {
        localDataArr.removeAll()
        if searchType == 0 {
            UserDefaults.standard.set(localDataArr, forKey: localData_conent)
        } else if searchType == 1 {
            UserDefaults.standard.set(localDataArr, forKey: localData_book)
        } else {
            UserDefaults.standard.set(localDataArr, forKey: localData_user)
        }
        self.mainTabelView.reloadData()
        mainTabelView.isHidden = true
        self.view.addSubview(self.showNoData(fream: CGRect(x: 0, y: self.iteamBarBackView.frame.maxY, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - self.iteamBarBackView.frame.maxY)))
    }
    
    func loadMoreData() {
        page = page + 1
        KFBLog(message: "当前页数\(page)")
        self.getData()
    }
    func getData() {
        if self.searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        weak var weakSelf = self
        self.SVshowLoad()
        isSearch = true
//        self.mainTabelView.mj_footer.isHidden = false
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
                        //搜索内容 是内容 1是资料 2是用户
                        if weakSelf?.searchType == 0 {
                            weakSelf?.searchLastModel_conent = (weakSelf?.searchLastModel_conent)! + (weakSelf?.dataModel.data.fenx.list)!
                        } else if weakSelf?.searchType == 1 {
                            weakSelf?.searchLastModel_book = (weakSelf?.searchLastModel_book)! + (weakSelf?.dataModel.data.fenx.list)!
                        }
                    } else {
                        weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.user.list)!
                         weakSelf?.searchLastModel_user = (weakSelf?.searchLastModel_user)! + (weakSelf?.dataModel.data.user.list)!
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
            weakSelf?.mainTabelView.mj_footer.endRefreshing()
        }
    }

    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        KFBLog(message: isSearch)
        if isSearch {
            if currectSearchLastModel.count > 0 {
                        KFBLog(message: "\( currectSearchLastModel.count)")
                return currectSearchLastModel.count
            } else {
                 return self.dataArr.count
            }
        } else {
            return self.localDataArr.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearch {
            //搜索内容
            
            if searchType == 0 ||  searchType == 1{
                //动态
                if indexPath.row < self.dataArr.count || indexPath.row < currectSearchLastModel.count{
                    let model : GetmyfeedlistModel_data_fenxList!
                    if currectSearchLastModel.count > 0 {
                         model = self.currectSearchLastModel[indexPath.row] as! GetmyfeedlistModel_data_fenxList
                    } else {
                        model = self.dataArr[indexPath.row] as! GetmyfeedlistModel_data_fenxList
                    }
                    
                    if model.type == 0 {
                        //资料
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
                if indexPath.row < self.dataArr.count || indexPath.row < currectSearchLastModel.count {
                    let model : UserInfoModel!
                    if currectSearchLastModel.count > 0 {
                        model = self.currectSearchLastModel[indexPath.row] as! UserInfoModel
                    } else {
                        model = self.dataArr[indexPath.row] as! UserInfoModel
                    }
                    
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
        } else {
            if indexPath.row == self.localDataArr.count{
                //清除记录
                let cell = UITableViewCell(style: .default, reuseIdentifier: "loaclcell_del")
                cell.selectionStyle = .none
                let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(44)))
                nameLabel.text = "清除历史记录"
                nameLabel.textColor = dark_3_COLOUR
                nameLabel.textAlignment = .center
                cell.addSubview(nameLabel)
                return cell
            } else {
                //历史记录
                let cell = SearchLocalTableViewCell(style: .default, reuseIdentifier: "loaclcell")
                if indexPath.row < self.localDataArr.count{
                    let str = self.localDataArr[indexPath.row]
                    cell.setData(title: str)
                }
                return cell
                
            }
           
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearch {
            if self.searchType == 2 {
                
            } else {
                
                
                if indexPath.row < self.dataArr.count || indexPath.row < self.currectSearchLastModel.count {
                    let model : GetmyfeedlistModel_data_fenxList!
                    if self.currectSearchLastModel.count > 0 {
                        model = self.currectSearchLastModel[indexPath.row] as! GetmyfeedlistModel_data_fenxList
                    } else {
                        model = self.dataArr[indexPath.row] as! GetmyfeedlistModel_data_fenxList
                    }
                    let vc = TeachDetailViewController()
                    vc.fenxId = model.id
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        } else {
            if indexPath.row == self.localDataArr.count{
                //清除记录
                KFBLog(message: "清除记录")
                self.setNULLToLocal()
            } else {
                //历史记录
                KFBLog(message: "历史记录")
                if indexPath.row < self.localDataArr.count{
                    let str = self.localDataArr[indexPath.row];
                    KFBLog(message: "点击的历史记录\(str)")
                    queryStr = str
                    self.searchBar.text = queryStr
                    self.getData()
                }
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if isSearch {
            if self.searchType == 2 {
                return SearchTableViewCellH
            } else {
                let model : GetmyfeedlistModel_data_fenxList!
                if currectSearchLastModel.count > 0 {
                    model =  self.currectSearchLastModel[indexPath.row] as! GetmyfeedlistModel_data_fenxList
                } else {
                    model =  self.dataArr[indexPath.row] as! GetmyfeedlistModel_data_fenxList
                }

                return model.cellHeight;
            }
        } else {
            return SearchLocalTableViewCellH
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isSearch {
            let headView = UIView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(44)))
            let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(44)))
            nameLabel.text = "搜索历史"
            nameLabel.textColor = dark_3_COLOUR
            nameLabel.textAlignment = .left
            headView.addSubview(nameLabel)
            return headView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearch {
            return 0
        } else {
            return ip7(44)
        }
    }
    

    // MARK: searchBarDelegate 代理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        KFBLog(message: "开始所搜")
        searchBar.resignFirstResponder()
        queryStr = searchBar.text!
        if !(queryStr.count>0) {
            self.SVshowErro(infoStr: "请输入搜索内容")
            return
        }
//        self.mainTabelView.mj_footer.isHidden = false
        //本地记录
        self.setDataToLoacl()
        if self.dataArr.count > 0 {
            self.dataArr.removeAll()
        }
//        if searchType == 0 {
//            if searchLastModel_conent.count > 0 {
//                searchLastModel_conent.removeAll()
//            }
//        } else if searchType == 1 {
//            if searchLastModel_book.count > 0 {
//                searchLastModel_book.removeAll()
//            }
//        } else {
//            if searchLastModel_user.count > 0 {
//                searchLastModel_user.removeAll()
//            }
//        }
        
        self.getData()
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
        lastBtn.isSelected = false
        sender.isSelected = !sender.isSelected
        if currectSearchLastModel.count > 0 {
            currectSearchLastModel.removeAll()
        }
        if sender.tag == 0 {
            //"内容"
            KFBLog(message: "内容")
            searchType = 0
            page = 1
            if self.dataArr.count > 0{
                self.dataArr.removeAll()
            }
            queryStr = searchBar.text!
            currectSearchLastModel = searchLastModel_conent
        } else if sender.tag == 1{
            //"资料"
            KFBLog(message: "资料")
            searchType = 1
            page = 1
            if self.dataArr.count > 0{
                self.dataArr.removeAll()
            }
            queryStr = searchBar.text!
            currectSearchLastModel = searchLastModel_book
        } else {
            //"用户
            KFBLog(message: "用户")
            searchType = 2
            page = 1
            if self.dataArr.count > 0{
                self.dataArr.removeAll()
            }
            queryStr = searchBar.text!
            currectSearchLastModel = searchLastModel_user
        }
        
        KFBLog(message: "上次搜索个数\(currectSearchLastModel.count)")
        if currectSearchLastModel.count > 0 {
            isSearch = true
//            self.mainTabelView.mj_footer.isHidden = true
            self.noDataView.removeFromSuperview()
            self.mainTabelView.isHidden = false
            self.mainTabelView.reloadData()
        } else {
            isSearch = false
            self.getDataFromLoacl()
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
