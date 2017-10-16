//
//  DingweiViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/14.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import JavaScriptCore
typealias DingweiViewControllerBloke = (_ name:String) -> ()
class DingweiViewController: BaseViewController,UIWebViewDelegate {
    var webView:UIWebView?
    var context: JSContext = JSContext()
    
    var sureBlock : DingweiViewControllerBloke!
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigation_title_fontsize(name: "选择课时", fontsize: 27)
        self.navigationBar_leftBtn()
        
        self.createWebView()

    }
    
    func createWebView(){
        self.webView = UIWebView(frame:self.view.frame)
        self.webView?.delegate = self
        self.webView?.sizeToFit()
        let urlStr = BASER_API + selectCouse_api + "token=" + "".getToken_RSA()
        KFBLog(message: urlStr)
        let  url = URL(string: urlStr) as URL!
        let urlRequest = NSURLRequest(url :url!)
        self.webView!.loadRequest(urlRequest as URLRequest)
        self.view.addSubview(self.webView!)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        self.context.exceptionHandler = {(context : JSContext, exceptionValue : JSValue) in
            
            
            } as! (JSContext?, JSValue?) -> Void
        
        let save  = self.context.objectForKeyedSubscript("save_click")
        KFBLog(message: save)
        let cancle  = self.context.objectForKeyedSubscript("cancle_click")
        KFBLog(message: cancle)
        
        
    }
    
    override func navigationLeftBtnClick() {
//        if let _ = sureBlock {
//            sureBlock("第二课 我爱你塞北的学")
//        }
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
