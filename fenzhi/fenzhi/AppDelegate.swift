//
//  AppDelegate.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate {

    var window: UIWindow?
    var fileManager = FileManager.default

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.backgroundColor = .white
        self.mainMenu()
        self.setupUM()
 
//        self.showLogin()
//        self.showMain()
//        self.showInfo()
        return true
    }
    
    func setupUM() {
         UMSocialManager.default().openLog(true)
         UMSocialManager.default().umSocialAppkey = "59ce05e265b6d66f26000235"
         UMSocialManager.default().setPlaform(.wechatSession, appKey: "wx62e8de46fa3ca72c", appSecret: "3514a03fffff6336853162c87e2665b5", redirectURL: nil)
         UMSocialManager.default().setPlaform(.QQ, appKey: "", appSecret: "", redirectURL: nil)
    }
    
    func mainMenu() {
        
        let login = LoginModelMapper.getLoginIdAndTokenInUD().isHaveLogin
        let info = LoginModelMapper.getLoginIdAndTokenInUD().isHaveInfo
        let token = LoginModelMapper.getToken()
        print("login\(login)")
        print("info\(info)")
        KFBLog(message: token)
        if login == "1" {
            if info == "1" {
                //显示主页
                self.showMain()
            } else {
                
                //显示提交信息页面
                self.showInfo()
            }
            
        } else {
            //显示登录注册页面
            self.showLogin()
        }
    }
    
    func showInfo() {
        let vc = InfoViewController()
        vc.type = .other
        let nv :UINavigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nv
    }


    func showLogin()  {
        let loginVC = LoginViewController()
        let nv :UINavigationController = UINavigationController(rootViewController: loginVC)
        self.window?.rootViewController = nv

    }

    func showMain(){
        //首页
        let homeVc :HomeViewController = HomeViewController()
        let homeNv :UINavigationController = UINavigationController(rootViewController: homeVc)
        let item1:UITabBarItem = UITabBarItem(title:"首页", image:UIImage.init(named: "button_sy_n")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage.init(named: "button_sy_s")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))

        homeNv.tabBarItem = item1
        //记录
        let RecordVC : RecordViewController = RecordViewController()
        let RecordNV :UINavigationController = UINavigationController(rootViewController: RecordVC)
        let item2:UITabBarItem = UITabBarItem(title:"记录", image:UIImage.init(named: "button_jl_n")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage.init(named: "button_jl_s")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        RecordNV.tabBarItem = item2


        //个人
        let PersonalVC : MineViewController = MineViewController()
        let PersonaNv :UINavigationController = UINavigationController(rootViewController: PersonalVC)
        let item3:UITabBarItem = UITabBarItem(title:"我的", image:UIImage.init(named: "button_wd_n")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage.init(named: "button_wd_s")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        PersonaNv.tabBarItem = item3

        //大底部导航栏
        let vcArr = [homeNv,RecordNV,PersonaNv]
        let tab : UITabBarController = UITabBarController()
        tab.tabBar.barTintColor = blue_COLOUR
        tab.delegate = self
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object: FZColor(red: 102, green: 102, blue: 102, alpha: 1.0), forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:UIControlState.normal)
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:UIColor.white, forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:UIControlState.selected)
        tab.viewControllers = vcArr
        self.window?.rootViewController = tab
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        KFBLog(message: application)
        KFBLog(message: annotation)
        KFBLog(message: sourceApplication)
        
        KFBLog(message: url)
        let str2 = url.absoluteString
//        KFBLog(message: str2.removingPercentEncoding)
        let str3 :String = str2.removingPercentEncoding!
        let arr = str3.components(separatedBy: "/")
        let nameStr = arr.last
        KFBLog(message: nameStr!)
        
        if (self.window != nil) {
            if fileManager.fileExists(atPath: filePath) {
                KFBLog(message: "文件夹已存在")
            } else {
                KFBLog(message: "创建文件夹")
                do {
                    try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
                } catch _ {
                    KFBLog(message: "创建文件夹失败")
                }
            }
            let fileData = NSData(contentsOf: url)
            let filePathStr : String = filePath + "/" + nameStr!
            let isok =  fileData?.write(toFile: filePathStr, atomically: true)
            if let _ = isok {
                 KFBLog(message: "文件保存成功")
           
            } else {
                KFBLog(message: "文件保存失败")
            }
            
            do {
                try fileManager.removeItem(at: url)
                 KFBLog(message: "源文件删除成功")
            } catch _ {
                KFBLog(message: "源文件删除失败")
            }
            
        }
        return true
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

