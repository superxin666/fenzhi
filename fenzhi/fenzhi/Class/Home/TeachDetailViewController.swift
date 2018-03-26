//
//  TeachDetailViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/19.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import QuickLook
import BMPlayer
let COMMONTELLID = "COMMONTELL_ID"//
class TeachDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    var fenxId :Int!
    var isshowzanshang : Bool = false
    var isshowpinglun : Bool = false
    var isshowpinglun_other : Bool = false
    

    let mainScrollow : UIScrollView = UIScrollView()
    let mainTabelView : UITableView = UITableView()
    let dataVC = HomeDataMangerController()
    var headData : TeachDetailModel = TeachDetailModel()
    var commentlistData : GetcommentlistModel = GetcommentlistModel()
    let headView : TeachDetailHeadView =  TeachDetailHeadView()

    var headViewHeight : CGFloat = 0.0
    var videY : CGFloat = 0.0
    var sectionNum = 1
    var hotArr : [GetcommentlistModel_data_list_commentList] = []
    var otherArr : [GetcommentlistModel_data_list_commentList] = []
    var newArr : [GetcommentlistModel_data_list_commentList] = []
    var page :Int = 1
    let count : Int = 10
    var hotTitle = ""
    var otherTitle = ""
    var newTitle = ""
    var isFresh = false
    var isNoData = false
    let nodataImageViewBackView = UIView()
    let nodataImageView = UIImageView()

    
    let txtTextView : UITextView = UITextView()
    var txtTextViewBack : UIView!
    var isShowTxtTextViewBack = false
    let returnLabel : UILabel = UILabel()//回复人
    
    var keybodHeight : CGFloat = 0.0
    var txt : String = ""
    var ispinglun :String = "1"//0 是回复用户评论 1 是评论该分享

    var alertController : UIAlertController!
    var pinglunUserModel : GetcommentlistModel_data_list_commentList = GetcommentlistModel_data_list_commentList()//被回复人的数据模型
    
    var showBigImageView : UIImageView!
    let quickLookController = QLPreviewController()
    var qucikModel = GetmyfeedlistModel_data_fenxList()
    var openFileUrl :String!
    
    var player:BMPlayer!
    
    override var shouldAutorotate: Bool{
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return [.all]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        self.navigationBar_leftBtn()
        self.getHeadData()
        self.creatTableView()
        self.getcommentlistData()
        
        
    }
    func keyboardWillShow(notification: NSNotification) {
        let userinfo: NSDictionary = notification.userInfo! as NSDictionary
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRec = nsValue.cgRectValue
        let height = keyboardRec.size.height
        keybodHeight = height
//        if !isShowTxtTextViewBack {
//            self.showTxt_click()
//        }
        if !(txtTextViewBack == nil) {
            var frame = self.txtTextViewBack.frame
            frame.origin.y = KSCREEN_HEIGHT - height - ip7(260)
            self.txtTextViewBack.frame = frame
            print("keybordShow:\(height)")
        }
 
    }
    func loadMoreData() {
//        if isFresh {
//            return
//        }
        page = page + 1
        self.getcommentlistData()
    }
    
    func reflishData() {
        if self.newArr.count > 0 {
            self.newArr.removeAll()
        }
        if self.hotArr.count > 0 {
            self.hotArr.removeAll()
        }
        if self.otherArr.count > 0 {
            self.otherArr.removeAll()
        }
        page = 1
        self.isFresh = true
        self.mainTabelView.mj_footer.resetNoMoreData()
        self.getcommentlistData()
    }

    //MARK:获取分享头部数据
    func getHeadData() {
        weak var weakSelf = self
        self.SVshowLoad()
        dataVC.profile(fenxId: fenxId!, completion: { (data) in
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
        

        
        headView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: headViewHeight)
//        headView.snp.makeConstraints { (make) in
//            make.left.right.equalTo(mainTabelView).offset(0)
//            make.top.equalTo(mainTabelView).offset(0)
//            make.height.equalTo(headViewHeight)
//        }
        headView.vc = self
        headView.setUpUIWithModelAndType(model: self.headData, height: self.headViewHeight,type:self.headData.data.type!)


        //设置标题
        if self.headData.data.type! == 0 {
            //资料
            self.navigation_title_fontsize(name: "资料分享详情", fontsize: 27)
        } else {
            //心得
            self.navigation_title_fontsize(name: "心得分享详情", fontsize: 27)
        }


        weak var weakSelf = self
        headView.docBlock = {(model) in
            let urlStr : String = model.file
            let name : String = model.name.removingPercentEncoding!
            
            weakSelf?.dataVC.downLoadFile(path: urlStr,name:name, completion: { (data) in
                
                weakSelf?.openFileUrl = data as! String
                if  (self.openFileUrl.count > 0) {
                    KFBLog(message: "下载成功"+self.openFileUrl)
                    
                    weakSelf?.quickLookController.dataSource = self
                    weakSelf?.quickLookController.delegate = self
                    weakSelf?.quickLookController.hidesBottomBarWhenPushed =  true
                    weakSelf?.quickLookController.reloadData()
                    weakSelf?.navigationController?.pushViewController((weakSelf?.quickLookController)!, animated: true)
                } else {
                    KFBLog(message: "加载失败")
                    weakSelf?.SVshowErro(infoStr: "加载失败")
                }
            }, failure: { (erro) in
                
            })
        }
        headView.zanshangBlock = {(model) in
            KFBLog(message: "赞赏点击")
            weakSelf?.showZanShang()
        }
        headView.imageBlock = {(num) in
            //            let imageStr = weakSelf?.headData.data.images[num]
            //            weakSelf?.showBigImageView = UIImageView()
            //            weakSelf?.showBigImageView.kf.setImage(with: URL(string: imageStr!))
            //            KFBLog(message: weakSelf?.showBigImageView.image?.size)
            //            if weakSelf?.showBigImageView.image != nil {
            //                let size = weakSelf?.showBigImageView.image?.size
            //                let W = CGFloat((size?.width)!)/4
            //                let H = CGFloat((size?.height)!)/4
            //                KFBLog(message: "宽度---\(W)")
            //                KFBLog(message: "高度---\(H)")
            //                weakSelf?.showBigImageView.frame = CGRect(x: (KSCREEN_WIDTH - W)/2, y: (KSCREEN_HEIGHT - H)/2, width: W, height: H)
            //                weakSelf?.maskView.addSubview((weakSelf?.showBigImageView)!)
            //                weakSelf?.view.window?.addSubview(self.maskView)
            //
            //                let tap = UITapGestureRecognizer(target: self, action: #selector(weakSelf?.removeBigImageView))
            //                weakSelf?.maskView.addGestureRecognizer(tap)
            //            }

            let vc = ImageShowViewController()
            vc.imageNameArr = weakSelf?.headData.data.images
            vc.indexNum = num
            vc.isNet = true
            let na = UINavigationController(rootViewController: vc)
            self.present(na, animated: true, completion: {

            })

        }
        
        headView.fenxiangBlock = {(model) in
            let umeng = UMUntil()
            let url = BASER_API + share_api + "shareID=\(self.fenxId!)"
            var titleStr = ""
            KFBLog(message: model.data.type)
            if model.data.type! == 1 {
                titleStr = "心得分享"
                
            } else {
                titleStr = "资料分享"
            }

            let desStr = model.data.content
            KFBLog(message: url)
            umeng.sharClick(share: { (type) in
                umeng.shareWebUrlToPlatformWithUrl(webUlr: url, controller: self, thumbUrl: "", title: titleStr, des: desStr)

            })
        }
        headView.iconImageBlock = {(model) in
            let vc = UserInfoViewController()
            vc.userId  = model.data.userId
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }
        self.creatTxtView()
    }
    //MARK:移除放大视图
    func removeBigImageView() {
        self.showBigImageView.removeFromSuperview()
        self.maskView.removeFromSuperview()
    }
    
    //MARK:获取分享头部尺寸
    func getSize() {
        //创建 红包头像假数据
//        for i in 0..<13 {
//            let model : TeachDetailModel_data_zanUsers = TeachDetailModel_data_zanUsers()
//            model.avatar = self.headData.data.userInfo.avatar
//            self.headData.data.zanUsers.append(model)
//        }
        
        headViewHeight = ip7(380)
        //文字
        let str = self.headData.data.content
        let txtW = KSCREEN_WIDTH - ip7(50)
        let txtH :CGFloat = str.getLabHeight(font: fzFont_Thin(ip7(21)), LabelWidth: txtW)
//        if txtH > ip7(21) * 4 {
//            txtH = ip7(21) * 4
//        }

        headViewHeight = headViewHeight + txtH

        if self.headData.data.type == 0 {
            //资料
            if self.headData.data.coursewares.count > 0 {
                headViewHeight = headViewHeight +  (ip7(80) * CGFloat(self.headData.data.coursewares.count))
            }
            
            if self.headData.data.videoInfo.videoUrl.count > 0 {
                //有视频
                headViewHeight = headViewHeight + KSCREEN_WIDTH * 9.0/16.0
            }
        } else {
            //心得
            if self.headData.data.images.count > 0 {
                let imageWidth = (KSCREEN_WIDTH - ip7(60) - ip7(20))/2
                let imageHeight = imageWidth * 355/428
                let num = CGFloat((self.headData.data.images.count/2)) + CGFloat(self.headData.data.images.count%2)
                headViewHeight = headViewHeight +  ((imageHeight + ip7(20)) * num)
            }
        }


        if self.headData.data.catalog.count > 0 {
            headViewHeight = headViewHeight + ip7(35) + ip7(21)
        }

        if self.headData.data.zanUsers.count > 0 {
            let userNum = self.headData.data.zanUsers.count
            var backViewNum = userNum / showNum
            if (backViewNum % showNum > 0) {
                backViewNum = userNum / showNum + 1
            }
//            let imageWidth = (zanImageWidth - ip7(10) * CGFloat(showNum - 1))/CGFloat(showNum)
            headViewHeight = headViewHeight + ip7(29) + (zanImageWidth * CGFloat(backViewNum))
        }
    }

    func showZanShang()  {
        weak var weakSelf = self
        let view = PayView(frame: CGRect(x: 0, y: KSCREEN_HEIGHT - ip7(554), width: KSCREEN_WIDTH, height: ip7(554)))
        view.setUpData(name: (weakSelf?.headData.data.userInfo.name)!, iconStr: (weakSelf?.headData.data.userInfo.avatar)!)
        view.fenxID = (weakSelf?.fenxId)!
        view.cancleBlock = {
            view.removeFromSuperview()
            weakSelf?.maskView.removeFromSuperview()
        }
        weakSelf?.view.window?.addSubview(self.maskView)
        weakSelf?.maskView.addSubview(view)
    }

    //MARK:获取评论列表数据
    func getcommentlistData() {
        KFBLog(message: "评论列表请求")
        weak var weakSelf = self
        dataVC.getcommentlist(fenxId: fenxId!, pageNum: page, count: count, completion: { (data) in
            weakSelf?.commentlistData = data as! GetcommentlistModel
            if weakSelf?.commentlistData.errno == 0 {
                if (weakSelf?.commentlistData.data.list.count)! > 0 {
                    if weakSelf?.page == 1 {
                        weakSelf?.getTabelViewSectionNum()
                    }
                    
                    if weakSelf?.sectionNum == 2 {
                        if weakSelf?.page  == 1 {
                            //1最热评论+其他评论
                            weakSelf?.hotArr = (weakSelf?.commentlistData.data.list[0].commentList)!
                            weakSelf?.hotTitle  = self.commentlistData.data.list[0].title
                            for model in (weakSelf?.hotArr)! {
                                weakSelf?.getCommentCellHeight(model: model)
                            }
                            weakSelf?.otherArr = (weakSelf?.commentlistData.data.list[1].commentList)!
                            weakSelf?.otherTitle  = self.commentlistData.data.list[1].title
                            for model in (weakSelf?.otherArr)! {
                                weakSelf?.getCommentCellHeight(model: model)
                            }
                        } else {
                            //上拉加载
                            let newArr = (weakSelf?.commentlistData.data.list[0].commentList)!
                            if newArr.count > 0 {
                                weakSelf?.otherArr =  (weakSelf?.otherArr)! + newArr
                                for model in (weakSelf?.otherArr)! {
                                    weakSelf?.getCommentCellHeight(model: model)
                                }
                            } else {
                                weakSelf?.SVshowErro(infoStr: "没有数据了")
                                if (weakSelf?.mainTabelView.mj_footer.isRefreshing)! {
                                   weakSelf?.mainTabelView.mj_footer.endRefreshing()
                                }
                                
                            }
                        }
//                        self.mainTabelView.reloadData()
                    } else  {
                        //1 最新评论
                        if weakSelf?.page  == 1 {
    
                        } else {
                            //上拉加载
                        }
                        
                        let subarr = (weakSelf?.commentlistData.data.list[0].commentList)!
                        if subarr.count > 0 {
                            weakSelf?.newArr = (weakSelf?.newArr)! + (weakSelf?.commentlistData.data.list[0].commentList)!
                            for model in (weakSelf?.newArr)! {
                                weakSelf?.getCommentCellHeight(model: model)
                            }
                            if (weakSelf?.mainTabelView.mj_footer.isRefreshing)! {
                                weakSelf?.mainTabelView.mj_footer.endRefreshing()
                            }
                        } else {
                         
                            if (weakSelf?.mainTabelView.mj_footer.isRefreshing)! {
                                weakSelf?.SVshowErro(infoStr: "没有更多数据了")
                                weakSelf?.mainTabelView.mj_footer.endRefreshingWithNoMoreData()
                            }
                            
                        }
                        
                    }
                    weakSelf?.mainTabelView.reloadData()
                    weakSelf?.mainTabelView.mj_footer.endRefreshing()
                    
                    
                } else {
                    //没有评论
                    if (weakSelf?.hotArr.count)! == 0 && (weakSelf?.newArr.count)! == 0 {
                        KFBLog(message: "没有评论")
                        if self.page > 1  {
                           
                        } else {
                          self.mainTabelView.reloadData()
                        }
                        weakSelf?.mainTabelView.mj_footer.endRefreshing()
                    } else {
                        
                        weakSelf?.mainTabelView.mj_footer.endRefreshing()
                        
                    }
                    
                }
                
                KFBLog(message: self.newArr.count)
                KFBLog(message: self.hotArr.count)
                KFBLog(message: self.otherArr.count)
                if (weakSelf?.isshowzanshang)! {
                    weakSelf?.isshowzanshang = false
                    //展示赞赏列表
                    weakSelf?.showZanShang()
                }
                if (weakSelf?.isshowpinglun)! {
                    weakSelf?.isshowpinglun = false
                    //展示评论
                    KFBLog(message: "展示评论")
                    weakSelf?.liuyan_click()
//                    weakSelf?.ispinglun = "0"
//                    weakSelf?.showTxt_click()
                }

            } else {
                weakSelf?.SVshowErro(infoStr: (weakSelf?.headData.errmsg)!)
            }
//            self.mainTabelView.reloadData()
//            self.creatPlayerView()

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
        if model.toCommentInfo.content.count > 0 {
            heiht = heiht + ip7(78)
        }
        heiht = heiht  + ip7(44)
        model.cellHeight = heiht
    }

    //MARK:底部留言
    func creatTxtView() {
        
        let veiwHeight = ip7(80)
        let backView : UIView = UIView(frame: CGRect(x: 0, y: KSCREEN_HEIGHT - ip7(80), width: KSCREEN_HEIGHT, height: veiwHeight))
        backView.backgroundColor = .white
        self.view.addSubview(backView)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        backView.addSubview(lineView)
        
        let btn : UIButton = UIButton(type: .custom)
        btn.frame = CGRect(x: ip7(10), y: ip7(15), width: ip7(911/2), height: ip7(50))
        btn.setTitle("谢谢您留下宝贵的评论！", for: .normal)
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(dark_a_COLOUR, for: .normal)
        btn.titleLabel?.font = fzFont_Thin(ip7(18))
        btn.kfb_makeRadius(radius: 14)
        btn.kfb_makeBorderWithBorderWidth(width: 1, color: lineView_thin_COLOUR)
        btn.addTarget(self, action: #selector(liuyan_click), for: .touchUpInside)
        backView.addSubview(btn)
        let imageView = UIImageView(frame: CGRect(x: btn.frame.maxX + ip7(10), y: (ip7(80) - ip7(35))/2, width: ip7(35), height: ip7(35)))
        imageView.image = #imageLiteral(resourceName: "button_fs")
        backView.addSubview(imageView)
        
    }

    func liuyan_click()  {
        ispinglun = "1"
        self.showTxt_click()
    }

    //MARK:显示打字窗口
    func showTxt_click() {
        returnLabel.removeFromSuperview()
        self.view.window?.addSubview(self.maskView)
        self.creatTxtUI()
        txtTextView.becomeFirstResponder()

    }
    
    func dismissTxtView() {
        returnLabel.removeFromSuperview()
        self.txtTextViewBack.removeFromSuperview()
        txtTextView.resignFirstResponder()
        self.maskView.removeFromSuperview()

    }


    //MARK:留言页面
    func creatTxtUI() {
        self.isShowTxtTextViewBack = true
        self.txtTextViewBack  = UIView(frame: CGRect(x: 0, y:  0, width: KSCREEN_WIDTH, height: ip7(260)))
        self.txtTextViewBack.backgroundColor = .white
        self.maskView.addSubview(self.txtTextViewBack)
        
        txtTextView.delegate = self
        txtTextView.text = ""
        txtTextView.frame = CGRect(x: ip7(20), y: ip7(20), width: KSCREEN_WIDTH - ip7(40), height: ip7(327/2))
        txtTextView.font = fzFont_Thin(ip7(18))
        txtTextView.textColor = dark_3_COLOUR
        txtTextView.kfb_makeBorderWithBorderWidth(width: 1, color: lineView_thin_COLOUR)
        txtTextView.kfb_makeRadius(radius: 7)
        self.txtTextViewBack.addSubview(txtTextView)
        KFBLog(message: "666666")
        KFBLog(message: ispinglun)
        KFBLog(message: isshowpinglun_other)
        if ispinglun == "0" || isshowpinglun_other{
            if isshowpinglun_other {
                KFBLog(message: "显示回复人"+self.pinglunUserModel.userInfo.name)
                KFBLog(message: "显示回复人"+"\(self.pinglunUserModel.userInfo.userId)")
                KFBLog(message: "显示回复人"+"\(self.pinglunUserModel.commentInfo.commentId)")
            }
         
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
            
            //评论用户 需要添加用户名字
            returnLabel.frame = CGRect(x: ip7(5), y: ip7(5), width: KSCREEN_WIDTH - ip7(45), height: ip7(18))
            returnLabel.font = fzFont_Thin(ip7(18))
            returnLabel.textColor = dark_6_COLOUR
            returnLabel.isHidden = false
            returnLabel.text = "回复：" + self.pinglunUserModel.userInfo.name
            txtTextView.addSubview(returnLabel)
            
        }

        //取消按钮
        let cancleBtn : UIButton = UIButton(frame: CGRect(x: ip7(20),y: txtTextView.frame.maxY + ip7(14), width: ip7(189/2),height: ip7(50)))
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.backgroundColor = FZColorFromRGB(rgbValue: 0x8cd815)
        cancleBtn.setTitleColor( .white, for: .normal)
        cancleBtn.titleLabel?.font = fzFont_Thin(ip7(21))
        cancleBtn.kfb_makeRadius(radius: 7)
        cancleBtn.addTarget(self, action:#selector(TeachDetailViewController.cancle_submitcomment), for: .touchUpInside)
        self.txtTextViewBack.addSubview(cancleBtn)
        //确定按钮

        let sureBtn : UIButton = UIButton(frame: CGRect(x: KSCREEN_WIDTH - ip7(20) - ip7(289/2),y: txtTextView.frame.maxY + ip7(14), width: ip7(289/2),height: ip7(50)))
        sureBtn.setTitle("发表评论", for: .normal)
        sureBtn.backgroundColor = FZColorFromRGB(rgbValue: 0x15a5ea)
        sureBtn.setTitleColor( .white, for: .normal)
        sureBtn.titleLabel?.font = fzFont_Medium(ip7(21))
        sureBtn.kfb_makeRadius(radius: 7)
        sureBtn.addTarget(self, action:#selector(TeachDetailViewController.sure_submitcomment), for: .touchUpInside)
        self.txtTextViewBack.addSubview(sureBtn)

    }

    func textChanged() {
        if txtTextView.text.count == 0 {
            returnLabel.isHidden = false
        } else {
            returnLabel.isHidden = true
            returnLabel.text = "回复：" + self.pinglunUserModel.userInfo.name
        }
    }
    
    func sure_submitcomment() {
        self.dismissTxtView()
        self.submitcomment()
    }
    func cancle_submitcomment() {
        isshowpinglun_other = false
        self.dismissTxtView()
    }

    func submitcomment() {
        KFBLog(message: txt)
        self.SVshowLoad()
        weak var weakSelf = self

        var toUserId = 0
        var toCommentId = 0
        if (ispinglun == "0" ){
            
            toUserId = self.pinglunUserModel.userId
            toCommentId = self.pinglunUserModel.id
        }
        if isshowpinglun_other {
            isshowpinglun_other = false
            KFBLog(message: "回复别人请求")
            toUserId = self.pinglunUserModel.userInfo.userId
            toCommentId = self.pinglunUserModel.commentInfo.commentId
        }
        KFBLog(message: "\(toUserId)==\((toCommentId))")

        dataVC.submitcomment(content: txt, fenxId: self.fenxId!, toUserId: toUserId, toCommentId: toCommentId, completion: { (data) in
            weakSelf?.SVdismiss()
            let model :SubmitcommentModel = data as! SubmitcommentModel
            if model.errno == 0 {
                weakSelf?.SVshowSucess(infoStr: "评论成功")
                weakSelf?.reflishData()

            } else {
                weakSelf?.SVshowErro(infoStr: model.errmsg)
            }

        }) { (erro) in
            weakSelf?.SVshowErro(infoStr: "网络请求失败")
        }
    }



    func delcomment(delModel : GetcommentlistModel_data_list_commentList)  {
      weak var weakSelf = self
        alertController  = UIAlertController(title: "提示", message: "是否要删除本条评论", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            //取消
            weakSelf?.alertController.dismiss(animated: true, completion: {

            })
        }
        let sureAction = UIAlertAction(title: "删除", style: .default) { (action) in
            //删除
            self.SVshowLoad()
            weakSelf?.dataVC.delcomment(commentId: delModel.id, completion: { (data) in
                weakSelf?.SVdismiss()
                let model :SmsModel = data as! SmsModel
                if model.errno == 0 {
                    weakSelf?.SVshowSucess(infoStr: "删除成功")
                    //去除本地数据模型
                    self.reflishData()
                } else {
                    weakSelf?.SVshowErro(infoStr: model.errmsg)
                }
            }) { (erro) in
                weakSelf?.SVshowErro(infoStr: "网络请求失败")
            }
        }
        alertController.addAction(cancleAction)
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)

    }

    //MARK:textView
    func textViewDidEndEditing(_ textView: UITextView) {
        txt = textView.text
    }


    
    //MARK:tableView
    func creatTableView() {
        isNoData = false
          self.view.addSubview(mainTabelView)
//        mainTabelView.frame = CGRect(x: 0, y:0 , width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(80))
        mainTabelView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(0)

        }
        mainTabelView.backgroundColor = UIColor.clear
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(commentTableViewCell.self, forCellReuseIdentifier: COMMONTELLID)
        mainTabelView.mj_footer = footer
        footer.setRefreshingTarget(self, refreshingAction: #selector(TeachDetailViewController.loadMoreData))
        mainTabelView.tableHeaderView = headView
      

//        mainScrollow.contentSize = CGSize(width: 0, height: headViewHeight + mainTabelView.contentSize.height)
    }
    //MARK:没有数据
    func noCommendData() -> UIView {
        isNoData = true
//        mainScrollow.contentSize = CGSize(width: 0, height: headViewHeight  + ip7(190))

        nodataImageViewBackView.frame =  CGRect(x: 0, y: headView.frame.maxY + ip7(11/2), width: KSCREEN_WIDTH, height: ip7(190))
        nodataImageViewBackView.backgroundColor = .white
        mainScrollow.addSubview(nodataImageViewBackView)

        nodataImageView.frame = CGRect(x: (KSCREEN_WIDTH - ip7(230/2))/2, y: ip7(78/2), width: ip7(230/2), height: ip7(158/2))
        nodataImageView.image = #imageLiteral(resourceName: "icon_zwpl")
        nodataImageViewBackView.addSubview(nodataImageView)
//        mainScrollow.addSubview(nodataImageViewBackView)
        return nodataImageViewBackView
        
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
            KFBLog(message:  self.newArr.count)
            return self.newArr.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : commentTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: COMMONTELLID, for: indexPath) as! commentTableViewCell

        if (cell == nil)  {
            cell = commentTableViewCell(style: .default, reuseIdentifier: COMMONTELLID)
        }
//        let cell = commentTableViewCell(style: .default, reuseIdentifier: COMMONTELLID)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
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
       weak var weakSelf = self
    
        cell.pinglunViewBlock = {(data) in
            KFBLog(message: "评论")
            weakSelf?.ispinglun = "0"
            weakSelf?.pinglunUserModel = data
            weakSelf?.showTxt_click()
        }
        cell.delViewBlock = {(data) in
            KFBLog(message: "删除")
            weakSelf?.delcomment(delModel: data)
        }
        cell.iconViewBlock = {(data) in

            let vc = UserInfoViewController()
            vc.userId  = data.userId
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
            
        }
        return cell;

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        
        let view : UIView = UIView()
        view.backgroundColor = backView_COLOUR
        let nameLabel : UILabel = UILabel(frame: CGRect(x: ip7(30), y: (ip7(136/2) - ip7(21))/2, width: KSCREEN_WIDTH - ip7(30), height: ip7(21)))
        nameLabel.font = fzFont_Thin(ip7(21))
        nameLabel.textColor = dark_3_COLOUR
        view.addSubview(nameLabel)

        if sectionNum == 2 {
            //两组
            if section == 0 {
                 nameLabel.text = hotTitle
            } else {
                nameLabel.text = otherTitle
            }
            return view

        } else {
            //一组
            if self.newArr.count == 0 {
                return self.noCommendData()
            } else {
                nameLabel.text = "最新评论"
                return view
            }
   
        }
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        if sectionNum == 2 {
           return ip7(136/2)
        } else {
            if self.newArr.count == 0 {
                return  ip7(190)
            } else {
                return ip7(136/2)
            }
        }
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
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url : NSURL =  NSURL(fileURLWithPath: openFileUrl)
        KFBLog(message: url)
        return url
    }
    override func navigationLeftBtnClick() {
        if !(headView.player == nil) {
            if headView.player.isPlaying {
                KFBLog(message: "停止播放")
                headView.player.playerLayer?.pause()
            }
        }
        
        self.SVdismiss()
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
