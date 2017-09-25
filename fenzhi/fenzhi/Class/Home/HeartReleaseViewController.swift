//
//  HeartReleaseViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/7.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

let itemWidth :CGFloat = ip7(240)
let itemHeight :CGFloat = ip7(180)

class HeartReleaseViewController: BaseViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource  {
    let textField: UITextView = UITextView()
    let btnBackView :UIView = UIView()
    let imageBackView :UIView = UIView()
    var imageArr :[UIImage]  = Array()



    let nsetBtn : UIButton = UIButton()
    var keybodHeight : CGFloat = 0.0
    
    var isHaveBackView = false//中间背景
    var isHaveBtnBackView = false//是否已经有了 按钮栏
    var isHaveImageViewBackView = false//是否已经有了 图片栏
    var isHaveDingweiBackView = false//是否已经有了 定位
    var colletionView : UICollectionView!//图片浏览
    var dingweiLabel : UILabel = UILabel()//定位显示
    
    var txtStr : String = ""
    let dataVC = HomeDataMangerController()
    let loadVC = CommonDataMangerViewController()

    
//    deinit {
//        NotificationCenter.removeObserver(NSNotification.Name.UIKeyboardWillShow)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)

        self.navigation_title_fontsize(name: "心得分享", fontsize: 27)
        self.view.backgroundColor = .white
        self.navigationBar_leftBtn()
        self.navigationBar_rightBtn_title(name: "发布")
        self.creatUI()

    }

    //MARK:发布
    override func navigationRightBtnClick() {
        //weak
         weak var weakSelf = self
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        if !(txtStr.characters.count > 0) {
            self.SVshowErro(infoStr: "请输入文字")
            return
        }

//        if imageArr.count>0 {
//            //有图片
//            let image = imageArr[0]
//
//            loadVC.upLoadImage(uploadimg: image, type: "normal", completion: { (data) in
//
//            }, failure: { (erro) in
//
//            })
//
//        }
        self.subTxt()



    }

    func subTxt()  {
         weak var weakSelf = self
        dataVC.submitfenx_heart(content: txtStr, catalog_id: 0, images: "", completion: { (data) in
            let model :SmsModel = data as! SmsModel
            if model.errno == 0{
                weakSelf?.SVshowSucess(infoStr: "发布成功")
            } else {
                weakSelf?.SVshowErro(infoStr: model.errmsg)
            }
        }) { (erro) in
            weakSelf?.SVshowErro(infoStr: "网络请求失败")
        }
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
        UIView.animate(withDuration: 1, animations: {
            var frame = self.btnBackView.frame
            frame.origin.y = KSCREEN_HEIGHT - height - ip7(55)
            self.btnBackView.frame = frame
            self.keybodHeight = height
        })
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



    }

        //MARK:中间背景
    func creatBackView() {
        isHaveBackView = true
        //中间打背景
        imageBackView.frame =  CGRect(x: 0, y: KSCREEN_HEIGHT - keybodHeight , width: KSCREEN_WIDTH, height: keybodHeight)
        imageBackView.backgroundColor = .white
        self.view.addSubview(imageBackView)
        self.view.bringSubview(toFront: self.btnBackView)
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
        nsetBtn.frame = CGRect(x: ip7(25), y: (ip7(55) - ip7(14))/2, width: ip7(25), height: ip7(14))
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_x"), for: .normal)
        nsetBtn.setImage(#imageLiteral(resourceName: "button_jt_s"), for: .selected)
        nsetBtn.isSelected = false
        nsetBtn.backgroundColor = .clear
        nsetBtn.addTarget(self, action:#selector(HeartReleaseViewController.nestBtnClik), for: .touchUpInside)
        btnBackView.addSubview(nsetBtn)


        let picBtn : UIButton = UIButton(frame: CGRect(x: KSCREEN_WIDTH - ip7(55) - ip7(25), y: 0, width: ip7(55), height: ip7(55)))
        picBtn.setImage(#imageLiteral(resourceName: "icon_tp"), for: .normal)
        picBtn.backgroundColor = .clear
        picBtn.addTarget(self, action:#selector(HeartReleaseViewController.pic_click), for: .touchUpInside)
        btnBackView.addSubview(picBtn)

        let tdBtn : UIButton = UIButton(frame: CGRect(x: picBtn.frame.origin.x - ip7(60), y: (ip7(55) - ip7(35))/2, width: ip7(35), height: ip7(35)))
        tdBtn.setImage(#imageLiteral(resourceName: "icon_dw2"), for: .normal)
        tdBtn.backgroundColor = .clear
        tdBtn.addTarget(self, action:#selector(HeartReleaseViewController.dingwei_click), for: .touchUpInside)
        btnBackView.addSubview(tdBtn)

        let lineView = UIView(frame: CGRect(x: tdBtn.frame.maxX + ip7(12), y: (ip7(55) - ip7(35))/2, width: 0.5, height: ip7(35)))
        lineView.backgroundColor = .white
        btnBackView.addSubview(lineView)

    }
    //MARK:课时定位
    func creaDingweiBackView() {
        if !isHaveBackView {
            self.creatBackView()
        }
        isHaveDingweiBackView = true
        let dingweiBackView = UIView(frame: CGRect(x: (KSCREEN_WIDTH - ip7(480))/2, y: ip7(6), width: ip7(480), height: ip7(70)))
        dingweiBackView.backgroundColor = backView_COLOUR
        imageBackView.addSubview(dingweiBackView)
        
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

    }
        //MARK:展示图片
    func creatImageView() {
        if !isHaveBackView {
            self.creatBackView()
        }
        self.isHaveImageViewBackView = true
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = ip7(6)
        layout.sectionInset = UIEdgeInsetsMake(0, ip7(3), 0, ip7(3))

        colletionView = UICollectionView(frame: CGRect(x: 15, y: ip7(165/2), width: KSCREEN_WIDTH-30, height: itemHeight), collectionViewLayout: layout)
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

    //MARK:退出键盘
    func nestBtnClik()  {
        KFBLog(message: "退出键盘")
        nsetBtn.isSelected = !nsetBtn.isSelected
        if  nsetBtn.isSelected {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
            self.view.bringSubview(toFront: btnBackView)
            btnBackView.frame.origin.y =  KSCREEN_HEIGHT  - btnBackView.frame.size.height
        } else {
            textField.becomeFirstResponder()
            self.view.bringSubview(toFront: btnBackView)
            btnBackView.frame.origin.y =  KSCREEN_HEIGHT - keybodHeight - LNAVIGATION_HEIGHT
            
        }
    }

     //MARK:课时定位
    func dingwei_click() {
        KfbShowWithInfo(titleString: "定位")
        let vc = DingweiViewController()
        vc.sureBlock = {(name : String) in
            if self.isHaveDingweiBackView {
                self.dingweiLabel.text = name
            } else {
                self.dingweiLabel.text = name
                self.creaDingweiBackView()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
       //MARK:选择照片
    func pic_click() {
        KfbShowWithInfo(titleString: "图片")
        let alertController = UIAlertController(title: "提示", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)

        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let AlbumAction = UIAlertAction(title: "从相册选择", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            self.openAlbum()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(AlbumAction)
        self.present(alertController, animated: true, completion: nil)

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
            if self.isHaveImageViewBackView {
                self.colletionView.reloadData()
            } else {
                self.creatImageView()
            }
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
            textView.resignFirstResponder()
        }
        return true
    }

    
    override func navigationLeftBtnClick() {
         self.SVdismiss()
        self.dismiss(animated: true) { 
            
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
