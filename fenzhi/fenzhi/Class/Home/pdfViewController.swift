//
//  pdfViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/14.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit


enum pdfType {
    case url
    case path
}
class pdfViewController: BaseViewController,UIWebViewDelegate,UIDocumentInteractionControllerDelegate {
    var model :TeachDetailModel_data_coursewares = TeachDetailModel_data_coursewares()
    var urlStr: String = String()

    var path :String = String()
    var fileName :String = String()
    
    var webView:UIWebView?
    var pdftype :pdfType!
    
    let documentVC = UIDocumentInteractionController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

//        self.navigationBar_leftBtn()
//        self.createWebView()
//        let urlste = URL(fileURLWithPath: "")
        
        //
        documentVC.url = URL(fileURLWithPath: "/Users/lvxin/fenzhi/fenzhi/fenzhi/纷知PRD.docx") as URL!
//        documentVC.url = NSURL(string: urlStr) as URL!
        documentVC.delegate = self
        documentVC.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
    

    func createWebView(){
        self.webView = UIWebView(frame:self.view.frame)
        self.webView?.delegate = self
        self.webView?.sizeToFit()
        self.loadData()
        self.view.addSubview(self.webView!)
    }
    func loadData(){
        var url:URL!
        if self.pdftype == .url {
            self.navigation_title_fontsize(name: fileName, fontsize: 27)
            KFBLog(message: urlStr)
            url = NSURL(string: urlStr) as URL!
        } else {
            self.navigation_title_fontsize(name: fileName, fontsize: 27)
            url = URL(fileURLWithPath: path) as URL!
        }
        KFBLog(message: url)
        let urlRequest = NSURLRequest(url :url)
        self.webView!.loadRequest(urlRequest as URLRequest)
    }
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        self.SVshowLoad()
//        return true
//    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.SVshowLoad()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.SVdismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {

        self.SVshowErro(infoStr: error.localizedDescription)
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
