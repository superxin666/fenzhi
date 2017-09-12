//
//  LoginViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/11.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController,UITextFieldDelegate {
    let _phoneTextField : UITextField = UITextField()//手机号
    let _keyTextField : UITextField = UITextField()//密码
    let dataVC :LogDataMangerViewController = LogDataMangerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.creatUI()

    }

    func creatUI()  {
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
        //        logBtn.addTarget(self, action:#selector(HomeViewController.heartBtnClick), for: .touchUpInside)
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
        let regNameLabel : UILabel = UILabel(frame: CGRect(x: 0, y: KSCREEN_HEIGHT - ip7(72), width: KSCREEN_WIDTH, height: ip7(18)))
        regNameLabel.font = fzFont_Thin(ip7(18))
        regNameLabel.textColor  = FZColor(red: 105, green: 105, blue: 105, alpha: 1.0)
        regNameLabel.textAlignment = .center
        regNameLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(regNameLabel)

        let str : String  = "还没有账号?"
        let attributeStr = NSMutableAttributedString(string: str)
        let str2 : String  = "   马上注册"
        let attributeStr2 = NSMutableAttributedString(string: str2)
        let range : NSRange = NSRange.init(location: 0, length: str2.characters.count)
        attributeStr2.addAttribute(NSForegroundColorAttributeName, value: FZColor(red: 253, green: 122, blue: 207, alpha: 1.0), range: range)
        attributeStr.append(attributeStr2)
        regNameLabel.attributedText = attributeStr



    }
    
    func login_click()  {
        dataVC.login(phoneNum: "15910901725", paseWord: "X%2FT5%2FeCwmOI%2Bk9PUAJuHuetyH1N26or%2FNudMvHTY0hTysLE5CAgDAAdhMRgSsgmzcwwTP9ECUSf9kYtH2zGHDsEuddHre5A9xs3emr899gEOH4cRBgekb35rAMAtOyJevxB%2FAX%2BwoZnFj2k0ve4tgcWnRVxMaKQmxPlnWfSviKY%3D", completion: { (data) in
            print("ok")
        }) { (error) in
            
        }
        
//        dataVC.register(phoneNum: "18514618956", paseWord: "123456", verification: "123456", completion: { (data) in
//            
//        }) { (error) in
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
