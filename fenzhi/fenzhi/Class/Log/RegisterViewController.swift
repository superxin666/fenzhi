//
//  RegisterViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/13.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController ,UITextFieldDelegate{
    
    let dataVC :LogDataMangerViewController = LogDataMangerViewController()
    var dataModel : SmsModel = SmsModel()//
    let _phoneTextField : UITextField = UITextField()//手机号
    let _keyTextField : UITextField = UITextField()//密码
    let codeTextField : UITextField = UITextField()//密码
    var phoneStr : String = ""
    var keyStr : String = ""
    var codeStr : String = ""//验证码
    
    let getCodeBtn : UIButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.navigation_title_fontsize(name: "注册", fontsize: 27)
        self.creatUI()
    }
    
    
    
    func creatUI()  {
        let backView = UIView(frame: CGRect(x: 0, y: LNAVIGATION_HEIGHT + ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - LNAVIGATION_HEIGHT - ip7(15)))
        backView.backgroundColor = .white
        self.view.addSubview(backView)
        
        //手机号码
        let phoneBackView = UIView(frame: CGRect(x: ip7(40), y: ip7(47), width: KSCREEN_WIDTH - ip7(80), height: ip7(45)))
        backView.addSubview(phoneBackView)
        
        let phoneNameLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: ip7(84), height: ip7(21)))
        phoneNameLabel.text = "手机号码"
        phoneNameLabel.font = fzFont_Thin(ip7(21))
        phoneNameLabel.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        phoneNameLabel.textAlignment = .left
        phoneNameLabel.adjustsFontSizeToFitWidth = true
        phoneBackView.addSubview(phoneNameLabel)
        
        let standView = UIView()
        standView.frame = CGRect(x: phoneNameLabel.frame.maxX + ip7(20), y: ip7(1), width: 0.5, height: ip7(19))
        standView.backgroundColor = FZColorFromRGB(rgbValue: 0xaaaaaa)
        phoneBackView.addSubview(standView)
        
        let viewWidth : CGFloat = phoneBackView.frame.size.width - ip7(84)
        _phoneTextField.frame = CGRect(x: standView.frame.maxX + ip7(20), y: 0, width: viewWidth - ip7(40), height: ip7(21))
        //设置placeholder的属性
        //        var attributes:[String : Any] = NSDictionary() as! [String : Any]
        //        attributes[NSFontAttributeName] = UIFont.systemFont(ofSize: ip7(18))
        //        let string:NSAttributedString = NSAttributedString.init(string: "输入手机号", attributes: attributes)
        //        _phoneTextField.attributedPlaceholder = string
        _phoneTextField.adjustsFontSizeToFitWidth = true
        _phoneTextField.textAlignment = .left
        _phoneTextField.keyboardType = .numberPad
        _phoneTextField.returnKeyType = .next
        _phoneTextField.delegate = self;
        _phoneTextField.tag = 1
        //        _phoneTextField.backgroundColor = .red
        phoneBackView.addSubview(_phoneTextField)
        
        let lineView = UIView()
        let lineViewY = phoneBackView.frame.size.height - 0.5
        lineView.frame = CGRect(x: 0, y: lineViewY, width: phoneBackView.frame.size.width, height: 0.5)
        lineView.backgroundColor = FZColorFromRGB(rgbValue: 0xaaaaaa)
        phoneBackView.addSubview(lineView)
        
        //账号密码
        let scrBackView = UIView(frame: CGRect(x: ip7(40), y: phoneBackView.frame.maxY + ip7(47), width: KSCREEN_WIDTH - ip7(80), height: ip7(45)))
        backView.addSubview(scrBackView)
        
        let scrNameLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: ip7(84), height: ip7(21)))
        scrNameLabel.text = "账号密码"
        scrNameLabel.font = fzFont_Thin(ip7(21))
        scrNameLabel.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        scrNameLabel.textAlignment = .left
        scrNameLabel.adjustsFontSizeToFitWidth = true
        scrBackView.addSubview(scrNameLabel)
        
        let standView2 = UIView()
        standView2.frame = CGRect(x: scrNameLabel.frame.maxX + ip7(20), y: ip7(1), width: 0.5, height: ip7(19))
        standView2.backgroundColor = FZColorFromRGB(rgbValue: 0xaaaaaa)
        scrBackView.addSubview(standView2)
        
        _keyTextField.frame = CGRect(x: standView2.frame.maxX + ip7(20), y: ip7(3), width: viewWidth - ip7(40) - ip7(90), height: ip7(21))
        //      设置placeholder的属性
        var attributes2:[String : Any] = NSDictionary() as! [String : Any]
        attributes2[NSFontAttributeName] = fzFont_Thin(ip7(18))
        let string2:NSAttributedString = NSAttributedString.init(string: "请输入6-20位密码", attributes: attributes2)
        _keyTextField.attributedPlaceholder = string2
        _keyTextField.adjustsFontSizeToFitWidth = true
        _keyTextField.textAlignment = .left
        _keyTextField.returnKeyType = .done
        _keyTextField.isSecureTextEntry = true
        _keyTextField.delegate = self
        _keyTextField.tag = 3
        //        _keyTextField.backgroundColor = .red
        _keyTextField.font =  fzFont_Thin(ip7(18))
        _keyTextField.adjustsFontSizeToFitWidth = true
        scrBackView.addSubview(_keyTextField)
        let lineView2 = UIView()
        let lineView2Y = scrBackView.frame.size.height - 0.5
        lineView2.frame = CGRect(x: 0, y: lineView2Y, width: scrBackView.frame.size.width, height: 0.5)
        lineView2.backgroundColor = FZColorFromRGB(rgbValue: 0xaaaaaa)
        scrBackView.addSubview(lineView2)
        
        //验证码
        

        let codekView = UIView(frame: CGRect(x: ip7(40), y: scrBackView.frame.maxY + ip7(47), width: KSCREEN_WIDTH - ip7(80), height: ip7(45)))
        backView.addSubview(codekView)
        
        let codeNameLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: ip7(84), height: ip7(21)))
        codeNameLabel.text = "验证码"
        codeNameLabel.font = fzFont_Thin(ip7(21))
        codeNameLabel.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        codeNameLabel.textAlignment = .left
        codeNameLabel.adjustsFontSizeToFitWidth = true
        codekView.addSubview(codeNameLabel)
        
        let standView3 = UIView()
        standView3.frame = CGRect(x: codeNameLabel.frame.maxX + ip7(20), y: ip7(1), width: 0.5, height: ip7(19))
        standView3.backgroundColor = FZColorFromRGB(rgbValue: 0xaaaaaa)
        codekView.addSubview(standView3)
        
        codeTextField.frame = CGRect(x: standView2.frame.maxX + ip7(20), y: ip7(3), width: viewWidth - ip7(40) - ip7(90), height: ip7(21))
        //      设置placeholder的属性
        var attributes3:[String : Any] = NSDictionary() as! [String : Any]
        attributes3[NSFontAttributeName] = fzFont_Thin(ip7(18))
        let string3:NSAttributedString = NSAttributedString.init(string: "请输入验证码", attributes: attributes3)
        codeTextField.attributedPlaceholder = string3
        codeTextField.adjustsFontSizeToFitWidth = true
        codeTextField.textAlignment = .left
        codeTextField.returnKeyType = .done
        codeTextField.isSecureTextEntry = true
        codeTextField.delegate = self
        codeTextField.tag = 2
        //        _keyTextField.backgroundColor = .red
        _keyTextField.font =  fzFont_Thin(ip7(18))
        _keyTextField.adjustsFontSizeToFitWidth = true
        codekView.addSubview(codeTextField)
        
        //验证密码
        getCodeBtn.frame =  CGRect(x: codekView.frame.size.width - ip7(90), y: ip7(3), width: ip7(90), height: ip7(21))
        getCodeBtn.setTitle("发送验证码", for: .normal)
        getCodeBtn.backgroundColor = .clear
        getCodeBtn.setTitleColor( blue_COLOUR, for: .normal)
        getCodeBtn.titleLabel?.font = fzFont_Thin(ip7(18))
        getCodeBtn.addTarget(self, action:#selector(RegisterViewController.getCodeBtnClick), for: .touchUpInside)
        codekView.addSubview(getCodeBtn)
        
        let lineView3 = UIView()
        let lineView3Y = codekView.frame.size.height - 0.5
        lineView3.frame = CGRect(x: 0, y: lineView3Y, width: codekView.frame.size.width, height: 0.5)
        lineView3.backgroundColor = FZColorFromRGB(rgbValue: 0xaaaaaa)
        codekView.addSubview(lineView3)
        
        
//        //登录
        let logBtn : UIButton = UIButton(frame: CGRect(x: ip7(40), y: codekView.frame.maxY + ip7(52), width: KSCREEN_WIDTH - ip7(80), height: ip7(50)))
        logBtn.setTitle("下一步", for: .normal)
        logBtn.backgroundColor = blue_COLOUR
        logBtn.setTitleColor( .white, for: .normal)
        logBtn.titleLabel?.font = fzFont_Thin(ip7(21))
        logBtn.addTarget(self, action:#selector(RegisterViewController.nest_click), for: .touchUpInside)
        backView.addSubview(logBtn)
        
    }
    
    //MARK:获取验证码
    func getCodeBtnClick() {
        _phoneTextField.resignFirstResponder()
        KFBLog(message: phoneStr)
        if !(String.isStr(str: phoneStr)) {
            KFBLog(message: "请填写手机号")
            self.KfbShowWithInfo(titleString: "请填写手机号")
            return
        } else {
            KFBLog(message: "手机号已经填写")
        }
        if !(String.isMobileNumber(phoneNum: phoneStr)) {
            KFBLog(message: "请填写正确手机号")
            self.KfbShowWithInfo(titleString: "请填写正确手机号")
            return
        } else {
            KFBLog(message: "手机号正确")
        }
        KFBLog(message: "获取验证码点击")
        getCodeBtn.isUserInteractionEnabled = false
        getCodeBtn.setTitle("发送中", for: .normal)
        getCodeBtn.setTitleColor(dark_105_COLOUR, for: .normal)
        getCodeBtn.isUserInteractionEnabled = false
        weak var weakself = self

        dataVC.get_sms_code(phoneNum: phoneStr, type: "register", completion: { (data) in

            weakself?.getCodeBtn.isUserInteractionEnabled = true
            weakself?.dataModel = data as! SmsModel
            print(String(describing: weakself?.dataModel.errno))
            if weakself?.dataModel.errno == 0{
                weakself?.getCodeBtn.setTitle("发送成功", for: .normal)
                weakself?.getCodeBtn.setTitleColor(blue_COLOUR, for: .normal)
            } else {
                weakself?.getCodeBtn.setTitle("重新发送", for: .normal)
                weakself?.getCodeBtn.setTitleColor(blue_COLOUR, for: .normal)

            }
            
        }) { (erro) in
            weakself?.getCodeBtn.setTitle("重新发送", for: .normal)
            weakself?.getCodeBtn.setTitleColor(blue_COLOUR, for: .normal)
            
        }
        
    }

    
    //MARK:下一步
    func nest_click()  {
//        if _phoneTextField.isFirstResponder {
//            _phoneTextField.resignFirstResponder()
//        } else if codeTextField.isFirstResponder {
//            codeTextField.resignFirstResponder()
//        } else {
//            _keyTextField.resignFirstResponder()
//        }
//        
//        if !(String.isStr(str: phoneStr)) {
//            KFBLog(message: "请填写手机号")
//            self.KfbShowWithInfo(titleString: "请填写手机号")
//            return
//        }
//        if !(String.isMobileNumber(phoneNum: phoneStr)) {
//            KFBLog(message: "请填写正确手机号")
//            self.KfbShowWithInfo(titleString: "请填写正确手机号")
//            return
//        }
//        if !(String.isStr(str: codeStr)) {
//            KFBLog(message: "请填写验证码")
//            self.KfbShowWithInfo(titleString: "请填写验证码")
//            return
//        }
//        if !(String.isStr(str: keyStr)) {
//            KFBLog(message: "请填写密码")
//            self.KfbShowWithInfo(titleString: "请填写密码")
//            return
//        }
//        if keyStr.characters.count < 6 {
//            KFBLog(message: "密码至少六位")
//            self.KfbShowWithInfo(titleString: "密码至少六位")
//            return
//            
//        }
//        
//        if keyStr.characters.count > 20 {
//            KFBLog(message: "密码不能超过20位")
//            self.KfbShowWithInfo(titleString: "密码不能超过20位")
//            return
//            
//        }
        
        let vc : InfoViewController = InfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        

        
    }

    override func navigationLeftBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        //页面下降
//        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
//            self.topConstraint.constant = ip6(71)
//            self.midConstraint.constant = ip6(99)
//            self.view.setNeedsLayout()
//            self.view.setNeedsUpdateConstraints()
//        }) { (ture) in
//            
//        }
        switch textField.tag {
        case 1:
            phoneStr = textField.text!
        case 2:
            codeStr = textField.text!
        case 3:
            keyStr = textField.text!
            textField.resignFirstResponder()
        default:
            print("没有键盘")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if _phoneTextField.isFirstResponder {
            _phoneTextField.resignFirstResponder()
        } else if codeTextField.isFirstResponder {
            codeTextField.resignFirstResponder()
        } else {
            _keyTextField.resignFirstResponder()
        }
        //页面下降
//        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
//            self.topConstraint.constant = ip6(71)
//            self.midConstraint.constant = ip6(99)
//            self.view.setNeedsLayout()
//            self.view.setNeedsUpdateConstraints()
//        }) { (ture) in
//            
//        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
//            //self.view.transform = CGAffineTransform(translationX: 0, y: -120)
//            self.topConstraint.constant = ip6(10)
//            self.midConstraint.constant = ip6(50)
//            self.view.setNeedsLayout()
//            self.view.setNeedsUpdateConstraints()
//        }) { (ture) in
//            
//        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 1:
            phoneStr = textField.text!
        case 2:
            codeStr = textField.text!
        case 3:
            keyStr = textField.text!
        default:
            print("没有键盘")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 1:
            phoneStr = textField.text!
        case 2:
            codeStr = textField.text!
        case 3:
            keyStr = textField.text!
            _keyTextField.resignFirstResponder()
        default:
            print("没有键盘")
        }
        return true
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
