//
//  InfoViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/13.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
let ICONCELLID = "ICONCELL_ID"//
let INFOCELLID = "INFOCELLL_ID"//

enum InfoView_Type {
    case res_first
    case other
}

class InfoViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var type :InfoView_Type!
    let dataVC = CommonDataMangerViewController()
    var iconImage : UIImage = UIImage()
    var upIconcell : UpIconTableViewCell!
    var uploadImageModel : UploadimgModel = UploadimgModel()
    
    let mainTabelView : UITableView = UITableView()
    let nameArr = ["","姓名","地区","学校","年级","学科","教材版本",]
    let plaNameArr = ["","输入您的名字","请选择您所在的地区","请选择您所在学校","请选择您所在学校年级","请选择您所教学科","请选择您所用教材版本",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.navigation_title_fontsize(name: "完善资料", fontsize: 27)
        
        self.creatUI()
        // Do any additional setup after loading the view.
        self.getData()
    }

    func getData() {
        weak var weakSelf = self
//        dataVC.getgetregionlist(parentId: 0, completion: { (data) in
//            let model : GetregionlistModel = data as! GetregionlistModel
//            KFBLog(message: model.data.regionList.count)
//        }) { (erro) in
//
//        }

        dataVC.getschoollist(regionId: 33, type: 2, pageNum: 1, count: 10, completion: { (data) in
            let model : GetschoollistModel = data as! GetschoollistModel
            KFBLog(message: model.data.schoolList.count)
        }) { (erro) in

        }

    }

    func creatUI()  {
        mainTabelView.frame = CGRect(x: 0, y: ip7(15), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(15))
        mainTabelView.backgroundColor = UIColor.white
        mainTabelView.delegate = self;
        mainTabelView.dataSource = self;
        mainTabelView.tableFooterView = UIView()
        mainTabelView.separatorStyle = .none
        mainTabelView.showsVerticalScrollIndicator = false
        mainTabelView.showsHorizontalScrollIndicator = false
        mainTabelView.register(UpIconTableViewCell.self, forCellReuseIdentifier: ICONCELLID)
        mainTabelView.register(InfoTableViewCell.self, forCellReuseIdentifier: INFOCELLID)
        self.view.addSubview(mainTabelView)
    }
    
    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            upIconcell  = tableView.dequeueReusableCell(withIdentifier: ICONCELLID, for: indexPath) as! UpIconTableViewCell
            upIconcell.backgroundColor = .clear
            upIconcell.selectionStyle = .none
            if (upIconcell == nil)  {
                upIconcell = UpIconTableViewCell(style: .default, reuseIdentifier: ICONCELLID)
            }
            upIconcell.setUpUI()
            upIconcell.IconImageViewBlock = {() in
                //
                KFBLog(message: "上传头像")
                

            }
            return upIconcell;
        } else {
            var cell : InfoTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: INFOCELLID, for: indexPath) as! InfoTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if (cell == nil)  {
                cell = InfoTableViewCell(style: .default, reuseIdentifier: INFOCELLID)
            }
            cell.setUpUI_name(name: nameArr[indexPath.row], pla: plaNameArr[indexPath.row])
            return cell;
    
        }
        
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
             KFBLog(message: "上传头像")
             self.pic_click()
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0 {
            return ip7(130);
        } else {
            return ip7(90);
        }
        
    }

    //MARK:选择照片
    func pic_click() {
        KFBLog(message: "图片")
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
        iconImage = image

        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in

            //显示图片
            self.upIconcell.iconImageView.image = image
            self.upLoadIcon()
        })
    }

    func upLoadIcon(){
        weak var weakSelf = self
        dataVC.upLoadImage(uploadimg: iconImage, type: "avatar", completion: { (data) in

            weakSelf?.uploadImageModel = data as! UploadimgModel
            if weakSelf!.uploadImageModel.errno == 0 {
                KFBLog(message: "图片地址"+weakSelf!.uploadImageModel.data)
            } else {


            }

        }) { (erro) in

        }
    }



    
    override func navigationLeftBtnClick() {
        if type == .res_first {
            self.navigationController?.popViewController(animated: true)
        } else {
            let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
            dele.showLogin()
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
