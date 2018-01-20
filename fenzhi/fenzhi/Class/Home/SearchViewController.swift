//
//  SearchViewController.swift
//  fenzhi
//
//  Created by lvxin on 2018/1/9.
//  Copyright © 2018年 Xunqiu. All rights reserved.
//  搜索页面

import UIKit
import QuickLook
class SearchViewController: BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    let mainTabelView : UITableView = UITableView()
    var searchBar : UISearchBar!
    var iteamBarBackView : UIView = UIView()
    var lastBtn : UIButton!
    var page = 1
    var queryStr = ""
    
    
    /// 0 是内容 1是资料 2是用户
    var searchType = 0
    
    let dataVC = HomeDataMangerController()
    var dataModel : SearchModel = SearchModel()
    /// 动态 资料
    var dataArr : [GetmyfeedlistModel_data_fenxList] = []
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
            stBtn.addTarget(self, action:#selector(self.btnClick(sender:)), for: .touchUpInside)
        
            iteamBarBackView.addSubview(stBtn)
            
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: ip7(65), width: KSCREEN_WIDTH, height: 1))
        lineView.backgroundColor = lineView_thin_COLOUR
        iteamBarBackView .addSubview(lineView);
    }
    // MARK: net
    func loadMoreData() {
        page = page + 1
        self.getData()
    }
    func getData() {
        weak var weakSelf = self
        self.SVshowLoad()
        dataVC.searchlist(type: searchType, query: queryStr, pageNum: page, count: 10, completion: { (data) in
            
        }) { (erro) in
            
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
                let model : GetmyfeedlistModel_data_fenxList = self.dataArr[indexPath.row]
                
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
    
    
    // MARK: searchBarDelegate 代理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        KFBLog(message: "开始所搜")
        searchBar.resignFirstResponder()
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
        if sender.isSelected {
            return
        }
        
        lastBtn.isSelected = false
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 0 {
            //"内容"
            KFBLog(message: "内容")
            searchType = 0
        } else if sender.tag == 1{
            //"资料"
            KFBLog(message: "资料")
            searchType = 1
        } else {
            //"用户
             KFBLog(message: "用户")
            searchType = 2
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
