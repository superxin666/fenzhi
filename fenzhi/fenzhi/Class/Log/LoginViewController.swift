//
//  LoginViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/11.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController,UITextFieldDelegate {
    var dataModel : LoginModelMapper = LoginModelMapper()//
    let _phoneTextField : UITextField = UITextField()//手机号
    let _keyTextField : UITextField = UITextField()//密码
    var phoneStr : String = ""
    var keyStr : String = ""
    let dataVC :LogDataMangerViewController = LogDataMangerViewController()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.creatUI()
    }

    func creatUI()  {
        self.view.isUserInteractionEnabled = true
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        self.view.addGestureRecognizer(tap)
        
        let topImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH , height: ip7(375)))
        topImageView.image = #imageLiteral(resourceName: "bg03")
        self.view.addSubview(topImageView)

        let logIcon = UIImageView(frame: CGRect(x: (KSCREEN_WIDTH - ip7(105))/2, y: LNAVIGATION_HEIGHT, width: ip7(105), height: ip7(105)))
        logIcon.image = #imageLiteral(resourceName: "logo02")
        topImageView.addSubview(logIcon)


        //手机号码
        let phoneBackView = UIView(frame: CGRect(x: ip7(40), y: topImageView.frame.maxY, width: KSCREEN_WIDTH - ip7(80), height: ip7(45)))
        self.view.addSubview(phoneBackView)

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
        self.view.addSubview(scrBackView)

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

        //忘记密码
        let forgetBtn : UIButton = UIButton(frame: CGRect(x: scrBackView.frame.size.width - ip7(90), y: ip7(3), width: ip7(90), height: ip7(21)))
        forgetBtn.setTitle("忘记密码？", for: .normal)
        forgetBtn.backgroundColor = .clear
        forgetBtn.setTitleColor( blue_COLOUR, for: .normal)
        forgetBtn.titleLabel?.font = fzFont_Thin(ip7(18))
        forgetBtn.addTarget(self, action:#selector(LoginViewController.forget_clik), for: .touchUpInside)
        scrBackView.addSubview(forgetBtn)

        let lineView2 = UIView()
        let lineView2Y = scrBackView.frame.size.height - 0.5
        lineView2.frame = CGRect(x: 0, y: lineView2Y, width: scrBackView.frame.size.width, height: 0.5)
        lineView2.backgroundColor = FZColorFromRGB(rgbValue: 0xaaaaaa)
        scrBackView.addSubview(lineView2)




        //登录
        let logBtn : UIButton = UIButton(frame: CGRect(x: ip7(40), y: scrBackView.frame.maxY + ip7(52), width: KSCREEN_WIDTH - ip7(80), height: ip7(50)))
        logBtn.setTitle("登录", for: .normal)
        logBtn.backgroundColor = blue_COLOUR
        logBtn.setTitleColor( .white, for: .normal)
        logBtn.titleLabel?.font = fzFont_Thin(ip7(21))
        logBtn.addTarget(self, action:#selector(LoginViewController.login_click), for: .touchUpInside)
        self.view.addSubview(logBtn)

        //注册
        let regNameLabel : UIButton = UIButton(frame: CGRect(x: 0, y: KSCREEN_HEIGHT - ip7(72), width: KSCREEN_WIDTH, height: ip7(18)))

        regNameLabel.backgroundColor = .clear
        regNameLabel.setTitleColor(  FZColor(red: 105, green: 105, blue: 105, alpha: 1.0), for: .normal)
        regNameLabel.titleLabel?.font = fzFont_Thin(ip7(18))
        regNameLabel.addTarget(self, action:#selector(LoginViewController.registerBtnClick), for: .touchUpInside)
        self.view.addSubview(regNameLabel)
        

        let str : String  = "还没有账号?"
        let attributeStr = NSMutableAttributedString(string: str)
        let str2 : String  = "   马上注册"
        let attributeStr2 = NSMutableAttributedString(string: str2)
        let range : NSRange = NSRange.init(location: 0, length: str2.characters.count)
        attributeStr2.addAttribute(NSForegroundColorAttributeName, value: FZColor(red: 253, green: 122, blue: 207, alpha: 1.0), range: range)
        attributeStr.append(attributeStr2)
        regNameLabel.setAttributedTitle(attributeStr, for: .normal)
        
        



    }
    func endEdit() {
        self.view.endEditing(true)
    }
    func forget_clik()   {
        let vc = ForgetViewController()
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func registerBtnClick()  {
        print("注册")
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        

    }
    
    func login_click()  {
      
        if _phoneTextField.isFirstResponder {
            _phoneTextField.resignFirstResponder()
        }
        if _keyTextField.isFirstResponder {
            _keyTextField.resignFirstResponder()
        }
        if !(String.isStr(str: phoneStr)) {
            self.SVshowErro(infoStr: "请填写手机号")
            print("请填写手机号")
            return
        }
        if !(String.isMobileNumber(phoneNum: phoneStr)) {
            self.SVshowErro(infoStr: "请填写正确手机号")
             print("请填写正确手机号")

            return
        }
        if keyStr.characters.count < 6 {
            self.SVshowErro(infoStr: "密码至少六位")
            print("密码至少六位")
            return
        }
        print("登录")
        //"YuYDThdAlCw%2FAVszVVdT4HEld43gusD%2F6JtR1kBW6vyxu8gfkptQDUtiRAeA0lAF0Jy3Ull5eWQ2JcKa5wKHWtVR8RiBauqiedkUeyznS9ByLeGZSUtTq41mSAMd51%2Fljc8dFbmAajKHgaFrqukCko1PSr03YPdvoCv3pFYzHFw%3D"
        self.SVshowLoad()
        weak var weakSelf = self
        dataVC.login(phoneNum: phoneStr, paseWord: keyStr, completion: { (data) in
            weakSelf?.SVdismiss()
            weakSelf?.dataModel = data as! LoginModelMapper
            print(String(describing: weakSelf?.dataModel.errno))
            print("名字"+String(describing: weakSelf?.dataModel.data.name))

            if weakSelf?.dataModel.errno == 0 {
                var ishaveInfo = "0"
                if (weakSelf?.dataModel.data.name.count)! > 0{
                    ishaveInfo = "1"
                }
                KFBLog(message:  (weakSelf?.dataModel.data.token)!)
                LoginModelMapper.setLoginIdAndTokenInUD(loginUserId: "\((weakSelf?.dataModel.data.id)!)", token:  (weakSelf?.dataModel.data.token)!, ishaveinfo: ishaveInfo, userType: "\((weakSelf?.dataModel.data.type)!)", complate: { (data) in
                    let str:String = data as! String
                    if str == "1" {
                        //登陆成功
                        let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
                        dele.mainMenu()
                    } else {
                        //存储信息失败
                    }
                })
   

            } else {
                weakSelf?.SVshowErro(infoStr: (weakSelf?.dataModel.errmsg)!)
            }
            
        }) { (error) in
            weakSelf?.SVdismiss()
            weakSelf?.SVshowErro(infoStr: "请求失败")
        }
    }
    
    
    // MARK: textFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        switch tag {
        case 100:
            print("手机号：\(String(describing: textField.text))")
            phoneStr = textField.text!
        case 101:
            print("密码:\(String(describing: textField.text))")
            keyStr = textField.text!
        default:
            print("既不是手机号也不是密码")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == _keyTextField {
            self.login_click()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if needUp {
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
//                self.topConstraint?.update(offset: ip6(10))
//                self.midConstraint?.update(offset: ip6(50))
//                self.view.layoutIfNeeded()
//            }) { (ture) in
//                self.needUp = false
//            }
//            
//        } else {
//            
//        }
        
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
