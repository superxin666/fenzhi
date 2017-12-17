//
//  HomeViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import QuickLook
let HEARTCELLID = "HEARTCELL_ID"//
let TEACHCELLID = "TEACHCELL_ID"//
class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    let topBackView : UIView = UIView()//头部view背景图
    let mainTabelView : UITableView = UITableView()

    var contentOffsetY:CGFloat = 0.0
    var oldContentOffsetY:CGFloat = 0.0
    var newContentOffsetY:CGFloat = 0.0
    
    let dataVC = HomeDataMangerController()
    var dataModel : GetmyfeedlistModel = GetmyfeedlistModel()
    var dataArr : [GetmyfeedlistModel_data_fenxList] = []
    
    var page :Int = 1
    let count : Int = 10
    
    let quickLookController = QLPreviewController()
    var qucikModel = GetmyfeedlistModel_data_fenxList()
     var openFileUrl :String!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.freshData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.title = "首页"
        self.view.backgroundColor = backView_COLOUR
        self.navigation_title_fontsize(name: "首页", fontsize: 27)
        self.creatTopView()
        self.creatTableView()
        self.getData()
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
        dataVC.getfeedlist(pageNum: page, count: count, completion: { (data) in
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
                    NotificationCenter.default.addObserver(self, selector: #selector(self.teachBtnClik), name: NSNotification.Name(rawValue: "gorelease"), object: nil)
//                    let ishaveFile :String? = UserDefaults.standard.value(forKey: "gorelease") as! String?
//                    if ishaveFile != nil && ishaveFile == "1" {
//                        KFBLog(message: "进去文件发布")
//                        UserDefaults.standard.set("0", forKey: "gorelease")
//                        weakSelf?.teachBtnClik()
//                    }
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
//            weakSelf?.mainTabelView.mj_header.endRefreshing()

        }) { (erro) in
            weakSelf?.SVshowErro(infoStr: "网络请求失败")
//            weakSelf?.mainTabelView.mj_header.endRefreshing()
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
    
    //MARK:头部view
    func creatTopView() {
        let viewHeight  = ip7(66)
        topBackView.frame = CGRect(x: 0, y: LNAVIGATION_HEIGHT, width: KSCREEN_WIDTH, height: viewHeight + ip7(20))
        topBackView.backgroundColor = .white
        self.view.addSubview(topBackView)

        //教学分享  
        let height = ip7(21)
        let btnY = (viewHeight - height)/2
        let stBtn : UIButton = UIButton(frame: CGRect(x: 0, y: btnY, width: KSCREEN_WIDTH/2, height: height))
        stBtn.setTitle("教学分享", for: .normal)
        stBtn.setImage(#imageLiteral(resourceName: "icon_jxfx"), for: .normal)
        stBtn.setTitleColor(FZColor(red: 102, green: 102, blue: 102, alpha: 1.0), for: .normal)
        stBtn.titleLabel?.font = fzFont_Medium(ip7(21))
        stBtn.backgroundColor = .clear
        stBtn.addTarget(self, action:#selector(HomeViewController.teachBtnClik), for: .touchUpInside)
        stBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ip7(20))

        topBackView.addSubview(stBtn)

        let lineView = UIView()
        let lineViewY = (ip7(66) - ip7(20))/2

        lineView.frame = CGRect(x: KSCREEN_WIDTH/2, y: lineViewY, width: 0.5, height: ip7(20))
        lineView.backgroundColor = FZColor(red: 102, green: 102, blue: 102, alpha: 1.0)
        topBackView.addSubview(lineView)


        //心得分享
        let hertBtn : UIButton = UIButton(frame: CGRect(x: KSCREEN_WIDTH/2, y: btnY, width: KSCREEN_WIDTH/2, height: height))
        hertBtn.setTitle("心得分享", for: .normal)
        hertBtn.setImage(#imageLiteral(resourceName: "icon_xdfx"), for: .normal)
        hertBtn.backgroundColor = .clear
        hertBtn.setTitleColor(FZColor(red: 102, green: 102, blue: 102, alpha: 1.0), for: .normal)
        hertBtn.titleLabel?.font = fzFont_Medium(ip7(21))
        hertBtn.addTarget(self, action:#selector(HomeViewController.heartBtnClick), for: .touchUpInside)
        hertBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ip7(20))
        topBackView.addSubview(hertBtn)

        //
        let lineView2 = UIView()
        lineView2.frame = CGRect(x: 0, y: ip7(66), width: KSCREEN_WIDTH, height: ip7(20))
        lineView2.backgroundColor = backView_COLOUR
        topBackView.addSubview(lineView2)

    }
    //MARK:topView clik
    func teachBtnClik() {
        let vc : TeachReleaseViewController = TeachReleaseViewController()
        let nv :UINavigationController = UINavigationController(rootViewController: vc)
        self.present(nv, animated: true) {

        }
    }

    func heartBtnClick() {
        let vc : HeartReleaseViewController = HeartReleaseViewController()
        let nv :UINavigationController = UINavigationController(rootViewController: vc)
        self.present(nv, animated: true) {

        }

    }

    //MARK:tableView
    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y: topBackView.frame.maxY, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - topBackView.frame.maxY)
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        footer.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.loadMoreData))
//        header.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.freshData))
        mainTabelView.mj_footer = footer
//        mainTabelView.mj_header = header
        mainTabelView.register(HeartTableViewCell.self, forCellReuseIdentifier: HEARTCELLID)
        mainTabelView.register(TeachTableViewCell.self, forCellReuseIdentifier: TEACHCELLID)
        self.view.addSubview(mainTabelView)

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
                            if  (self.openFileUrl.characters.count > 0) {
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
    // MARK: scrollView 代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        newContentOffsetY = scrollView.contentOffset.y
        if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY>contentOffsetY) {
            //up

        } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY){
            //down

        } else {
            //拖拽
            if scrollView.contentOffset.y - contentOffsetY > 5.0 {
                //上
                self.hidTop()
            } else if contentOffsetY - scrollView.contentOffset.y > 5.0 {
                //下
                self.showTop()
            }

        }
    }


    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        oldContentOffsetY = scrollView.contentOffset.y
    }

    func showTop() {
        topBackView.alpha = 1.0
        mainTabelView.frame = CGRect(x: 0, y: topBackView.frame.maxY, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - topBackView.frame.maxY)
//        self.view.frame.origin.y = topBackView.frame.maxY,
    }
    func hidTop() {
        topBackView.alpha = 0.0
        mainTabelView.frame = CGRect(x: 0, y: LNAVIGATION_HEIGHT, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - topBackView.frame.maxY + ip7(20))
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url : NSURL =  NSURL(fileURLWithPath: openFileUrl)
        KFBLog(message: url)
        return url
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
