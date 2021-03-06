//
//  TeachReleaseViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/7.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import QuickLook
typealias TeachReleaseViewControllerBlock = ()->()
class TeachReleaseViewController: BaseViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,sureDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UpLoadFileDelegate_file {
    var reflishBlock : TeachReleaseViewControllerBlock!
    
    let textField: UITextView = UITextView()
    let btnBackView :UIView = UIView()
    let imageBackView :UIView = UIView()
    let dingweiBackView:UIView = UIView()
    
    var fileArr :[String]  = Array()
    var fileNameArr :Array<Dictionary<String,String>> = Array()
    
    
    let nsetBtn : UIButton = UIButton()
    var keybodHeight : CGFloat = 0.0
    let viewHeight = ip7(730/2)
    let btnViewHeight =  ip7(55)
   
    
    var isHaveBackView = false//中间背景
    
    var isHaveBtnBackView = false//是否已经有了 按钮栏
    var isHaveImageViewBackView = false//是否已经有了 文件栏
    var isHaveDingweiBackView = false//是否已经有了 定位
    
    var isHaveFiles = false//是否有文件
    var isHaveDingwei = false//是否有定位
    var tableView : UITableView = UITableView()//文件浏览
    var dingweiLabel : UILabel = UILabel()//定位显示
    
    let tdBtn : UIButton = UIButton()//定位按钮
    let dingweiLabel_btn : UILabel = UILabel()//定位标题
    let fileBtn : UIButton = UIButton()//文件按钮
    
    
    var txtStr : String = ""
    var couseId : String = ""
    
    let dataVC = HomeDataMangerController()
    let loadVC = CommonDataMangerViewController()
    
    var fileManager = FileManager.default
    var alertController : UIAlertController!
    
    let quickLookController = QLPreviewController()
    var openFileUrl :String!
    let homedataVC = HomeDataMangerController()
    
    var isLoading = false
    
    var tokenModel : GetststokenModel = GetststokenModel()
    let upfile = UpLoadFile()
    var fileNum : Int = 0
    
    /// 0 有书籍 1 没有书籍
    var bookType : Int!
    deinit {
        //记得移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {

        // Do any additional setup after loading the view
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: NSNotification.Name(rawValue: "reloadFile"), object: nil)
        self.navigation_title_fontsize(name: "资料分享", fontsize: 27)
        self.view.backgroundColor = .white
        self.navigationBar_leftBtn()
        self.navigationBar_rightBtn_title(name: "发布")
        if LogDataMangerViewController.getSelectCouse_name_id_teach().name.count > 0 {
            isHaveDingwei = true
            self.couseId = LogDataMangerViewController.getSelectCouse_name_id_teach().couseid
        } else {
            isHaveDingwei = false
        }
        self.getFileData()
        self.creatUI()
        self.getToken()

    }
    func reloadTableView(){
        KFBLog(message: "检测到文件")
        self.getFileData()
        if self.isHaveFiles {
            if !self.nsetBtn.isSelected {
                self.nestBtnClik()
            }
             tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func getFileData() {
        
//        for i in 0...3 {
//            let str = "asdfdf.pdf"
//            self.fileArr.append(str)
//            fileNum = self.fileArr.count
//            self.isHaveFiles = true
//
//        }
        if fileManager.fileExists(atPath: filePath) {
            let contentsOfPath = try? fileManager.contentsOfDirectory(atPath: filePath)
            self.fileArr = contentsOfPath!
            if self.fileArr.count > 0 {
                self.isHaveFiles = true
                fileNum = self.fileArr.count
            }
            KFBLog(message: contentsOfPath!)
        } else {
            KFBLog(message: "文件夹不存在")
            fileNum = 0
            self.isHaveFiles = false
        }
    }
    
    func getToken() {
        loadVC.getststoken(completion: { (data) in
            self.tokenModel = data as! GetststokenModel
            KFBLog(message: self.tokenModel.data.credentials.AccessKeyId)
        }) { (erro) in
            
        }
    }
    
    //MARK:发布
    override func navigationRightBtnClick() {
        KFBLog(message: "发布")
        //weak
        weak var weakSelf = self
        if !nsetBtn.isSelected {
            self.nestBtnClik()
        }
        if !(txtStr.count > 0) {
            self.SVshowErro(infoStr: "请输入文字")
            return
        }
        
        
        if fileArr.count>0 {
            if fileArr.count > 10 {
                self.SVshowErro(infoStr: "最多上传10个文件")
            }
            DispatchQueue.main.async {
                self.closeView()
            }
            //有文件

            upfile.initOSSClient(tokenModel.data.credentials.AccessKeyId, sec: tokenModel.data.credentials.AccessKeySecret, token: tokenModel.data.credentials.SecurityToken)
            upfile.delegatefile = self
            self.SVshow(infoStr: "正在努力上传中")
            for i in 0..<fileArr.count{

                //实际名字
                let  fileName = fileArr[i]
                let nameStr : String = fileName
            
                //data
                let filePathStr : String = filePath + "/" + fileName
                let url :URL = (URL(fileURLWithPath: filePathStr) as URL?)!
                let fileData:Data = try! Data(contentsOf: url)
                //上传地址
                let nameNum = arc4random()
                let loadFileName = String.getTimeNow() +  "\(nameNum)"
    
                upfile.upLoadFile(fileData, fileName: nameStr, loadName: loadFileName)
                
                
            }
            
        } else {
            self.SVshowErro(infoStr: "请选择要发布的文件")
        }
        
        
    }
    
    func completeName(_ filename: String!, loadName: String!) {
        let nameStr = filename.removingPercentEncoding
        let arr = nameStr?.components(separatedBy: ".")
        let typeStr : String = arr!.last!
        KFBLog(message: "上传地址" + loadName)
        let dict :Dictionary = [
            "name":filename,
            "type":typeStr,
            "file":loadName,
            ]
        self.fileNameArr.append(dict as! [String : String])
        if fileNameArr.count == self.fileArr.count {
            self.subTxt()
        }
    }


//    //MARK:发布
//    override func navigationRightBtnClick() {
//        KFBLog(message: "发布")
//        //weak
//        weak var weakSelf = self
//        if !nsetBtn.isSelected {
//            self.nestBtnClik()
//        }
//        if !(txtStr.count > 0) {
//            self.SVshowErro(infoStr: "请输入文字")
//            return
//        }
//
//
//        if fileArr.count>0 {
//            if fileArr.count > 10 {
//                self.SVshowErro(infoStr: "最多上传10个文件")
//            }
//            DispatchQueue.main.async {
//                self.closeView()
//            }
//            //有文件
//            var num = 0
//
//            for i in 0..<fileArr.count{
//                let file : String = fileArr[i]
//                self.SVshow(infoStr: "正在努力上传中")
//                self.loadVC.uploadfile(fileName: file, completion: { (data) in
//                    let model :UpFileDataModel = data as! UpFileDataModel
//                    if model.errno == 0 {
//                        KFBLog(message: model.data)
//                        num = num + 1
//                        let dict :Dictionary = [
//                            "name":model.data.name,
//                            "type":model.data.type,
//                            "file":model.data.file,
//                            ]
//                        self.fileNameArr.append(dict)
//                        if num == self.fileArr.count{
//                           self.subTxt(fileData: model.data)
//                        }
//
//                    } else {
//                        weakSelf?.SVdismiss()
//                        weakSelf?.openView()
//                        weakSelf?.SVshowErro(infoStr: model.errmsg)
//                    }
//                }, failure: { (erro) in
//                        weakSelf?.SVdismiss()
//                        weakSelf?.SVshowErro(infoStr: erro as! String)
//                        weakSelf?.openView()
//                })
//
//
//            }
//
//        } else {
//            self.SVshowErro(infoStr: "请选择要发布的文件")
//        }
//
//
//    }
    
    func subTxt()  {
        weak var weakSelf = self
        dataVC.submitfenx_teach(content: txtStr, catalog_id: self.couseId, file: self.fileNameArr, completion: { (data) in
            let model :SmsModel = data as! SmsModel
            if model.errno == 0{
                weakSelf?.SVdismiss()
                weakSelf?.SVshowSucess(infoStr: "发布成功")
                weakSelf?.openView()
                weakSelf?.reflishBlock()
                weakSelf?.navigationLeftBtnClick()
            } else {
                weakSelf?.openView()
                weakSelf?.SVshowErro(infoStr: model.errmsg)
            }
        }) { (erro) in
            weakSelf?.openView()
            weakSelf?.SVdismiss()
            weakSelf?.SVshowErro(infoStr: "网络请求失败")
        }
    }
    
    func closeView() {
        isLoading = true
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.btnBackView.isUserInteractionEnabled = false
        self.imageBackView.isUserInteractionEnabled = false
    }
    func openView() {
        isLoading = false
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.btnBackView.isUserInteractionEnabled = true
        self.imageBackView.isUserInteractionEnabled = true
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userinfo: NSDictionary = notification.userInfo! as NSDictionary
        
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        let keyboardRec = nsValue.cgRectValue
        
        let height = keyboardRec.size.height
        
        if !isHaveBtnBackView {
            self.creatBtnView()
            self.view.addSubview(btnBackView)
        } else {
            
        }
//        UIView.animate(withDuration: 1, animations: {
             self.nsetBtn.isSelected = false
            var frame = self.btnBackView.frame
            frame.origin.y = KSCREEN_HEIGHT - height - ip7(55)
            self.btnBackView.frame = frame
//            self.keybodHeight = height
//        })
        print("keybordShow:\(height)")
    }
    
    
    func creatUI()  {
        
        let lineView = UIView(frame: CGRect(x: 0, y: LNAVIGATION_HEIGHT, width: KSCREEN_WIDTH, height: ip7(11)))
        lineView.backgroundColor = backView_COLOUR
        self.view.addSubview(lineView)
        //
        textField.frame = CGRect(x: ip7(15), y: lineView.frame.maxY + ip7(25), width: KSCREEN_WIDTH - ip7(30), height: ip7(200))
        textField.textAlignment = .left
        textField.returnKeyType = .done
        textField.delegate = self
        textField.tag = 101

        textField.backgroundColor = .clear
        textField.font =  fzFont_Thin(ip7(18))
        self.view.addSubview(textField)
        self.creatBackView()
        if isHaveFiles {
            self.creatBtnView()
            self.view.addSubview(btnBackView)
            self.nestBtnClik()
           self.imageBackView.isHidden = false
        } else {
          self.imageBackView.isHidden = true
           textField.becomeFirstResponder()
        }
        
    }
    
    //MARK:中间背景
    func creatBackView() {
        //中间打背景
        imageBackView.frame =  CGRect(x: 0, y: KSCREEN_HEIGHT - viewHeight , width: KSCREEN_WIDTH, height: viewHeight)
        imageBackView.backgroundColor = .clear
        imageBackView.isHidden = true
        
        let lineView : UIView = UIView(frame: CGRect(x: (KSCREEN_WIDTH - ip7(480))/2, y: 0, width: ip7(480), height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        imageBackView.addSubview(lineView)
        
        self.view.addSubview(imageBackView)
        self.view.bringSubview(toFront: self.btnBackView)
         self.creaDingweiBackView()
        //课时定位
        if !isHaveDingwei {
           self.dingweiBackView.isHidden = true
        }
        //文件浏览
        self.creatImageView()
        if !isHaveFiles {
            tableView.isHidden = true
        }
    }
    
    //MARK:按钮
    func creatBtnView() {
        
        //按钮
        KFBLog(message: "asdf--\(keybodHeight)")
        isHaveBtnBackView = true
        //KSCREEN_HEIGHT - keybodHeight - LNAVIGATION_HEIGHT
        btnBackView.frame =  CGRect(x: 0, y: KSCREEN_HEIGHT , width: KSCREEN_WIDTH, height: btnViewHeight)
        btnBackView.backgroundColor = blue_COLOUR
        //
        nsetBtn.frame = CGRect(x: 0, y: 0, width: ip7(50), height: btnViewHeight)
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_x"), for: .normal)
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_s"), for: .selected)
        nsetBtn.isSelected = false
        nsetBtn.imageEdgeInsets = UIEdgeInsets(top: -ip7(10), left: 0, bottom: 0, right: 0)
        nsetBtn.imageRect(forContentRect: CGRect(x: 0, y: 0, width: ip7(25), height: ip7(14)))
        nsetBtn.backgroundColor = .clear
        nsetBtn.addTarget(self, action:#selector(TeachReleaseViewController.nestBtnClik), for: .touchUpInside)
        btnBackView.addSubview(nsetBtn)
        
        
        tdBtn.frame = CGRect(x: nsetBtn.frame.maxX + ip7 (10), y: 0, width: ip7(55), height: ip7(55))
        tdBtn.setImage(#imageLiteral(resourceName: "icon_dw2"), for: .normal)
        tdBtn.backgroundColor = .clear
        tdBtn.addTarget(self, action:#selector(HeartReleaseViewController.dingwei_click), for: .touchUpInside)
        btnBackView.addSubview(tdBtn)
        
        dingweiLabel_btn.frame = CGRect(x: tdBtn.frame.maxX + ip7(10), y: 0, width: KSCREEN_WIDTH - tdBtn.frame.maxX - ip7(100), height: ip7(55))
        dingweiLabel_btn.font = fzFont_Thin(ip7(18))
        dingweiLabel_btn.textAlignment = .left
        dingweiLabel_btn.text =  LogDataMangerViewController.getSelectCouse_name_id_teach().name
        dingweiLabel_btn.textColor = .white
        dingweiLabel_btn.isUserInteractionEnabled = true
        btnBackView.addSubview(dingweiLabel_btn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dingwei_click))
        dingweiLabel_btn.addGestureRecognizer(tap)
        
        
        let nameStr : String = LogDataMangerViewController.getSelectCouse_name_id_teach().name
        if nameStr.count > 0  {
            //有课时定位
            tdBtn.frame = CGRect(x: nsetBtn.frame.maxX + ip7 (10), y: 0, width: ip7(55), height: ip7(55))
        } else {
            dingweiLabel_btn.isHidden = true
            //没有课时定位
            tdBtn.frame =  CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25) - ip7(60), y: (ip7(55) - ip7(35))/2, width: ip7(35), height: ip7(35))
        }
        //图片按钮
        fileBtn.frame = CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25), y: 0, width: ip7(55), height: ip7(55))
        fileBtn.setImage(#imageLiteral(resourceName: "dingweinew"), for: .normal)
        fileBtn.backgroundColor = .clear
        fileBtn.addTarget(self, action:#selector(self.pdf_click), for: .touchUpInside)
        if fileNum > 0 {
            fileBtn.setTitle("\(fileNum)", for: .normal)
        }
        btnBackView.addSubview(fileBtn)
        
        let lineView = UIView(frame: CGRect(x: fileBtn.frame.origin.x - ip7(12), y: (ip7(55) - ip7(35))/2, width: 0.5, height: ip7(35)))
        lineView.backgroundColor = .white
        btnBackView.addSubview(lineView)
        
    }
    //MARK:课时定位
    func creaDingweiBackView() {
        dingweiBackView.frame = CGRect(x: (KSCREEN_WIDTH - ip7(480))/2, y: ip7(13), width: ip7(480), height: ip7(70))
        dingweiBackView.backgroundColor = .clear
        dingweiBackView.isUserInteractionEnabled = true
        imageBackView.addSubview(dingweiBackView)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.removedingwei_click))
        dingweiBackView.addGestureRecognizer(tap)
        
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: ip7(35)/2, width: ip7(35), height: ip7(35)))
        iconImageView.image = #imageLiteral(resourceName: "icon_dingwei")
        dingweiBackView.addSubview(iconImageView)
        
        dingweiLabel.frame =  CGRect(x: iconImageView.frame.maxX + ip7(10), y: ip7(70 - 21)/2, width:  dingweiBackView.frame.width - ip7(10) - iconImageView.frame.maxX , height: ip7(21))
        dingweiLabel.font = fzFont_Thin(ip7(21))
        dingweiLabel.textColor  = blue_COLOUR
        dingweiLabel.backgroundColor = .clear
        dingweiLabel.textAlignment = .left
        dingweiLabel.adjustsFontSizeToFitWidth = true
        if isHaveDingwei {
            dingweiLabel.text = LogDataMangerViewController.getSelectCouse_name_id_teach().name
        }
        dingweiBackView.addSubview(dingweiLabel)
        
    
    }
    //MARK:展示文件
    func creatImageView() {
        KFBLog(message: "文件选择背景")
        if isHaveDingwei {
           tableView.frame = CGRect(x: ip7(50), y: dingweiBackView.frame.maxY + ip7(15), width: KSCREEN_WIDTH-ip7(100), height: viewHeight - ip7(165/2) - ip7(55))
        } else {
           tableView.frame = CGRect(x: ip7(50), y: ip7(13) ,width: KSCREEN_WIDTH-ip7(100), height: viewHeight - ip7(165/2) - ip7(55))
        }

        tableView.backgroundColor = .clear
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        imageBackView.addSubview(tableView)

    }
    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "pdfcell")
        cell.selectionStyle = .none
        let name  = self.fileArr[indexPath.row]

        let view = UIView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH - ip7(100), height: ip7(65)))
        view.backgroundColor = backView_COLOUR
        view.isUserInteractionEnabled = true
        view.backgroundColor = backView_COLOUR
        view.tag = indexPath.row
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(self.delfile_click(tap:)))
        view.addGestureRecognizer(longTap)
        
        //图片
        let arr = name.components(separatedBy: ".")
        let nameStr : String = arr.last!

        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: ip7(65), height: ip7(65))
        if nameStr.contains("pdf") {
            imageView.image = #imageLiteral(resourceName: "pdf")
        } else if nameStr.contains("ppt") {
            imageView.image = #imageLiteral(resourceName: "pptx")
        } else if nameStr.contains("xls") ||  nameStr.contains("exc"){
            imageView.image = #imageLiteral(resourceName: "icon_ex")
        } else {
            imageView.image = #imageLiteral(resourceName: "word")
        }
        
        
 
        
        view.addSubview(imageView)
        //描述
        let label : UILabel = UILabel(frame: CGRect(x: imageView.frame.maxX + ip7(10), y: (ip7(65) - ip7(21))/2, width: view.frame.width - imageView.frame.maxX - ip7(10), height: ip7(21)))
        label.text = name
        label.font = fzFont_Thin(ip7(21))
        label.textColor  = dark_3_COLOUR
        label.textAlignment = .left
        view.addSubview(label)
        cell.addSubview(view)
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        KFBLog(message: "文件点击")
        if self.fileArr.count > 0 {
            let name : String = self.fileArr[indexPath.row]
            let urlStr : String = filePath + "/" + name
            self.openFileUrl = urlStr
            
            self.quickLookController.dataSource = self
            self.quickLookController.delegate = self
            self.quickLookController.hidesBottomBarWhenPushed =  true
            self.quickLookController.reloadData()
            self.navigationController?.pushViewController((self.quickLookController), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return ip7(80);
    }
    
    
    
    //MARK:文件点击
    func pdf_click() {
        let vc :PdfListViewController = PdfListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func delfile_click(tap : UITapGestureRecognizer) {


        alertController  = UIAlertController(title: "提示", message: "是否要删除该文件", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            //取消
            self.alertController.dismiss(animated: true, completion: {

            })
        }
        let sureAction = UIAlertAction(title: "删除", style: .default) { (action) in
            let tagNum = tap.view?.tag
            let str = self.fileArr[tagNum!]
            let filePathStr : String = filePath + "/" + str
            if self.fileManager.fileExists(atPath: filePathStr){
                do {
                    try self.fileManager.removeItem(at: URL(fileURLWithPath: filePathStr))
                    self.fileArr.remove(at: tagNum!)
                    self.tableView.reloadData()
                    self.fileNum = self.fileNum - 1
                    if self.fileNum > 0 {
                        self.fileBtn.setTitle("\(self.fileNum)", for: .normal)
                    } else {
                        self.fileBtn.setTitle("", for: .normal)
                    }
                    KFBLog(message: "文件删除成功")
                } catch _ {
                    KFBLog(message: "文件删除失败")
                }
            }
        }
        alertController.addAction(cancleAction)
        alertController.addAction(sureAction)
        self.present((alertController)!, animated: true, completion: nil)
//
    }
    
    func delAllFiles() {
        if self.fileManager.fileExists(atPath: filePath){
            do {
                try self.fileManager.removeItem(at: URL(fileURLWithPath: filePath))
                self.tableView.reloadData()
                KFBLog(message: "文件夹删除成功")
            } catch _ {
                KFBLog(message: "文件夹删除成功")
            }
        }
    }

    
    //MARK:退出键盘
    func nestBtnClik()  {
        KFBLog(message: "退出键盘")
        nsetBtn.isSelected = !nsetBtn.isSelected
        if  nsetBtn.isSelected {
            //键盘回收
            //显示文件背景
            self.imageBackView.isHidden = false
            self.imageBackView.frame.origin.y = self.imageBackView.frame.origin.y -  btnViewHeight
            //键盘操作
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
            self.view.bringSubview(toFront: btnBackView)
            btnBackView.frame.origin.y =  KSCREEN_HEIGHT  - btnBackView.frame.size.height
        } else {
            //键盘弹起
            //隐藏文件背景
            self.imageBackView.frame.origin.y = self.imageBackView.frame.origin.y +  btnViewHeight
            self.imageBackView.isHidden = true
            //键盘操作
            textField.becomeFirstResponder()
            self.view.bringSubview(toFront: btnBackView)
            btnBackView.frame.origin.y =  KSCREEN_HEIGHT - keybodHeight - LNAVIGATION_HEIGHT
            
        }
    }
    
    //MARK:课时定位
    func dingwei_click() {
        KfbShowWithInfo(titleString: "定位")
        
        if bookType == 0 {
            if !nsetBtn.isSelected {
                self.nestBtnClik()
            }
            let vc = DingweiViewControlleroc()
            let urlStr = BASER_API + selectCouse_api + "token=" + "".getToken_RSA()
            vc.mainUrl =  urlStr
            vc.delegate = self
            vc.isHeart = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            alertController  = UIAlertController(title: "温馨提示", message: "暂未收录该教材数据，欢迎您的提供和反馈，客服QQ号：814038418", preferredStyle: .alert)
            let cancleAction = UIAlertAction(title: "确定", style: .cancel) { (action) in
                //取消
                self.alertController.dismiss(animated: true, completion: {
                    
                })
            }
            alertController.addAction(cancleAction)
            self.present((alertController)!, animated: true, completion: nil)
        }
        
        
    }
    //MARK:定位代理
    func sure_click() {
        KFBLog(message: LogDataMangerViewController.getSelectCouse_name_id_teach().name)
        let nameStr : String = LogDataMangerViewController.getSelectCouse_name_id_teach().name
        self.dingweiLabel.text = nameStr
        dingweiLabel_btn.text = nameStr
        self.couseId = LogDataMangerViewController.getSelectCouse_name_id_teach().couseid
        self.dingweiBackView.isHidden = false
        self.dingweiLabel_btn.isHidden = false
        tdBtn.frame = CGRect(x: nsetBtn.frame.maxX + ip7 (10), y: 0, width: ip7(55), height: ip7(55))
        dingweiLabel_btn.frame = CGRect(x: tdBtn.frame.maxX + ip7(10), y: 0, width: KSCREEN_WIDTH - tdBtn.frame.maxX - ip7(100), height: ip7(55))
        self.tableView.frame.origin.y = ip7(15) + (self.dingweiBackView.frame.maxY)
        
    }
    
    func removedingwei_click() {
        
        alertController  = UIAlertController(title: "提示", message: "是否要删除定时定位", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            //取消
            self.alertController.dismiss(animated: true, completion: {
                
            })
        }
        let sureAction = UIAlertAction(title: "删除", style: .default) { (action) in
            LogDataMangerViewController.setSelectCouse_name_id_teach(name: "", couseid: "", ishaveinfo: "0")
            self.couseId = ""
            self.dingweiBackView.isHidden = true
            self.dingweiLabel_btn.isHidden = true
            self.tdBtn.frame =  CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25) - ip7(60), y: (ip7(55) - ip7(35))/2, width: ip7(35), height: ip7(35))
        }
        alertController.addAction(cancleAction)
        alertController.addAction(sureAction)
        self.present((alertController)!, animated: true, completion: nil)
        
    }
    
    //MARK:textView
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        txtStr = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.nestBtnClik()
        }
        return true
    }
    
    
    override func navigationLeftBtnClick() {
        KFBLog(message: "返回")
        if isLoading {
            return
        }
        self.dismiss(animated: true) {
            self.delAllFiles()
            if self.textField.isFirstResponder {
                self.SVdismiss()
                self.textField.resignFirstResponder()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url : NSURL =  NSURL(fileURLWithPath: openFileUrl)
        KFBLog(message: url)
        return url
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
