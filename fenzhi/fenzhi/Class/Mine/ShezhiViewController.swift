//
//  ShezhiViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/18.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class ShezhiViewController: BaseViewController {
    var fileManager = FileManager.default
    let dataVC : LogDataMangerViewController = LogDataMangerViewController()
    var dataModel : SmsModel = SmsModel()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.navigation_title_fontsize(name: "设置", fontsize: 27)
        self.creatUI()
    }
    func creatUI() {
        //清除换存
        let backView1 = UIView(frame: CGRect(x: 0, y:LNAVIGATION_HEIGHT +  ip7(15), width: KSCREEN_WIDTH, height: ip7(90)))
        backView1.backgroundColor = .white
        backView1.isUserInteractionEnabled = true
        self.view.addSubview(backView1)

        let iconImageView:UIImageView = UIImageView(frame: CGRect(x: ip7(31), y:  (ip7(90) - ip7(40))/2, width: ip7(40), height: ip7(40) ))
        iconImageView.image = #imageLiteral(resourceName: "icon_qchc")
        iconImageView.isUserInteractionEnabled = true
        backView1.addSubview(iconImageView)

        let monyLabel : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(27), y: (ip7(90) - ip7(24))/2, width: ip7(200), height: ip7(24)))
        monyLabel.text = "清除缓存"
        monyLabel.isUserInteractionEnabled = true
        monyLabel.textColor = dark_3_COLOUR
        monyLabel.font = fzFont_Thin(ip7(24))
        monyLabel.textAlignment = .left
        backView1.addSubview(monyLabel)
        
        let cleantap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.clen_click))
        backView1.addGestureRecognizer(cleantap)

        //意见反馈
        let backView2 = UIView(frame: CGRect(x: 0, y:backView1.frame.maxY + ip7(15), width: KSCREEN_WIDTH, height: ip7(90)))
        backView2.isUserInteractionEnabled = true
        backView2.backgroundColor = .white
        self.view.addSubview(backView2)
        let tap2 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.yijian_click))
        backView2.addGestureRecognizer(tap2)

        let iconImageView2:UIImageView = UIImageView(frame: CGRect(x: ip7(31), y:  (ip7(90) - ip7(40))/2, width: ip7(40), height: ip7(40) ))
        iconImageView2.image = #imageLiteral(resourceName: "icon_yjfk")
        iconImageView2.isUserInteractionEnabled = true
        backView2.addSubview(iconImageView2)

        let monyLabel2 : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(27), y:   (ip7(90) - ip7(24))/2, width: ip7(200), height: ip7(24)))
        monyLabel2.text = "意见反馈"
        monyLabel2.isUserInteractionEnabled = true
        monyLabel2.textColor = dark_3_COLOUR
        monyLabel2.font = fzFont_Thin(ip7(24))
        monyLabel2.textAlignment = .left
        backView2.addSubview(monyLabel2)

        //意见反馈
        let backView3 = UIView(frame: CGRect(x: 0, y: backView2.frame.maxY + 2, width: KSCREEN_WIDTH, height: ip7(90)))
        backView3.backgroundColor = .white
        backView3.isUserInteractionEnabled = true
        self.view.addSubview(backView3)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.about_click))
        backView3.addGestureRecognizer(tap)
        

        let iconImageView3:UIImageView = UIImageView(frame: CGRect(x: ip7(31), y:  (ip7(90) - ip7(40))/2, width: ip7(40), height: ip7(40) ))
        iconImageView3.image = #imageLiteral(resourceName: "icon_gywm")
        iconImageView3.isUserInteractionEnabled = true
        backView3.addSubview(iconImageView3)

        let monyLabel3 : UILabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + ip7(27), y:   (ip7(90) - ip7(24))/2, width: ip7(200), height: ip7(24)))
        monyLabel3.text = "关于我们"
        monyLabel3.isUserInteractionEnabled = true
        monyLabel3.textColor = dark_3_COLOUR
        monyLabel3.font = fzFont_Thin(ip7(24))
        monyLabel3.textAlignment = .left
        backView3.addSubview(monyLabel3)
        //退出登录
        let logBtn : UIButton = UIButton(frame: CGRect(x: 0, y: backView3.frame.maxY + ip7(15), width: KSCREEN_WIDTH, height: ip7(75)))
        logBtn.setTitle("退出登录", for: .normal)
        logBtn.backgroundColor = .white
        logBtn.setTitleColor(dark_3_COLOUR, for: .normal)
        logBtn.titleLabel?.font = fzFont_Thin(ip7(24))
        logBtn.addTarget(self, action:#selector(ShezhiViewController.logout_click), for: .touchUpInside)
        self.view.addSubview(logBtn)
    }

    func logout_click() {
        let alertController = UIAlertController(title: "确定要退出登录吗？", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            self.loginOutData()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

    }

    func loginOutData() {

        self.SVshowLoad()
        weak var weakSelf = self
        dataVC.logout(completion: { (data) in
            weakSelf?.SVdismiss()
            weakSelf?.dataModel = data as! SmsModel
            print(String(describing: weakSelf?.dataModel.errno))
            if weakSelf?.dataModel.errno == 0 || weakSelf?.dataModel.errno == 2006{
                //
                KFBLog(message: "退出成功")
                LoginModelMapper.setLogout(complate: { (data2) in
                    let str:String = data2 as! String
                    if str == "1" {
                        //成功
                        let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
                        dele.mainMenu()
                    } else {
                        //存储信息失败
                    }

                })
            } else  {
     

            }

        }) { (erro) in
            
        }


    }
    
    func about_click()  {
        let vc : AboutViewController = AboutViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func yijian_click() {
        let vc : YIjianfankuiViewController = YIjianfankuiViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func clen_click()  {
        if fileManager.fileExists(atPath: filePath_downLoad) {
            KFBLog(message: "文件夹已存在")
            do {
                try self.fileManager.removeItem(at: URL(fileURLWithPath: filePath_downLoad))
                self.SVshowSucess(infoStr: "清除成功")
            } catch _ {
                KFBLog(message: "文件删除失败")
            }
        
        }
    }
    override func navigationLeftBtnClick() {
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
