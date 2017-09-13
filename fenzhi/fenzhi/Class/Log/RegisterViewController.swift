//
//  RegisterViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/13.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController ,UITextFieldDelegate{
    

    let _phoneTextField : UITextField = UITextField()//手机号
    let _keyTextField : UITextField = UITextField()//密码
    let codeTextField : UITextField = UITextField()//密码
    var phoneStr : String = ""
    var keyStr : String = ""
    var codeStr : String = ""//验证码
    
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
        _phoneTextField.tag = 100
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
        _keyTextField.tag = 101
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
        codeTextField.tag = 102
        //        _keyTextField.backgroundColor = .red
        _keyTextField.font =  fzFont_Thin(ip7(18))
        _keyTextField.adjustsFontSizeToFitWidth = true
        codekView.addSubview(codeTextField)
        
        //验证密码
        let forgetBtn : UIButton = UIButton(frame: CGRect(x: codekView.frame.size.width - ip7(90), y: ip7(3), width: ip7(90), height: ip7(21)))
        forgetBtn.setTitle("发送验证码", for: .normal)
        forgetBtn.backgroundColor = .clear
        forgetBtn.setTitleColor( blue_COLOUR, for: .normal)
        forgetBtn.titleLabel?.font = fzFont_Thin(ip7(18))
        //        logBtn.addTarget(self, action:#selector(HomeViewController.heartBtnClick), for: .touchUpInside)
        codekView.addSubview(forgetBtn)
        
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
    
    
    func nest_click()  {
        
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
