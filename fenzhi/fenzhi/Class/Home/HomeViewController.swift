//
//  HomeViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class HomeViewController: ViewController,UITableViewDelegate,UITableViewDataSource {
    let topBackView : UIView = UIView()//头部view背景图
    let mainTabelView : UITableView = UITableView()

    var contentOffsetY:CGFloat = 0.0
    var oldContentOffsetY:CGFloat = 0.0
    var newContentOffsetY:CGFloat = 0.0



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "首页"
        self.view.backgroundColor = .white
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
        stBtn.setTitleColor(FZColor(red: 102, green: 102, blue: 102, alpha: 1.0), for: .normal)
        stBtn.titleLabel?.font = UIFont.systemFont(ofSize: ip7(21))
        stBtn.backgroundColor = .clear
        topBackView.addSubview(stBtn)

        let lineView = UIView()
        let lineViewY = (ip7(66) - ip7(20))/2

        lineView.frame = CGRect(x: KSCREEN_WIDTH/2, y: lineViewY, width: 0.5, height: ip7(20))
        lineView.backgroundColor = FZColor(red: 102, green: 102, blue: 102, alpha: 1.0)
        topBackView.addSubview(lineView)


        //心得分享
        let hertBtn : UIButton = UIButton(frame: CGRect(x: KSCREEN_WIDTH/2, y: btnY, width: KSCREEN_WIDTH/2, height: height))
        hertBtn.setTitle("心得分享", for: .normal)
        hertBtn.backgroundColor = .clear
        hertBtn.setTitleColor(FZColor(red: 102, green: 102, blue: 102, alpha: 1.0), for: .normal)
        hertBtn.titleLabel?.font = UIFont.systemFont(ofSize: ip7(21))
        topBackView.addSubview(hertBtn)

        //
        let lineView2 = UIView()
        lineView2.frame = CGRect(x: 0, y: ip7(66), width: KSCREEN_WIDTH, height: ip7(20))
        lineView2.backgroundColor = FZColorFromRGB(rgbValue: 0xf4f8f9)
        topBackView.addSubview(lineView2)

    }
    //MARK:tableView
    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y: topBackView.frame.maxY, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - topBackView.frame.maxY)
        mainTabelView.backgroundColor = UIColor.green
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
//        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
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
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: 44))
        cell.backgroundColor = .red
        return cell;

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 44;
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
        mainTabelView.frame.origin.y = topBackView.frame.maxY
    }
    func hidTop() {
        topBackView.alpha = 0.0
        mainTabelView.frame.origin.y = LNAVIGATION_HEIGHT
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
