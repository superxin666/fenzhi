//
//  ImageShowViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/12/17.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
typealias showImageViewBlock = (_ imageArr:Array<UIImage>)->()
class ImageShowViewController: BaseViewController,UIScrollViewDelegate {
    var imageArr :[UIImage]!
    var indexNum :Int!
    let scrollView = UIScrollView()

    var removeIndex : Int!

    var showImageBlock : showImageViewBlock!


//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationbar_transparency()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationbar_def()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.edgesForExtendedLayout = UIRectEdge.bottom
        let titleStr = "\(indexNum+1)/\(imageArr.count)"
        self.navigationBar_leftBtn()
        self.navigationBar_rightBtn_title(name: "移除")
        self.navigation_title_fontsize(name: titleStr, fontsize: 27)
        self.creatUI()

    }

    override func navigationLeftBtnClick() {
        self.dismiss(animated: true) {
            self.showImageBlock(self.imageArr)
        }
    }
    override func navigationRightBtnClick() {
        if removeIndex < imageArr.count {
            imageArr.remove(at: removeIndex)
            for view in scrollView.subviews{
                view.removeFromSuperview()
            }
            scrollView.removeFromSuperview()
            indexNum = 0
            let titleStr = "\(indexNum+1)/\(imageArr.count)"
            self.navigation_title_fontsize(name: titleStr, fontsize: 27)
            self.creatUI()
        }
    }

    func creatUI() {
        scrollView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT)
        scrollView.contentSize = CGSize(width: CGFloat(self.imageArr.count) * KSCREEN_WIDTH, height: KSCREEN_HEIGHT + 64)
        scrollView.contentOffset = CGPoint(x: KSCREEN_WIDTH * CGFloat(indexNum), y: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false

        scrollView.isPagingEnabled = true

        scrollView.delegate = self

        self.view.addSubview(scrollView)

        for i in 0..<self.imageArr.count {
            let image = self.imageArr[i]
            let imageView = UIImageView(image: image)

            let size = imageView.image?.size
            var W = CGFloat((size?.width)!)/2
            var H = CGFloat((size?.height)!)/2
            KFBLog(message: "宽度\(W)")
            KFBLog(message: "高度\(H)")
            if W > KSCREEN_WIDTH {
                W = KSCREEN_WIDTH
            }
            if H > KSCREEN_HEIGHT {
               H = KSCREEN_HEIGHT
            }
            imageView.frame = CGRect(x:CGFloat(i) * KSCREEN_WIDTH + (KSCREEN_WIDTH - W)/2, y: (KSCREEN_HEIGHT - H)/2, width: W, height: H)
            scrollView.addSubview(imageView)

        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        KFBLog(message: scrollView.contentOffset)
//        let index = scrollView.contentOffset.x / KSCREEN_HEIGHT
//        KFBLog(message: index)
//        let titleStr = "\(index)/\(imageArr.count)"
//        self.navigation_title_fontsize(name: titleStr, fontsize: 27)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        KFBLog(message: scrollView.contentOffset)
        let index : Int = Int(scrollView.contentOffset.x / KSCREEN_WIDTH)
        KFBLog(message: index)

        let titleStr = "\(index+1)/\(imageArr.count)"
        self.navigation_title_fontsize(name: titleStr, fontsize: 27)

        removeIndex = index

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
