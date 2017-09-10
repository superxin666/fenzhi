//
//  MineViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let MAINELLID = "HEARTCELL_ID"//
class MineViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    let mainTabelView : UITableView = UITableView()
    let topBackView : UIView = UIView()
    let cellNameArr = ["我的消息","我的收藏","我的赞赏","我的收入","设置"]
    let cellIconNameArr = [#imageLiteral(resourceName: "icon_wdxx"),#imageLiteral(resourceName: "icon_wdsc"),#imageLiteral(resourceName: "icon_wdzs"),#imageLiteral(resourceName: "icon_wdsr"),#imageLiteral(resourceName: "icon_sz")]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = FZColorFromRGB(rgbValue: 0xf4f8f9)
        self.creatHeadView()
        self.creatTableView()
    }
    func creatHeadView() {
        topBackView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(382))
        topBackView.backgroundColor = .white
        self.view.addSubview(topBackView)


        //背景图
        let backImageView : UIImageView = UIImageView(image: #imageLiteral(resourceName: "bg1"))
        backImageView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(290))
        topBackView.addSubview(backImageView)

        //头像
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "touxiang"))
        iconImageView.frame = CGRect(x: (KSCREEN_WIDTH - ip7(70))/2, y: LNAVIGATION_HEIGHT, width: ip7(70), height: ip7(70))
        topBackView.addSubview(iconImageView)

        //名字
        let nameLabel : UILabel = UILabel(frame: CGRect(x: 0, y:  iconImageView.frame.maxY +  ip7(15), width: KSCREEN_WIDTH, height: ip7(26)))
        nameLabel.text = "尼古拉斯赵四"
        nameLabel.textColor = .white
        nameLabel.font = fzFont_Medium(ip7(26))
        nameLabel.textAlignment = .center
        topBackView.addSubview(nameLabel)
        //住址
        let dressLabel : UILabel = UILabel(frame: CGRect(x: 0, y:  nameLabel.frame.maxY +  ip7(15), width: KSCREEN_WIDTH, height: ip7(21)))
        dressLabel.text = "北京 东城区 红磨坊小学 三年级"
        dressLabel.textColor = .white
        dressLabel.font = fzFont_Thin(ip7(21))
        dressLabel.textAlignment = .center
        topBackView.addSubview(dressLabel)

        //信息
        let infoLabel : UILabel = UILabel(frame: CGRect(x: 0, y:  dressLabel.frame.maxY +  ip7(5), width: KSCREEN_WIDTH, height: ip7(21)))
        infoLabel.text = "语文老师 人教版"
        infoLabel.textColor = .white
        infoLabel.font = fzFont_Thin(ip7(21))
        infoLabel.textAlignment = .center
        topBackView.addSubview(infoLabel)

        let nameArr = ["关注","粉丝","被赞","被收藏",]
        let viewWidth = KSCREEN_WIDTH / 4
        //底部按钮
        for i in 0...3 {
            let view = UIView(frame: CGRect(x: viewWidth * CGFloat(i), y: backImageView.frame.maxY, width: viewWidth, height: ip7(92)))

            let lable : UILabel = UILabel(frame: CGRect(x: 0, y:  ip7(19), width: viewWidth, height: ip7(21)))
            lable.text = "200"
            lable.font = fzFont_Thin(ip7(21))
            lable.textColor = FZColorFromRGB(rgbValue: 0x666666)
            lable.textAlignment = .center
            lable.adjustsFontSizeToFitWidth = true
            view.addSubview(lable)

            let lable2 : UILabel = UILabel(frame: CGRect(x: 0, y: lable.frame.maxY + ip7(10), width: viewWidth, height: ip7(21)))
            lable2.text = nameArr[i]
            lable2.font = fzFont_Thin(ip7(21))
            lable2.textColor = FZColorFromRGB(rgbValue: 0xaaaaaa)
            lable2.textAlignment = .center
            lable2.adjustsFontSizeToFitWidth = true
            view.addSubview(lable2)
            topBackView.addSubview(view)

        }

    }

    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y: topBackView.frame.maxY + ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - topBackView.frame.maxY - ip7(15))
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(MainTableViewCell.self, forCellReuseIdentifier: MAINELLID)
        self.view.addSubview(mainTabelView)

    }

    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : MainTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: MAINELLID, for: indexPath) as! MainTableViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        if (cell == nil)  {
            cell = MainTableViewCell(style: .default, reuseIdentifier: HEARTCELLID)
        }
        cell.setUpUIWith(name: cellNameArr[indexPath.row], image: cellIconNameArr[indexPath.row])
        return cell;


    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return ip7(80);
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
