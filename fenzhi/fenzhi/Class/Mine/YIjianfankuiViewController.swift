//
//  YIjianfankuiViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/10/25.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class YIjianfankuiViewController: BaseViewController,UITextViewDelegate,UITextFieldDelegate {
    let textField: UITextView = UITextView()
    let _phoneTextField : UITextField = UITextField()//手机号
    let plaLabel : UILabel = UILabel()//提示label
    
    var textStr : String = ""
    var phoneStr : String = ""
    
    let dataVC : CommonDataMangerViewController = CommonDataMangerViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigation_title_fontsize(name: "意见反馈", fontsize: 27)
        self.navigationBar_leftBtn()
        self.view.backgroundColor = backView_COLOUR
        self.creatUI()
        // Do any additional setup after loading the view.
    }
    
    
    func creatUI()  {
        let topBackView : UIView = UIView(frame: CGRect(x: 0, y: LNAVIGATION_HEIGHT + ip7(15), width: KSCREEN_WIDTH, height: ip7(320)))
        topBackView.backgroundColor = .white
        self.view.addSubview(topBackView)
        
        let icon1 : UIImageView = UIImageView(frame: CGRect(x: ip7(32), y: ip7(32), width: ip7(19), height: ip7(21)))
        icon1.image = #imageLiteral(resourceName: "icon_bianji")
        topBackView.addSubview(icon1)
        
        textField.frame = CGRect(x: icon1.frame.maxX + ip7(21), y: ip7(32), width: KSCREEN_WIDTH - ip7(32) - icon1.frame.maxX - ip7(21), height: ip7(200))
        textField.textAlignment = .left
        textField.returnKeyType = .done
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.font =  fzFont_Thin(ip7(18))
        textField.textColor = dark_3_COLOUR
        topBackView.addSubview(textField)
        
        let bottomBackView : UIView = UIView(frame: CGRect(x: 0, y: topBackView.frame.maxY + ip7(15), width: KSCREEN_WIDTH, height: ip7(200)))
        bottomBackView.backgroundColor = .white
        self.view.addSubview(bottomBackView)
        
        let icon2 : UIImageView = UIImageView(frame: CGRect(x: ip7(32), y: ip7(32), width: ip7(19), height: ip7(21)))
        icon2.image = #imageLiteral(resourceName: "icon_sjh")
        bottomBackView.addSubview(icon2)
        
        
        _phoneTextField.frame = CGRect(x: icon2.frame.maxX + ip7(21), y: ip7(32), width: KSCREEN_WIDTH - ip7(32) - icon2.frame.maxX - ip7(21), height: ip7(21))
        //设置placeholder的属性
        //        var attributes:[String : Any] = NSDictionary() as! [String : Any]
        //        attributes[NSFontAttributeName] = UIFont.systemFont(ofSize: ip7(18))
        //        let string:NSAttributedString = NSAttributedString.init(string: "输入手机号", attributes: attributes)
        //        _phoneTextField.attributedPlaceholder = string
        _phoneTextField.adjustsFontSizeToFitWidth = true
        _phoneTextField.textAlignment = .left
        _phoneTextField.keyboardType = .default
        _phoneTextField.returnKeyType = .done
        _phoneTextField.delegate = self;
        _phoneTextField.tag = 100
        _phoneTextField.placeholder = "请输入您的手机号或邮箱，方便我们联系"
        _phoneTextField.font = fzFont_Thin(ip7(18))
        _phoneTextField.textColor = dark_3_COLOUR
        //        _phoneTextField.backgroundColor = .red
        bottomBackView.addSubview(_phoneTextField)
        
        
        //提交按钮
        let subBtn : UIButton = UIButton(frame: CGRect(x: 0, y: bottomBackView.frame.maxY + ip7(15), width: KSCREEN_WIDTH, height: ip7(75)))
        subBtn.setTitle("提交反馈", for: .normal)
        subBtn.backgroundColor = .white
        subBtn.setTitleColor(.white, for: .normal)
        subBtn.titleLabel?.font = fzFont_Thin(ip7(24))
        subBtn.addTarget(self, action:#selector(self.sub_click), for: .touchUpInside)
        subBtn.backgroundColor = blue_COLOUR
        self.view.addSubview(subBtn)
        
    }
    
    func sub_click() {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        if _phoneTextField.isFirstResponder{
            _phoneTextField.resignFirstResponder()
        }
        KFBLog(message: textStr)
        KFBLog(message: phoneStr)
        if !(textStr.characters.count > 0) {
            self.SVshowErro(infoStr: "请填写意见")
            return
        }
        if !(phoneStr.characters.count > 0) {
            self.SVshowErro(infoStr: "请填写联系方式")
            return
        }
        self.SVshowLoad()
        weak var weakSelf = self
        dataVC.feedback(content: textStr, contact: phoneStr, completion: { (data) in
            weakSelf?.SVdismiss()
            let dataModel = data as! SmsModel
            if dataModel.errno == 0 {
                weakSelf?.navigationLeftBtnClick()
            }
        }) { (erro) in
            weakSelf?.SVdismiss()
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("手机号：\(String(describing: textField.text))")
        phoneStr = textField.text!
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        textStr = textView.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sub_click()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.characters.count  == 0 {
            KFBLog(message: "没有字")
        } else {
            
            KFBLog(message: "有字")
        }
        return true
    }
    
    
    override func navigationLeftBtnClick() {
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
