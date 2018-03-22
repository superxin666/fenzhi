//
//  XiaoxiViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/29.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class XiaoxiViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    let leftBtn : UIButton = UIButton()
    let leftView = UIView()
    
    let rightBtn : UIButton = UIButton()
    let rightView = UIView()

    var dataModel : GetmessagelistLikeModel = GetmessagelistLikeModel()//
    var dataModel_Comment : GetCommentMessagelistModel = GetCommentMessagelistModel()//
    
    let requestVC = MineDataManger()
    var dataArr : [GetmessagelistLikeModel_data_messageList] = []
    var dataArr_Comment : [GetcommentlistModel_data_list_commentList] = []
    let mainTabelView : UITableView = UITableView()
    let topBaclView : UIView = UIView()
    var page :Int = 1
    var page_com :Int = 1
    let count : Int = 10
    var isLeft = true
    
    var netType : String = ""
    var messageTypeStr = "like"
    
    
    /// 回复人的数据模型
    var selectedUserModel : GetcommentlistModel_data_list_commentList!
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.navigation_title_fontsize(name: "我的消息", fontsize: 27)
        self.creatTopView()
        self.creatTableView()
        self.getData()
//        self.getData_comment()
    }



    //MARK:头部
    func creatTopView() {
        topBaclView.frame = CGRect(x: 0, y:  5, width: KSCREEN_WIDTH, height: ip7(65))
        topBaclView.backgroundColor = .white
        self.view.addSubview(topBaclView)

        leftBtn.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH/2, height: ip7(65)) 
        leftBtn.setTitle("点赞", for: .normal)
        leftBtn.setTitleColor(dark_3_COLOUR, for: .normal)
        leftBtn.titleLabel?.font = fzFont_Thin(ip7(24))
        leftBtn.backgroundColor = .clear
        topBaclView.addSubview(leftBtn)
        leftBtn.addTarget(self, action:#selector(XiaoxiViewController.leftbtnClick), for: .touchUpInside)
        
        leftView.frame = CGRect(x: (KSCREEN_WIDTH/2 - ip7(60))/2, y: ip7(65) - 4, width: ip7(60), height: 4)
        leftView.backgroundColor = blue_COLOUR
        leftBtn.addSubview(leftView)

        rightBtn.frame = CGRect(x:  KSCREEN_WIDTH/2, y: 0, width: KSCREEN_WIDTH/2, height: ip7(65))
        rightBtn.setTitle("评论", for: .normal)
        rightBtn.setTitleColor(dark_3_COLOUR, for: .normal)
        rightBtn.titleLabel?.font = fzFont_Thin(ip7(24))
        rightBtn.backgroundColor = .clear
        topBaclView.addSubview(rightBtn)
        rightBtn.addTarget(self, action:#selector(XiaoxiViewController.rightbtnClick), for: .touchUpInside)
        
        rightView.frame = CGRect(x: (KSCREEN_WIDTH/2 - ip7(60))/2, y: ip7(65) - 4, width: ip7(60), height: 4)
        rightView.backgroundColor = blue_COLOUR
        rightView.isHidden = true
        rightBtn.addSubview(rightView)

    }
    
    //MARK:头部按钮点击
    func leftbtnClick() {
        KFBLog(message: "点赞")
        messageTypeStr = "like"
        isLeft = true
        leftView.isHidden = false
        rightView.isHidden  = true
        self.reFlishData()
//        self.mainTabelView.reloadData()
    }
    
    func rightbtnClick() {
        KFBLog(message: "评论")
        messageTypeStr = "comment"
        isLeft = false
        rightView.isHidden = false
        leftView.isHidden = true
        self.reFlishData_Comment()
//        self.mainTabelView.reloadData()
    }


    func readMessageRequest(messageId : Int,fenxId:Int, ishow:Bool)  {
        var subType : Int
        if isLeft {
            //全部清除
            subType = 0
        } else {
            //单个清除
            subType = 1
        }
        self.requestVC.readMessage(messageId: messageId, typeStr: messageTypeStr,subType: subType, completion: { (data) in
            let model : SmsModel = data as! SmsModel
            if model.errno == 0 {
                KFBLog(message: "消息阅读成功")
                
            } else {
                KFBLog(message: "消息阅读失败")
            }
            let vc = TeachDetailViewController()
            if ishow {
                //显示评论
                vc.isshowpinglun_other = true
                vc.pinglunUserModel = self.selectedUserModel
            } else {
                //不显示评论
                
            }
            self.mainTabelView.reloadData()
            vc.fenxId = fenxId
            vc.isshowpinglun = ishow
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }) { (erro) in
            self.SVshowErro(infoStr: "请求失败")
        }
    }
    

    /// 返回 标记数据已读
    ///
    /// - Parameters:
    ///   - messageId: <#messageId description#>
    ///   - fenxId: <#fenxId description#>
    ///   - ishow: <#ishow description#>
    func readMessageReq(messageId : Int,fenxId:Int, ishow:Bool) {
        self.requestVC.readMessage(messageId: messageId, typeStr: messageTypeStr,subType: 0, completion: { (data) in
            let model : SmsModel = data as! SmsModel
            if model.errno == 0 {
                KFBLog(message: "消息阅读成功")
                
            } else {
                KFBLog(message: "消息阅读失败")
            }
            self.navigationController?.popViewController(animated: true)
        }) { (erro) in
            self.navigationController?.popViewController(animated: true)
        }
    }

    //MARK:tableview
    func creatTableView() {
        mainTabelView.frame = CGRect(x: 0, y: topBaclView.frame.maxY + ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(15) - LNAVIGATION_HEIGHT)
        mainTabelView.backgroundColor = UIColor.white
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(ShouruTableViewCell.self, forCellReuseIdentifier: SHOURUELLID)
        mainTabelView.mj_footer = footer
        footer.setRefreshingTarget(self, refreshingAction: #selector(ShouruViewController.loadMoreData))
        self.view.addSubview(mainTabelView)

    }
    // MARK: 点赞加载更多
    func loadMoreData() {
        if  isLeft {
            //点赞
            KFBLog(message: "加载更多")
            page = page + 1
            self.getData()

        } else {
            self.loadMoreData_comment()
        }
    }
    func reFlishData()  {
        KFBLog(message: "刷新")
        self.dataArr.removeAll()
        page = 1
        self.getData()
    }
    
    
    func getData()  {
        weak var weakSelf = self
        self.SVshowLoad()
        requestVC.getmessagelist(typeStr : netType,pageNum: page, count: 10, completion: { (data) in
            weakSelf?.SVdismiss()
            weakSelf?.dataModel = data as! GetmessagelistLikeModel
            if weakSelf?.dataModel.errno == 0 {
                //修改成功
                if (weakSelf?.dataModel.data.messageList.count)! > 0{
                    KFBLog(message: "数组")
                    self.noDataView.removeFromSuperview()
                    
                    weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.dataModel.data.messageList)!
                    weakSelf?.mainTabelView.reloadData()
                } else {
                    if weakSelf?.dataArr.count == 0 {
//                        weakSelf?.mainTabelView.removeFromSuperview()
                        weakSelf?.mainTabelView.reloadData()
                        weakSelf?.view.addSubview(self.showNoData(fream: CGRect(x: 0, y: self.topBaclView.frame.maxY + ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(15) - LNAVIGATION_HEIGHT)))
                        weakSelf?.view.bringSubview(toFront: self.noDataView)
                    } else {
                        weakSelf?.SVshowErro(infoStr: "没有数据了")
                    }
                }
                
                
            } else {
                weakSelf?.SVshowErro(infoStr: (weakSelf?.dataModel.errmsg)!)
            }
            weakSelf?.mainTabelView.mj_footer.endRefreshing()
            
        }) { (erro) in
            weakSelf?.SVshowErro(infoStr: "请求失败")
            
        }
    }
    
    
    // MARK: 评论加载更多
    func loadMoreData_comment() {
        page_com = page_com + 1
        self.getData_comment()
    }
    func reFlishData_Comment()  {
        self.dataArr_Comment.removeAll()
        page_com = 1
        self.getData_comment()
    }

    func getData_comment() {
        weak var weakSelf = self
        self.SVshowLoad()
        requestVC.getmessagelist_comment(typeStr : "comment",pageNum: page_com, count: 10, completion: { (data) in
            weakSelf?.SVdismiss()
            weakSelf?.dataModel_Comment = data as! GetCommentMessagelistModel
            if weakSelf?.dataModel_Comment.errno == 0 {
                //修改成功
                if (weakSelf?.dataModel_Comment.data.messageList.count)! > 0{
                    KFBLog(message: "数组")
                    self.noDataView.removeFromSuperview()
                    for model in (weakSelf?.dataModel_Comment.data.messageList)!{
                        weakSelf?.getCellHeight(model: model)
                    }
                    weakSelf?.dataArr_Comment = (weakSelf?.dataArr_Comment)! + (weakSelf?.dataModel_Comment.data.messageList)!
                    weakSelf?.mainTabelView.reloadData()
                } else {
                    if weakSelf?.dataArr_Comment.count == 0 {
//                        weakSelf?.mainTabelView.removeFromSuperview()
                        weakSelf?.mainTabelView.reloadData()
                        weakSelf?.view.addSubview(self.showNoData(fream: CGRect(x: 0, y: self.topBaclView.frame.maxY + ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(15) - LNAVIGATION_HEIGHT)))
                        weakSelf?.view.bringSubview(toFront: self.noDataView)
                    } else {
                        weakSelf?.SVshowErro(infoStr: "没有数据了")
                    }
                    
                }
                
                
            } else {
                weakSelf?.SVshowErro(infoStr: (weakSelf?.dataModel_Comment.errmsg)!)
                
            }
            weakSelf?.mainTabelView.mj_footer.endRefreshing()
            
        }) { (erro) in
            weakSelf?.SVshowErro(infoStr: "请求失败")
            
        }
        
    }
    
    func getCellHeight(model : GetcommentlistModel_data_list_commentList) {
        //头像 + 评论文字
        let returnContentStr = model.commentInfo.content
        let labelW = KSCREEN_WIDTH  - ip7(85) - ip7(25) - ip7(27)
        let returnContentH :CGFloat = returnContentStr.getLabHeight(font: fzFont_Thin(ip7(18)), LabelWidth: labelW)
        var height = ip7(83) + returnContentH
        //被评论内容
        if model.toCommentInfo.content.count > 0 {
            height = height + ip7(15) + ip7(53)
        }
        //定位
        if model.fenxInfo.catalog.count > 0 {
            height = height + ip7(25) + ip7(21)
        }
        //时间
        height = height + ip7(15) + ip7(18)
        height = height + ip7(43)
        model.cellHeight = height
    }

    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLeft {
            return self.dataArr.count
        } else {
            return self.dataArr_Comment.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        var cell : ShouruTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: SHOURUELLID, for: indexPath) as! ShouruTableViewCell
//
//        if (cell == nil)  {
//            cell = ShouruTableViewCell(style: .default, reuseIdentifier: SHOURUELLID)
//        }
        if isLeft {
            let cell = DianzanTableViewCell(style: .default, reuseIdentifier: "DIANZANCELLIS")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if indexPath.row < self.dataArr.count {
                cell.setUpUIWithModel_cellType(model: self.dataArr[indexPath.row])
            }
            weak var weakSelf = self
            cell.iconImageViewBlock = {(click_model) in
                let vc = UserInfoViewController()
                vc.userId  = click_model.userInfo.userId
                vc.hidesBottomBarWhenPushed = true
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell;
        } else {
            let cell = PinglunTableViewCell(style: .default, reuseIdentifier: "PINGLUNCELLIS")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if indexPath.row < self.dataArr_Comment.count {
                cell.setUpUI(model: self.dataArr_Comment[indexPath.row])
            }
            weak var weakSelf = self
            cell.iconImageBlock = {(click_model) in
                let vc = UserInfoViewController()
                vc.userId  = click_model.userInfo.userId
                vc.hidesBottomBarWhenPushed = true
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.returnClickBlock =  {(click_model) in
                KFBLog(message: "回复")
                self.selectedUserModel = click_model
                weakSelf?.readMessageRequest(messageId: click_model.messageId,fenxId:click_model.fenxInfo.fenxId,ishow: true)
            }
            return cell;
            
        }


    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLeft {
            let model : GetmessagelistLikeModel_data_messageList = self.dataArr[indexPath.row]
            model.status = 1
            self.readMessageRequest(messageId: model.messageId,fenxId:model.fenxInfo.fenxId,ishow: false)
        } else {
            let model : GetcommentlistModel_data_list_commentList = self.dataArr_Comment[indexPath.row]
            selectedUserModel = model;
            model.status = 1
            self.readMessageRequest(messageId: model.messageId,fenxId:model.fenxInfo.fenxId,ishow: false)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if isLeft {
           return ip7(188/2)
        } else {
            let model = self.dataArr_Comment[indexPath.row]
           return model.cellHeight
        }
       
    }

    override func navigationLeftBtnClick() {
        if isLeft {
            if self.dataArr.count > 0 {
                let model : GetmessagelistLikeModel_data_messageList = self.dataArr[0]
                self.readMessageReq(messageId: model.messageId,fenxId:model.fenxInfo.fenxId,ishow: false)
            }  else {
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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
