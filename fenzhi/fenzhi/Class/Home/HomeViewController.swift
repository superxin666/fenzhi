//
//  HomeViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let HEARTCELLID = "HEARTCELL_ID"//
let TEACHCELLID = "TEACHCELL_ID"//
class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let topBackView : UIView = UIView()//头部view背景图
    let mainTabelView : UITableView = UITableView()

    var contentOffsetY:CGFloat = 0.0
    var oldContentOffsetY:CGFloat = 0.0
    var newContentOffsetY:CGFloat = 0.0



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.title = "首页"
        self.view.backgroundColor = backView_COLOUR
        self.navigation_title_fontsize(name: "首页", fontsize: 27)
        self.creatTopView()
        self.creatTableView()
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
        
        if indexPath.row%2 == 0 {
            var cell : HeartTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: HEARTCELLID, for: indexPath) as! HeartTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if (cell == nil)  {
                cell = HeartTableViewCell(style: .default, reuseIdentifier: HEARTCELLID)
            }
            cell.setUpUIWithModel_cellType(celltype: .home)
            weak var weakself = self
            cell.IconImageViewBlock = { () in
                print("头像点击")
                let vc = UserInfoViewController()
                vc.hidesBottomBarWhenPushed = true
                weakself?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell;
        } else {
            var cell : TeachTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: TEACHCELLID, for: indexPath) as! TeachTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if (cell == nil)  {
                cell = TeachTableViewCell(style: .default, reuseIdentifier: TEACHCELLID)
            }
            cell.setUpUIWithModelAndType(cellType: .home_Teach)
            return cell;
    
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return ip7(700);
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
    }
    func hidTop() {
        topBackView.alpha = 0.0
        mainTabelView.frame = CGRect(x: 0, y: LNAVIGATION_HEIGHT, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - topBackView.frame.maxY + ip7(20))
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
