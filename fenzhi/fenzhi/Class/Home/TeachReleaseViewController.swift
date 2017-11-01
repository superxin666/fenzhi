//
//  TeachReleaseViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/7.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class TeachReleaseViewController: BaseViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,sureDelegate {
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
    
    var txtStr : String = ""
    var couseId : String = ""
    
    let dataVC = HomeDataMangerController()
    let loadVC = CommonDataMangerViewController()
    
    var fileManager = FileManager.default
    var alertController : UIAlertController!
    
    deinit {
        //记得移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {

        // Do any additional setup after loading the view
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        self.navigation_title_fontsize(name: "教学分享", fontsize: 27)
        self.view.backgroundColor = .white
        self.navigationBar_leftBtn()
        self.navigationBar_rightBtn_title(name: "发布")
        if LogDataMangerViewController.getSelectCouse_name_id_teach().name.characters.count > 0 {
            isHaveDingwei = true
            self.couseId = LogDataMangerViewController.getSelectCouse_name_id_teach().couseid
        } else {
            isHaveDingwei = false
        }
        self.getFileData()
        self.creatUI()
        

    }

    func getFileData() {
        
        if fileManager.fileExists(atPath: filePath) {
            let contentsOfPath = try? fileManager.contentsOfDirectory(atPath: filePath)
            self.fileArr = contentsOfPath!
            if self.fileArr.count > 0 {
                self.isHaveFiles = true
            }
            KFBLog(message: contentsOfPath!)
        } else {
            KFBLog(message: "文件夹不存在")
        }
    }

    //MARK:发布
    override func navigationRightBtnClick() {
        //weak
        weak var weakSelf = self
        if !nsetBtn.isSelected {
            self.nestBtnClik()
        }
        if !(txtStr.characters.count > 0) {
            self.SVshowErro(infoStr: "请输入文字")
            return
        }


        if fileArr.count>0 {
            if fileArr.count > 10 {
                self.SVshowErro(infoStr: "最多上传10个文件")
            }
            //有图片
            var num = 0
            for i in 0..<fileArr.count{
                let file : String = fileArr[i]
                self.SVshowLoad()
                self.loadVC.uploadfile(fileName: file, completion: { (data) in
                    let model :UpFileDataModel = data as! UpFileDataModel
                    if model.errno == 0 {
                        KFBLog(message: model.data)
                        num = num + 1
                        let dict :Dictionary = [
                            "name":model.data.name,
                            "type":model.data.type,
                            "file":model.data.file,
                            ]
                        self.fileNameArr.append(dict)
                        if num == self.fileArr.count{
                           self.subTxt(fileData: model.data)
                        }
                      
                    } else {
                        weakSelf?.SVshowErro(infoStr: model.errmsg)
                    }
                }, failure: { (erro) in
                    
                })
                
                
            }
            
        } else {
            self.SVshowErro(infoStr: "请选择要发布的文件")
        }


    }
    
    func subTxt(fileData : UpFileDataModel_data)  {
        weak var weakSelf = self

//        let dict :Dictionary = [
//            "name":fileData.name,
//            "type":fileData.type,
//            "file":fileData.file,
//        ]
//
//
//        let arr = [dict]
        
        dataVC.submitfenx_teach(content: txtStr, catalog_id: self.couseId, file: self.fileNameArr, completion: { (data) in
            let model :SmsModel = data as! SmsModel
            if model.errno == 0{
                weakSelf?.SVdismiss()
                weakSelf?.SVshowSucess(infoStr: "发布成功")
                weakSelf?.navigationLeftBtnClick()
            } else {
                weakSelf?.SVshowErro(infoStr: model.errmsg)
            }
        }) { (erro) in
            weakSelf?.SVdismiss()
            weakSelf?.SVshowErro(infoStr: "网络请求失败")
        }
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
        UIView.animate(withDuration: 1, animations: {
            var frame = self.btnBackView.frame
            frame.origin.y = KSCREEN_HEIGHT - height - ip7(55)
            self.btnBackView.frame = frame
//            self.keybodHeight = height
        })
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
//            btnBackView.frame.origin.y =  KSCREEN_HEIGHT  - btnBackView.frame.size.height
            self.view.addSubview(btnBackView)
            self.nestBtnClik()
//            self.view.bringSubview(toFront: btnBackView)
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
        nsetBtn.frame = CGRect(x: ip7(25), y: (ip7(55) - ip7(14))/2, width: ip7(25), height: ip7(14))
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_x"), for: .normal)
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_s"), for: .selected)
        nsetBtn.isSelected = false
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
        btnBackView.addSubview(dingweiLabel_btn)
        let nameStr : String = LogDataMangerViewController.getSelectCouse_name_id_teach().name
        if nameStr.characters.count > 0  {
            //有课时定位
            tdBtn.frame = CGRect(x: nsetBtn.frame.maxX + ip7 (10), y: 0, width: ip7(55), height: ip7(55))
        } else {
            dingweiLabel_btn.isHidden = true
            //没有课时定位
            tdBtn.frame =  CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25) - ip7(60), y: (ip7(55) - ip7(35))/2, width: ip7(35), height: ip7(35))
        }
        //图片按钮
        let picBtn : UIButton = UIButton(frame: CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25), y: 0, width: ip7(55), height: ip7(55)))
        picBtn.setImage(#imageLiteral(resourceName: "button_fj"), for: .normal)
        picBtn.backgroundColor = .clear
        picBtn.addTarget(self, action:#selector(self.pdf_click), for: .touchUpInside)
        btnBackView.addSubview(picBtn)
        
        let lineView = UIView(frame: CGRect(x: picBtn.frame.origin.x - ip7(12), y: (ip7(55) - ip7(35))/2, width: 0.5, height: ip7(35)))
        lineView.backgroundColor = .white
        btnBackView.addSubview(lineView)
        
    }
    //MARK:课时定位
    func creaDingweiBackView() {
        dingweiBackView.frame = CGRect(x: (KSCREEN_WIDTH - ip7(480))/2, y: ip7(13), width: ip7(480), height: ip7(70))
        dingweiBackView.backgroundColor = backView_COLOUR
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
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pdf"))
        imageView.frame = CGRect(x: 0, y: 0, width: ip7(65), height: ip7(65))
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
        let str = self.fileArr[indexPath.row]
        let filePathStr : String = filePath + "/" + str
        let vc = pdfViewController()
        vc.pdftype = .path
        vc.path = filePathStr
        vc.fileName = str
        self.navigationController?.pushViewController(vc, animated: true)
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
                    KFBLog(message: "文件删除成功")
                } catch _ {
                    KFBLog(message: "文件删除失败")
                }
            }
        }
        alertController.addAction(cancleAction)
        alertController.addAction(sureAction)
        self.present((alertController)!, animated: true, completion: nil)
        
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
        if !nsetBtn.isSelected {
            self.nestBtnClik()
        }
        let vc = DingweiViewControlleroc()
        let urlStr = BASER_API + selectCouse_api + "token=" + "".getToken_RSA()
        vc.mainUrl =  urlStr
        vc.delegate = self
        vc.isHeart = false
        self.navigationController?.pushViewController(vc, animated: true)
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

        self.dismiss(animated: true) {
            
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
