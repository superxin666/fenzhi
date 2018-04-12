//
//  HeartReleaseViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/7.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import Photos
import AliyunOSSiOS
let itemWidth :CGFloat = ip7(240)
let itemHeight :CGFloat = ip7(180)
typealias HeartReleaseViewControllerBlock = ()->()
class HeartReleaseViewController: BaseViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,sureDelegate,UpLoadFileDelegate  {
    let textField: UITextView = UITextView()
    let btnBackView :UIView = UIView()
    let imageBackView :UIView = UIView()
    var imageArr :[UIImage]  = Array()
    var imageNameArr : [String] = Array()
    var reflishBlock : HeartReleaseViewControllerBlock!


    let nsetBtn : UIButton = UIButton()
    var keybodHeight : CGFloat = 0.0
    let viewHeight = ip7(730/2)
    let btnViewHeight =  ip7(55)
    
    var isHaveBackView = false//中间背景
    var isHaveBtnBackView = false//是否已经有了 按钮栏
    var isHaveImageViewBackView = false//是否已经有了 图片栏
    var isHaveDingweiBackView = false//是否已经有了 定位
    var colletionView : UICollectionView!//图片浏览
    var dingweiLabel : UILabel = UILabel()//定位显示
    let dingweiBackView = UIView()//定位背景
    var isHaveFiles = false//是否有文件
    var isHaveDingwei = false//是否有定位
    
    let tdBtn : UIButton = UIButton()//定位按钮
    let dingweiLabel_btn : UILabel = UILabel()//定位标题
    
    
    var txtStr : String = ""
    var couseId : String = ""
    
    let dataVC = HomeDataMangerController()
    let loadVC = CommonDataMangerViewController()
    var alertController : UIAlertController!
    
    var isLoading = false
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    var tokenModel : GetststokenModel = GetststokenModel()
    let upfile = UpLoadFile()

    
    /// 0 有书籍 1 没有书籍
    var bookType : Int!
    
    
    deinit {
        //记得移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        self.navigation_title_fontsize(name: "心得分享", fontsize: 27)
        self.view.backgroundColor = .white
        self.navigationBar_leftBtn()
        self.navigationBar_rightBtn_title(name: "发布")
        self.creatUI()
        self.getToken()
        
    }
    
    func getToken() {
        loadVC.getststoken(completion: { (data) in
            self.tokenModel = data as! GetststokenModel
            KFBLog(message: self.tokenModel.data.credentials.AccessKeyId)
        }) { (erro) in
            
        }
    }

    //MARK:发布
//    override func navigationRightBtnClick() {
//        KFBLog(message: "发布")
//
//        //weak
//        weak var weakSelf = self
//        if !nsetBtn.isSelected {
//            self.nestBtnClik()
//        }
//
//        if !(txtStr.count > 0) {
//            self.SVshowErro(infoStr: "请输入文字")
//            return
//        }
//        
//        if imageArr.count>0 {
//            //有图片
//            if imageArr.count > 4{
//                self.SVshowErro(infoStr: "最多上传四张图片")
//                return
//            }
//            DispatchQueue.main.async {
//                self.closeView()
//            }
//            self.SVshow(infoStr: "正在努力上传中")
//            var num = 0
//            for i in 0..<imageArr.count{
//                let image = imageArr[i]
//                loadVC.upLoadImage(uploadimg: image, type: "normal", completion: { (data) in
//                    let model :UploadimgModel = data as! UploadimgModel
//                    if model.errno == 0 {
//                        KFBLog(message: model.data)
//                        num = num + 1
//                        self.imageNameArr.append(model.data)
//                        if num == self.imageArr.count {
//                            self.subTxt(imageStr: model.data)
//                        }
//                        
//                    } else {
//                        weakSelf?.SVshowErro(infoStr: model.errmsg)
//                        weakSelf?.openView()
//                    }
//
//                    
//                }, failure: { (erro) in
//                    weakSelf?.SVshowErro(infoStr: erro as! String)
//                    weakSelf?.SVdismiss()
//                    weakSelf?.openView()
//                })
//                
//                
//            }
//        } else {
//            //没有图片
//            self.subTxt(imageStr: "")
//        }
//
//    }
//
    
    
    override func navigationRightBtnClick() {
        KFBLog(message: "发布")
        //weak
         weak var weakSelf = self
        if !nsetBtn.isSelected {
            self.nestBtnClik()
        }

        if !(txtStr.count > 0) {
            self.SVshowErro(infoStr: "请输入文字")
            return
        }

        if imageArr.count>0 {
            //有图片
            if imageArr.count > 4{
                self.SVshowErro(infoStr: "最多上传四张图片")
                return
            }
            upfile.initOSSClient(self.tokenModel.data.credentials.AccessKeyId, sec: self.tokenModel.data.credentials.AccessKeySecret, token: self.tokenModel.data.credentials.SecurityToken)
           upfile.delegate = self
            DispatchQueue.main.async {
                self.closeView()
            }
            self.SVshow(infoStr: "正在努力上传中")
            for i in 0..<imageArr.count{
                let image = imageArr[i]
                let data = UIImageJPEGRepresentation(image, 1.0)
                
                let nameNum = arc4random()
                let imageName = String.getTimeNow() +  "\(nameNum)"
                KFBLog(message: "照片名字" + imageName)
                upfile.upLoadImage(data, imageName: imageName)
            }
        } else {
            //没有图片
            self.subTxt(imageStr: "")
        }

    }
    
    
    func complete(_ filename: String!) {
        KFBLog(message: "上传地址" + filename)
        self.imageNameArr.append(filename)
        if imageNameArr.count == self.imageArr.count {
            self.subTxt(imageStr: "")
        }
    }

    func subTxt(imageStr : String)  {
         weak var weakSelf = self

        KFBLog(message: LogDataMangerViewController.getSelectCouse_name_id_heart().couseid)
        KFBLog(message: self.couseId)
        dataVC.submitfenx_heart(content: txtStr, catalog_id: self.couseId, images: self.imageNameArr, completion: { (data) in
            let model :SmsModel = data as! SmsModel
            if model.errno == 0{
                weakSelf?.openView()
                weakSelf?.SVdismiss()
                weakSelf?.SVshowSucess(infoStr: "发布成功")
                weakSelf?.reflishBlock()
                weakSelf?.navigationLeftBtnClick()
            } else {
                weakSelf?.SVshowErro(infoStr: model.errmsg)
            }
        }) { (erro) in
            weakSelf?.openView()
            weakSelf?.SVdismiss()
            weakSelf?.SVshowErro(infoStr: "网络请求失败")
        }
    }
    func closeView() {
        KFBLog(message: "关闭")
        isLoading = true
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.btnBackView.isUserInteractionEnabled = false
        self.imageBackView.isUserInteractionEnabled = false
    }
    func openView() {
      
         KFBLog(message: "打开")
          isLoading = false
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.btnBackView.isUserInteractionEnabled = true
        self.imageBackView.isUserInteractionEnabled = true
        
    }
    func keyboardWillShow(notification: NSNotification) {
        let userinfo: NSDictionary = notification.userInfo! as NSDictionary

        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue

        let keyboardRec = nsValue.cgRectValue

        let height = keyboardRec.size.height
        
        if !isHaveBtnBackView {
            self.creatBtnView()
            self.view.addSubview(btnBackView)
        } else {
            
        }
//        UIView.animate(withDuration: 1, animations: {
            self.nsetBtn.isSelected = false
            var frame = self.btnBackView.frame
            frame.origin.y = KSCREEN_HEIGHT - height - ip7(55)
            self.btnBackView.frame = frame
//            self.keybodHeight = height
//        })
        print("keybordShow:\(height)")
    }


    func creatUI()  {

        let lineView = UIView(frame: CGRect(x: 0, y: LNAVIGATION_HEIGHT, width: KSCREEN_WIDTH, height: ip7(11)))
        lineView.backgroundColor = backView_COLOUR
        self.view.addSubview(lineView)

        //
        textField.frame = CGRect(x: ip7(15), y: lineView.frame.maxY + ip7(25), width: KSCREEN_WIDTH - ip7(30), height: ip7(200))
        textField.textAlignment = .left
        textField.returnKeyType = .done
        textField.delegate = self
        textField.tag = 101
        textField.becomeFirstResponder()
        textField.backgroundColor = .clear
        textField.font =  fzFont_Thin(ip7(18))
        self.view.addSubview(textField)
        self.creatBackView()

    }

        //MARK:中间背景
    func creatBackView() {
        isHaveBackView = true
        //中间打背景
        imageBackView.frame =  CGRect(x: 0, y: KSCREEN_HEIGHT - viewHeight , width: KSCREEN_WIDTH, height: viewHeight)
        imageBackView.backgroundColor = .white
        let lineView : UIView = UIView(frame: CGRect(x: (KSCREEN_WIDTH - ip7(480))/2, y: 0, width: ip7(480), height: 0.5))
        lineView.backgroundColor = lineView_thin_COLOUR
        imageBackView.addSubview(lineView)
        self.view.addSubview(imageBackView)
        self.view.bringSubview(toFront: self.btnBackView)
        //课时定位
        self.creaDingweiBackView()

        //图片背景
        self.creatImageView()
    }
    
        //MARK:按钮
    func creatBtnView() {

        //按钮
        KFBLog(message: "asdf--\(keybodHeight)")
        isHaveBtnBackView = true
        //KSCREEN_HEIGHT - keybodHeight - LNAVIGATION_HEIGHT
        btnBackView.frame =  CGRect(x: 0, y: KSCREEN_HEIGHT , width: KSCREEN_WIDTH, height: ip7(55))
        btnBackView.backgroundColor = blue_COLOUR
        //
        nsetBtn.frame = CGRect(x: 0, y: 0, width: ip7(50), height: btnViewHeight)
        nsetBtn.imageEdgeInsets = UIEdgeInsets(top: -ip7(10), left: 0, bottom: 0, right: 0)
        nsetBtn.imageRect(forContentRect: CGRect(x: 0, y: 0, width: ip7(25), height: ip7(14)))
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_x"), for: .normal)
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_s"), for: .selected)
        nsetBtn.isSelected = false
        nsetBtn.backgroundColor = .clear
        nsetBtn.addTarget(self, action:#selector(HeartReleaseViewController.nestBtnClik), for: .touchUpInside)
        btnBackView.addSubview(nsetBtn)


//        let tdBtn : UIButton = UIButton(frame: CGRect(x: picBtn.frame.origin.x - ip7(60), y: (ip7(55) - ip7(35))/2, width: ip7(35), height: ip7(35)))
        tdBtn.frame = CGRect(x: nsetBtn.frame.maxX + ip7 (10), y: 0, width: ip7(55), height: ip7(55))
        tdBtn.setImage(#imageLiteral(resourceName: "icon_dw2"), for: .normal)
        tdBtn.backgroundColor = .clear
        tdBtn.addTarget(self, action:#selector(HeartReleaseViewController.dingwei_click), for: .touchUpInside)
        btnBackView.addSubview(tdBtn)

        dingweiLabel_btn.frame = CGRect(x: tdBtn.frame.maxX + ip7(10), y: 0, width: KSCREEN_WIDTH - tdBtn.frame.maxX - ip7(100), height: ip7(55))
        dingweiLabel_btn.font = fzFont_Thin(ip7(18))
        dingweiLabel_btn.textAlignment = .left
        dingweiLabel_btn.text =  LogDataMangerViewController.getSelectCouse_name_id_heart().name
        dingweiLabel_btn.textColor = .white
        dingweiLabel_btn.isUserInteractionEnabled = true
        btnBackView.addSubview(dingweiLabel_btn)
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dingwei_click))
        dingweiLabel_btn.addGestureRecognizer(tap)
    
        let nameStr : String = LogDataMangerViewController.getSelectCouse_name_id_heart().name
        if nameStr.count > 0  {
            //有课时定位
            tdBtn.frame = CGRect(x: nsetBtn.frame.maxX + ip7 (10), y: 0, width: ip7(55), height: ip7(55))
        } else {
            dingweiLabel_btn.isHidden = true
            //没有课时定位
            tdBtn.frame =  CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25) - ip7(60), y: (ip7(55) - ip7(35))/2, width: ip7(35), height: ip7(35))
        }
        //图片按钮
        let picBtn : UIButton = UIButton(frame: CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25), y: 0, width: ip7(55), height: ip7(55)))
        picBtn.setImage(#imageLiteral(resourceName: "icon_tp"), for: .normal)
        picBtn.backgroundColor = .clear
        picBtn.addTarget(self, action:#selector(HeartReleaseViewController.pic_click), for: .touchUpInside)
        btnBackView.addSubview(picBtn)
        
        let lineView = UIView(frame: CGRect(x: picBtn.frame.origin.x - ip7(12), y: (ip7(55) - ip7(35))/2, width: 0.5, height: ip7(35)))
        lineView.backgroundColor = .white
        btnBackView.addSubview(lineView)

    }
    //MARK:课时定位
    func creaDingweiBackView() {

        dingweiBackView.frame = CGRect(x: (KSCREEN_WIDTH - ip7(480))/2, y: ip7(13), width: ip7(480), height: ip7(70))
        dingweiBackView.backgroundColor = .clear
        dingweiBackView.isUserInteractionEnabled =  true
        imageBackView.addSubview(dingweiBackView)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.removedingwei_click))
        dingweiBackView.addGestureRecognizer(tap)
        
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: ip7(35)/2, width: ip7(35), height: ip7(35)))
        iconImageView.image = #imageLiteral(resourceName: "icon_dingwei")
        dingweiBackView.addSubview(iconImageView)
        
        dingweiLabel.frame =  CGRect(x: iconImageView.frame.maxX + ip7(10), y: ip7(70 - 21)/2, width:  dingweiBackView.frame.width - ip7(10) - iconImageView.frame.maxX , height: ip7(21))
        dingweiLabel.font = fzFont_Thin(ip7(21))
        dingweiLabel.textColor  = blue_COLOUR
        dingweiLabel.backgroundColor = .clear
        dingweiLabel.textAlignment = .left
        dingweiLabel.adjustsFontSizeToFitWidth = true
        dingweiBackView.addSubview(dingweiLabel)
        if (LogDataMangerViewController.getSelectCouse_name_id_heart().name.characters.count > 0) {
            self.dingweiBackView.isHidden = false
            dingweiLabel.text =  LogDataMangerViewController.getSelectCouse_name_id_heart().name
            couseId =  LogDataMangerViewController.getSelectCouse_name_id_heart().couseid
        } else {
            self.dingweiBackView.isHidden = true
        }

    }
        //MARK:展示图片
    func creatImageView() {

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = ip7(6)
        layout.sectionInset = UIEdgeInsetsMake(0, ip7(3), 0, ip7(3))
        if LogDataMangerViewController.getSelectCouse_name_id_heart().ishaveCouse == "1" {
            colletionView = UICollectionView(frame: CGRect(x: 15, y: ip7(15) + dingweiBackView.frame.maxY, width: KSCREEN_WIDTH-30, height: itemHeight), collectionViewLayout: layout)
        } else {
            colletionView = UICollectionView(frame: CGRect(x: 15, y: ip7(13), width: KSCREEN_WIDTH-30, height: itemHeight), collectionViewLayout: layout)
        }

        colletionView.register(ActionCollectionViewCell.self, forCellWithReuseIdentifier: "actioncollectioncell_id")
        colletionView.backgroundColor = .clear
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.contentSize = CGSize(width: itemWidth * 10, height: itemHeight)
        imageBackView.addSubview(colletionView)

    }

    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < imageArr.count {
            let cell :ActionCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "actioncollectioncell_id", for: indexPath) as! ActionCollectionViewCell
//            var nameStr : String = ""
//            var picStr :String = ""

            cell.setUI(image: imageArr[indexPath.row], name: "")
            return cell
        } else {
            return UIView() as! UICollectionViewCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < imageArr.count {
//            alertController  = UIAlertController(title: "提示", message: "是否要删除该图片", preferredStyle: .alert)
//            let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
//                //取消
//                self.alertController.dismiss(animated: true, completion: {
//
//                })
//            }
//            let sureAction = UIAlertAction(title: "删除", style: .default) { (action) in
//                self.imageArr.remove(at: indexPath.row)
//                self.colletionView.reloadData()
//            }
//            alertController.addAction(cancleAction)
//            alertController.addAction(sureAction)
//            self.present((alertController)!, animated: true, completion: nil)
            let vc = ImageShowViewController()
            vc.imageArr = self.imageArr
            vc.indexNum = indexPath.row
            vc.isNet = false
            vc.showImageBlock = {(backImageArr) in
                if backImageArr.count < self.imageArr.count {
                    self.imageArr = backImageArr
                    self.colletionView.reloadData()
                }
            }
            let na = UINavigationController(rootViewController: vc)
            self.present(na, animated: true, completion: {

            })

        }
    }


    //MARK:退出键盘
    func nestBtnClik()  {
        KFBLog(message: "退出键盘")
        nsetBtn.isSelected = !nsetBtn.isSelected
        if  nsetBtn.isSelected {
            //键盘收回 显示背景
            self.imageBackView.isHidden = false
            self.imageBackView.frame.origin.y = self.imageBackView.frame.origin.y -  btnViewHeight
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
            self.view.bringSubview(toFront: btnBackView)
            btnBackView.frame.origin.y =  KSCREEN_HEIGHT  - btnBackView.frame.size.height
        } else {
            //键盘弹起 隐藏背景
            self.imageBackView.frame.origin.y = self.imageBackView.frame.origin.y +  btnViewHeight
            self.imageBackView.isHidden = true

            textField.becomeFirstResponder()
            self.view.bringSubview(toFront: btnBackView)
            btnBackView.frame.origin.y =  KSCREEN_HEIGHT - keybodHeight - LNAVIGATION_HEIGHT
            
        }
    }

    //MARK:课时定位
    func removedingwei_click() {
        
        alertController  = UIAlertController(title: "提示", message: "是否要删除定时定位", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            //取消
            self.alertController.dismiss(animated: true, completion: {
                
            })
        }
        let sureAction = UIAlertAction(title: "删除", style: .default) { (action) in
            LogDataMangerViewController.setSelectCouse_name_id_heart(name: "", couseid: "", ishaveinfo: "0")
            self.couseId = ""
            self.dingweiBackView.isHidden = true
            self.dingweiLabel_btn.isHidden = true
            self.tdBtn.frame =  CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25) - ip7(60), y: (ip7(55) - ip7(35))/2, width: ip7(35), height: ip7(35))
        }
        alertController.addAction(cancleAction)
        alertController.addAction(sureAction)
        self.present((alertController)!, animated: true, completion: nil)
        
    }
    
    func dingwei_click() {
        KfbShowWithInfo(titleString: "定位\(bookType)")
        if bookType == 0 {
            if !nsetBtn.isSelected {
                self.nestBtnClik()
            }
            let vc = DingweiViewControlleroc()
            let urlStr = BASER_API + selectCouse_api + "token=" + "".getToken_RSA()
            vc.mainUrl =  urlStr
            vc.delegate = self
            vc.isHeart = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            KFBLog(message: "么有书籍")
            alertController  = UIAlertController(title: "温馨提示", message: "暂未收录该教材数据，欢迎您的提供和反馈，客服QQ号：814038418", preferredStyle: .alert)
            let cancleAction = UIAlertAction(title: "确定", style: .cancel) { (action) in
                //取消
                self.alertController.dismiss(animated: true, completion: {
                    
                })
            }
            alertController.addAction(cancleAction)
            self.present((alertController)!, animated: true, completion: nil)
            
        }
        
    }
    
    
       //MARK:定位代理
    func sure_click() {
        KFBLog(message: LogDataMangerViewController.getSelectCouse_name_id_heart().name)
        let nameStr : String = LogDataMangerViewController.getSelectCouse_name_id_heart().name
        self.dingweiLabel.text = nameStr
        dingweiLabel_btn.text = nameStr
        self.couseId = LogDataMangerViewController.getSelectCouse_name_id_heart().couseid
        self.dingweiBackView.isHidden = false
        self.dingweiLabel_btn.isHidden = false
        tdBtn.frame = CGRect(x: nsetBtn.frame.maxX + ip7 (10), y: 0, width: ip7(55), height: ip7(55))
        dingweiLabel_btn.frame = CGRect(x: tdBtn.frame.maxX + ip7(10), y: 0, width: KSCREEN_WIDTH - tdBtn.frame.maxX - ip7(100), height: ip7(55))
        self.colletionView.frame.origin.y = ip7(15) + (self.dingweiBackView.frame.maxY)
        
    }
       //MARK:选择照片
    func pic_click() {
        if self.imageArr.count == 4 {
            self.SVshowErro(infoStr: "最多选择4张图片")
            return
        }
        
        let maxNum = 4 - self.imageArr.count
        KFBLog(message: "最大选择张数\(maxNum)")
        if !self.nsetBtn.isSelected {
            self.nestBtnClik()
        }
        _ = self.presentHGImagePicker(maxSelected:maxNum) { (assets) in
            //结果处理
            print("共选择了\(assets.count)张图片，分别如下：")
            for i in 0..<assets.count {
                
                let asset = assets[i]
                print(asset)
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: PHImageManagerMaximumSize , contentMode: . default,
                                                      options: nil, resultHandler: {
                                                        (image, _: [AnyHashable : Any]?) in
                                                        self.imageArr.append(image!)
                                                        KFBLog(message: self.imageArr.count)
//                                                        if i == assets.count - 1 {
                                                            KFBLog(message: "刷新")
                                                            self.colletionView.reloadData()
//                                                        }
                                                        
                })
                
            }
        }
        
    }


    func openAlbum() {

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //设置是否允许编辑
            picker.allowsEditing = true

            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            KFBLog(message: "读取相册错误")
        }

    }

    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any]) {
        //查看info对象
        KFBLog(message: info)

        //获取选择的编辑后的
        let  image = info[UIImagePickerControllerEditedImage] as! UIImage
        imageArr.append(image)
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
             //显示图片
            self.isHaveFiles = true
            self.colletionView.reloadData()
        })
    }


       //MARK:textView
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        txtStr = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.nestBtnClik()
        }
        return true
    }

    
    override func navigationLeftBtnClick() {
        
        if isLoading {
            return
        }
        KFBLog(message: "返回")
        self.dismiss(animated: true) { 
            self.SVdismiss()
            
            if self.textField.isFirstResponder {
                self.textField.resignFirstResponder()
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
