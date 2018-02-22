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
    var imageNameArr :[String]!
    var indexNum :Int!
    let scrollViewBack = UIScrollView()
    var removeIndex : Int!
    var saveImage : UIImage!

    var showImageBlock : showImageViewBlock!

    var isNet : Bool!//true网络 false 本地
    var imageView : UIImageView!
    var arrCount :Int!
    var lastPageNum = 0
    var imageSizeArr : [UIImageView] = []
    
    
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
        self.view.backgroundColor = .white
        self.navigationBar_leftBtn()
        var titleStr = ""
        if self.isNet {
            self.navigationBar_rightBtn_title(name: "保存")
            titleStr = "\(indexNum+1)/\(imageNameArr.count)"

        } else {
            self.navigationBar_rightBtn_title(name: "移除")
            titleStr = "\(indexNum+1)/\(imageArr.count)"

        }
        self.removeIndex = indexNum
        self.navigation_title_fontsize(name: titleStr, fontsize: 27)
        self.creatUI()

    }

    override func navigationLeftBtnClick() {
        self.dismiss(animated: true) {
            if self.isNet {


            } else {
                self.showImageBlock(self.imageArr)
            }
        }
    }
    override func navigationRightBtnClick() {
        if isNet {
            //保存
            SVshow(infoStr: "保存中")
            let path = self.imageNameArr[self.removeIndex]
            let url  = URL(string: path)
            DispatchQueue.global().async {

                let fileData = NSData(contentsOf: url!)

                DispatchQueue.main.async{
                    self.SVshowSucess(infoStr: "保存成功")
                    let image = UIImage(data: fileData! as Data)
                    if image != nil {
                        UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
                    }
                }
            }
        } else {
            //删除
            if removeIndex < imageArr.count {
                imageArr.remove(at: removeIndex)

                for view in scrollViewBack.subviews{
                    view.removeFromSuperview()
                }
                scrollViewBack.removeFromSuperview()
                indexNum = 0
                let titleStr = "\(indexNum+1)/\(imageArr.count)"
                self.navigation_title_fontsize(name: titleStr, fontsize: 27)
                self.creatUI()
            }
        }
    }

//    func image(_:completionSelector:contextInfo:)){
//
//    }

    func creatUI() {
        if isNet {
            arrCount = self.imageNameArr.count
        } else {
            arrCount = self.imageArr.count
        }

        scrollViewBack.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT)
        scrollViewBack.contentSize = CGSize(width: CGFloat(arrCount) * KSCREEN_WIDTH, height: KSCREEN_HEIGHT )
        scrollViewBack.contentOffset = CGPoint(x: KSCREEN_WIDTH * CGFloat(indexNum), y: 0)
//        scrollViewBack.showsVerticalScrollIndicator = false
//        scrollViewBack.showsHorizontalScrollIndicator = false

        scrollViewBack.alwaysBounceHorizontal = true
        scrollViewBack.alwaysBounceVertical = false
        scrollViewBack.isPagingEnabled = true
        scrollViewBack.delegate = self
        self.view.addSubview(scrollViewBack)
        
        var firstImageViewH : CGFloat = 0.0
        
        for i in 0..<arrCount {

            imageView = UIImageView()
            imageView.tag = 0
            if isNet {
                let imageStr :String = self.imageNameArr[i]
                imageView.kf.setImage(with: URL(string: imageStr))
            } else {
                let image = self.imageArr[i]
                imageView.image =  image
            }
    
            let size = imageView.image?.size
            var W = CGFloat((size?.width)!)/3
            let H = CGFloat((size?.height)!)/3
            var Y = (KSCREEN_HEIGHT - H)/2
            if i == 0 {
                firstImageViewH = H
            }
            KFBLog(message: "宽度\(W)")
            KFBLog(message: "高度\(H)")
            imageSizeArr.append(imageView)
            if W > KSCREEN_WIDTH {
                W = KSCREEN_WIDTH
            }
            if H >= KSCREEN_HEIGHT {
               Y = 0
            }
            imageView.frame = CGRect(x:CGFloat(i) * KSCREEN_WIDTH + (KSCREEN_WIDTH - W)/2, y: Y, width: W, height: H)
            scrollViewBack.addSubview(imageView)
        }
        if firstImageViewH > KSCREEN_HEIGHT {
         
           scrollViewBack.contentSize = CGSize(width: CGFloat(arrCount) * KSCREEN_WIDTH, height: firstImageViewH)
               KFBLog(message: "asdf \( scrollViewBack.contentSize.height)")
        }
       
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
  
        KFBLog(message: scrollView.contentOffset)
        let index : Int = Int(scrollView.contentOffset.x / KSCREEN_WIDTH)
        removeIndex = index
        KFBLog(message: index)
        if lastPageNum == index {
            KFBLog(message: "相同")
            
        } else {
            KFBLog(message: "不同")
            lastPageNum = index
            var titleStr = ""
            if self.isNet {
                titleStr = "\(index+1)/\(imageNameArr.count)"
            } else {
                titleStr = "\(index+1)/\(imageArr.count)"
            }
            self.navigation_title_fontsize(name: titleStr, fontsize: 27)
            //
            let imageView : UIImageView = imageSizeArr[index]
            
            let size = imageView.image?.size
            let H = CGFloat((size?.height)!)/3
            if H > KSCREEN_HEIGHT {
                scrollViewBack.contentSize.height = H
            }
        }

        
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
