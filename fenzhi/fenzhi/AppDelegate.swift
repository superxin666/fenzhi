//
//  AppDelegate.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/6.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate ,WXApiDelegate,GeTuiSdkDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?
    var fileManager = FileManager.default
    let redView = UIView()
    var tab : UITabBarController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.backgroundColor = .white
        self.setupUM()
        self.setUpGeTui()
        self.mainMenu()

        //微信支付
        WXApi.registerApp("wx62e8de46fa3ca72c", enableMTA: true)
//        self.showLogin()
//        self.showMain()
//        self.showInfo()
        return true
    }

    //MARK:友盟
    func setupUM() {
        UMUntil.setUpUM()
    }
    //MARK:vc展示
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
                self.makeRedView()
            } else {
                //显示提交信息页面
                self.showInfo()
            }
            
        } else {
            //显示登录注册页面
            self.showLogin()
            //游客模式
//            self.showMain()
        }
    }
    
    func showInfo() {
        let vc = InfoViewController()
        vc.type = .other
        let nv :UINavigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nv
    }

    func showInfo_Visitor() {
        let vc = InfoVisitorViewController()
        vc.type = .other
        let nv :UINavigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nv
    }

    func makeRedView() {
        
        let viewX = UIScreen.main.bounds.size.width/3*2 + UIScreen.main.bounds.size.width/3/2 + ip7(10)
        let viewY = UIScreen.main.bounds.size.height - ip7(10) - ip7(54)
        redView.frame = CGRect(x: viewX, y: viewY, width: ip7(10), height: ip7(10))
        redView.backgroundColor = .red
        redView.kfb_makeRound()
//        redView.isHidden = true
//        self.window?.rootViewController?.view.addSubview(redView)
//        self.window?.rootViewController?.view.bringSubview(toFront: redView)
    }
    
    func hideRed() {
//        KFBLog(message: "dele取消展示")
//        redView.isHidden  = true
        redView.removeFromSuperview()
    }
    
    func showRed() {
        self.window?.rootViewController?.view.addSubview(redView)
        self.window?.rootViewController?.view.bringSubview(toFront: redView)

//        KFBLog(message: "dele展示")
//        redView.isHidden  = false
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
        tab = UITabBarController()
        tab.tabBar.barTintColor = blue_COLOUR
        tab.delegate = self
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object: UIColor.white, forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:UIControlState.normal)
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:UIColor.white, forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:UIControlState.selected)
        tab.viewControllers = vcArr
        self.window?.rootViewController = tab
        
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        KFBLog(message: application)
        self.getfile(url: url)
        return WXApi.handleOpen(url, delegate: self)||UMSocialManager.default().handleOpen(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        KFBLog(message: application)
        self.getfile(url: url)
        return WXApi.handleOpen(url, delegate: self)||UMSocialManager.default().handleOpen(url)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        KFBLog(message: app)
        self.getfile(url: url)
        return WXApi.handleOpen(url, delegate: self)||UMSocialManager.default().handleOpen(url)
    }
    
    
    

    //MARK: 微信支付回调
    func onResp(_ resp: BaseResp!) {
        KFBLog(message: "微信回调")
        if resp is PayResp {
            switch resp.errCode {
                case 0 :
                KFBLog(message: "成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pay_sucess"), object: nil)
                default:
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pay_err"), object: nil)
                KFBLog(message: resp.errCode)
                KFBLog(message: resp.errStr)
            }
        }
    }
     //MARK:文件导入
    func getfile(url : URL)  {

        KFBLog(message: url)
        let str2 = url.absoluteString
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadFile"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gorelease"), object: nil)

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
    }
    
    //MARK:个推
    func setUpGeTui() {
        
        // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
        GeTuiSdk.runBackgroundEnable(true)
        GeTuiSdk.start(withAppId: gettuiID, appKey: gettuiKEY, appSecret: gettuiSecret, delegate: self )
       
        let systemVer = (UIDevice.current.systemVersion as NSString).floatValue
        if systemVer > 10.0{
            if #available(iOS 10.0, *) {
                let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
                center.delegate = self;
                center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted:Bool, error:Error?) -> Void in
                    if (granted) {
                        print("注册通知成功") //点击允许
                    } else {
                        print("注册通知失败") //点击不允许
                    }
                })
                
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                if #available(iOS 8.0, *) {
                    let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(userSettings)
                    
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else if ( systemVer > 8.0) {
            if #available(iOS 8.0, *) {
                let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(userSettings)
                
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            if #available(iOS 7.0, *) {
                UIApplication.shared.registerForRemoteNotifications(matching: [.alert, .sound, .badge])
            }
        }
        
       
        
    }
    
    // MARK: - 远程通知(推送)回调
    
    /** 远程通知注册成功委托 */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken_ns = NSData.init(data: deviceToken);    // 转换成NSData类型
        var token = deviceToken_ns.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"));
        token = token.replacingOccurrences(of: " ", with: "")
        
        // [ GTSdk ]：向个推服务器注册deviceToken
        GeTuiSdk.registerDeviceToken(token);
        KFBLog(message: "\n>>>[DeviceToken Success]:\(token)\n\n")

    }

    /** 远程通知注册失败委托 */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("\n>>>[DeviceToken Error]:%@\n\n",error.localizedDescription);
    }
    // MARK: - APP运行中接收到通知(推送)处理 - iOS 10 以下
    
    /** APP已经接收到“远程”通知(推送) - (App运行在后台) */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        application.applicationIconBadgeNumber = 0        // 标签
        KFBLog(message: "\n>>>[Receive RemoteNotification]:\(userInfo)\n\n")
                let payloadStr : String = userInfo["payload"] as! String
        KFBLog(message: "payloadStr " + payloadStr)
        let data :Data = payloadStr.data(using: .utf8)!
        let dict : [String : Any] = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Any]
        let ID : Int =  dict["fenxId"] as! Int
        KFBLog(message: "详情\(ID)")
        let vc = TeachDetailViewController()
        vc.fenxId = ID
        vc.hidesBottomBarWhenPushed = true
        let tab : UITabBarController = self.window?.rootViewController as! UITabBarController
        let nav : UINavigationController = tab.childViewControllers[0] as! UINavigationController
        nav.pushViewController(vc, animated: true)
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // [ GTSdk ]：将收到的APNs信息传给个推统计
        GeTuiSdk.handleRemoteNotification(userInfo);
        KFBLog(message: "\n>>>[Receive RemoteNotification]:\(userInfo)\n\n")

        completionHandler(UIBackgroundFetchResult.newData);
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         KFBLog(message: "willPresentNotification: \(notification.request.content.userInfo)")
        print("willPresentNotification: %@",notification.request.content.userInfo);
        
        completionHandler([.badge,.sound,.alert]);
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("didReceiveNotificationResponse: %@",response.notification.request.content.userInfo);
        let payloadStr : String = response.notification.request.content.userInfo["payload"] as! String
        KFBLog(message: "payloadStr " + payloadStr)
        let data :Data = payloadStr.data(using: .utf8)!
        let dict : [String : Any] = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Any]
        let ID : Int =  dict["fenxId"] as! Int
        KFBLog(message: "详情\(ID)")
        let vc = TeachDetailViewController()
        vc.fenxId = ID
        vc.hidesBottomBarWhenPushed = true
        let tab : UITabBarController = self.window?.rootViewController as! UITabBarController
        let nav : UINavigationController = tab.childViewControllers[0] as! UINavigationController
        nav.pushViewController(vc, animated: true)
        
        // [ GTSdk ]：将收到的APNs信息传给个推统计
        GeTuiSdk.handleRemoteNotification(response.notification.request.content.userInfo);
        
        completionHandler();
    }
    
    // MARK: - GeTuiSdkDelegate
    
    /** SDK启动成功返回cid */
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        // [4-EXT-1]: 个推SDK已注册，返回clientId
        KFBLog(message: "\n>>>[GeTuiSdk RegisterClient]:\(clientId)\n\n")

    }
    
    /** SDK遇到错误回调 */
    func geTuiSdkDidOccurError(_ error: Error!) {
        // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
        KFBLog(message: "\n>>>[GeTuiSdk error]:\(error.localizedDescription)\n\n")
    }
    
    /** SDK收到sendMessage消息回调 */
    func geTuiSdkDidSendMessage(_ messageId: String!, result: Int32) {
        // [4-EXT]:发送上行消息结果反馈
        let msg:String = "sendmessage=\(messageId),result=\(result)";
        KFBLog(message: msg)
    }
    
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        
        var payloadMsg = "";
        if((payloadData) != nil) {
            payloadMsg = String.init(data: payloadData, encoding: String.Encoding.utf8)!;
        }
        
        let msg:String = "Receive Payload: \(payloadMsg), taskId:\(taskId), messageId:\(msgId)";
        
        NSLog("\n>>>[GeTuiSdk DidReceivePayload]:%@\n\n",msg);
    }

    //MARK: 进入前台后台
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
        application.applicationIconBadgeNumber = 0 
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

