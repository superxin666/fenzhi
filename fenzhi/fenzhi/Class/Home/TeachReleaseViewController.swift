//
//  TeachReleaseViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/7.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class TeachReleaseViewController: BaseViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {
    let textField: UITextView = UITextView()
    let btnBackView :UIView = UIView()
    let imageBackView :UIView = UIView()
    var fileArr :[String]  = Array()
    
    
    
    let nsetBtn : UIButton = UIButton()
    var keybodHeight : CGFloat = 0.0
    
    var isHaveBackView = false//中间背景
    var isHaveBtnBackView = false//是否已经有了 按钮栏
    var isHaveImageViewBackView = false//是否已经有了 图片栏
    var isHaveDingweiBackView = false//是否已经有了 定位
    var tableView : UITableView = UITableView()//文件浏览
    var dingweiLabel : UILabel = UILabel()//定位显示
    
    var txtStr : String = ""
    let dataVC = HomeDataMangerController()
    let loadVC = CommonDataMangerViewController()
    
    deinit {
        //记得移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {

//        self.navigationBar_rightBtn_title(name: "发布")
        // Do any additional setup after loading the view
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        self.navigation_title_fontsize(name: "教学分享", fontsize: 27)
        self.view.backgroundColor = .white
        self.navigationBar_leftBtn()
        self.navigationBar_rightBtn_title(name: "发布")
        self.creatUI()


    }

    //MARK:发布
    override func navigationRightBtnClick() {
        //weak
        weak var weakSelf = self
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        if !(txtStr.characters.count > 0) {
            self.SVshowErro(infoStr: "请输入文字")
            return
        }
        
//        if imageArr.count>0 {
//            //有图片
//            let image = imageArr[0]
//            self.SVshowLoad()
//            loadVC.upLoadImage(uploadimg: image, type: "normal", completion: { (data) in
//                let model :UploadimgModel = data as! UploadimgModel
//                if model.errno == 0 {
//                    KFBLog(message: model.data)
//                    self.subTxt(imageStr: model.data)
//                } else {
//                    weakSelf?.SVshowErro(infoStr: model.errmsg)
//                }
//
//
//            }, failure: { (erro) in
//                weakSelf?.SVdismiss()
//            })
//
//        }
        
    }
    
    func subTxt(imageStr : String)  {
        weak var weakSelf = self
        
        let arr = [imageStr]
        
        dataVC.submitfenx_heart(content: txtStr, catalog_id: 0, images: arr, completion: { (data) in
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
            self.keybodHeight = height
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
        textField.becomeFirstResponder()
        textField.backgroundColor = .clear
        textField.font =  fzFont_Thin(ip7(18))
        self.view.addSubview(textField)
        
        
        
    }
    
    //MARK:中间背景
    func creatBackView() {
        isHaveBackView = true
        //中间打背景
        imageBackView.frame =  CGRect(x: 0, y: KSCREEN_HEIGHT - keybodHeight , width: KSCREEN_WIDTH, height: keybodHeight)
        imageBackView.backgroundColor = .white
        self.view.addSubview(imageBackView)
        self.view.bringSubview(toFront: self.btnBackView)
    }
    
    //MARK:按钮
    func creatBtnView() {
        
        //按钮
        KFBLog(message: "asdf--\(keybodHeight)")
        isHaveBtnBackView = true
        //KSCREEN_HEIGHT - keybodHeight - LNAVIGATION_HEIGHT
        btnBackView.frame =  CGRect(x: 0, y: KSCREEN_HEIGHT , width: KSCREEN_WIDTH, height: ip7(55))
        btnBackView.backgroundColor = blue_COLOUR
        //
        nsetBtn.frame = CGRect(x: ip7(25), y: (ip7(55) - ip7(14))/2, width: ip7(25), height: ip7(14))
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_x"), for: .normal)
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_s"), for: .selected)
        nsetBtn.isSelected = false
        nsetBtn.backgroundColor = .clear
        nsetBtn.addTarget(self, action:#selector(TeachReleaseViewController.nestBtnClik), for: .touchUpInside)
        btnBackView.addSubview(nsetBtn)
        
        
        let picBtn : UIButton = UIButton(frame: CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25), y: 0, width: ip7(55), height: ip7(55)))
        picBtn.setImage(#imageLiteral(resourceName: "icon_tp"), for: .normal)
        picBtn.backgroundColor = .clear
        picBtn.addTarget(self, action:#selector(TeachReleaseViewController.pdf_click), for: .touchUpInside)
        btnBackView.addSubview(picBtn)
        
        let tdBtn : UIButton = UIButton(frame: CGRect(x: picBtn.frame.origin.x - ip7(60), y: (ip7(55) - ip7(35))/2, width: ip7(35), height: ip7(35)))
        tdBtn.setImage(#imageLiteral(resourceName: "icon_dw2"), for: .normal)
        tdBtn.backgroundColor = .clear
        tdBtn.addTarget(self, action:#selector(TeachReleaseViewController.dingwei_click), for: .touchUpInside)
        btnBackView.addSubview(tdBtn)
        
        let lineView = UIView(frame: CGRect(x: tdBtn.frame.maxX + ip7(12), y: (ip7(55) - ip7(35))/2, width: 0.5, height: ip7(35)))
        lineView.backgroundColor = .white
        btnBackView.addSubview(lineView)
        
    }
    //MARK:课时定位
    func creaDingweiBackView() {
        if !isHaveBackView {
            self.creatBackView()
        }
        isHaveDingweiBackView = true
        let dingweiBackView = UIView(frame: CGRect(x: (KSCREEN_WIDTH - ip7(480))/2, y: ip7(6), width: ip7(480), height: ip7(70)))
        dingweiBackView.backgroundColor = backView_COLOUR
        imageBackView.addSubview(dingweiBackView)
        
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: ip7(35)/2, width: ip7(35), height: ip7(35)))
        iconImageView.image = #imageLiteral(resourceName: "icon_dingwei")
        dingweiBackView.addSubview(iconImageView)
        
        dingweiLabel.frame =  CGRect(x: iconImageView.frame.maxX + ip7(10), y: ip7(70 - 21)/2, width:  dingweiBackView.frame.width - ip7(10) - iconImageView.frame.maxX , height: ip7(21))
        dingweiLabel.font = fzFont_Thin(ip7(21))
        dingweiLabel.textColor  = blue_COLOUR
        dingweiLabel.backgroundColor = .clear
        dingweiLabel.textAlignment = .left
        dingweiLabel.adjustsFontSizeToFitWidth = true
        dingweiBackView.addSubview(dingweiLabel)
        
    }
    //MARK:展示文件
    func creatImageView() {
        if !isHaveBackView {
            self.creatBackView()
        }
        self.isHaveImageViewBackView = true
        KFBLog(message: "文件选择背景")
        tableView.frame = CGRect(x: 15, y: ip7(165/2), width: KSCREEN_WIDTH-30, height: keybodHeight - ip7(165/2) - ip7(55))
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "pdfcell")
        cell.textLabel?.text = "123"
        return cell
        
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = TeachDetailViewController()
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return ip7(65);
    }
    
    //MARK:文件点击
    func pdf_click() {
        let vc :PdfListViewController = PdfListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    
    //MARK:退出键盘
    func nestBtnClik()  {
        KFBLog(message: "退出键盘")
        nsetBtn.isSelected = !nsetBtn.isSelected
        if  nsetBtn.isSelected {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
            self.view.bringSubview(toFront: btnBackView)
            btnBackView.frame.origin.y =  KSCREEN_HEIGHT  - btnBackView.frame.size.height
        } else {
            textField.becomeFirstResponder()
            self.view.bringSubview(toFront: btnBackView)
            btnBackView.frame.origin.y =  KSCREEN_HEIGHT - keybodHeight - LNAVIGATION_HEIGHT
            
        }
    }
    
    //MARK:课时定位
    func dingwei_click() {
        KfbShowWithInfo(titleString: "定位")
        let vc = DingweiViewController()
        vc.sureBlock = {(name : String) in
            if self.isHaveDingweiBackView {
                self.dingweiLabel.text = name
            } else {
                self.dingweiLabel.text = name
                self.creaDingweiBackView()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:选择文件
    
    
    
    //MARK:textView
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        txtStr = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
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
