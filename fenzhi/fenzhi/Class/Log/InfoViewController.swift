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

class InfoViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    var type :InfoView_Type!
    let dataVC = CommonDataMangerViewController()
    var iconImage : UIImage = UIImage()
    var upIconcell : UpIconTableViewCell!
    var uploadImageModel : UploadimgModel = UploadimgModel()
    
    let mainTabelView : UITableView = UITableView()
    let nameArr = ["","姓名","地区","学校","年级","学科","教材版本",]
    let plaNameArr = ["","输入您的名字","请选择您所在的地区","请选择您所在学校","请选择您所在学校年级","请选择您所教学科","请选择您所用教材版本",]

    var versionArr:[CommonModel_data_version] = Array()//教材版本
    var subjectArr:[CommonModel_data_subject] = Array()//学科
    var gradeArr:[CommonModel_data_grade] = Array()//年级
    var regionListArr:[CommonModel_data_regionList] = Array()//区域
    var currectNum:Int!

    var avatarStr = ""
    var nameStr = ""

    var provinceNum:Int!
    var cityNum:Int!
    var districtNum:Int!

    var schoolNum:Int!
    var gradeNum:Int!
    var subjectNum:Int!
    var bookNum:Int!

    var pickerView:UIPickerView = UIPickerView()
    let pickerViewBackView:UIView = UIView()

    lazy var maskView : UIView = {
        ()-> UIView in
        let maskView = UIView()
        maskView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT)
        maskView.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
        return maskView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backView_COLOUR
        self.navigationBar_leftBtn()
        self.navigation_title_fontsize(name: "完善资料", fontsize: 27)
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.creatUI()

        // Do any additional setup after loading the view.
        self.getData()
    }
    //MARK:PickerView
    func cgreatPickerView()  {

        self.view.window?.addSubview(self.maskView)

        let viewHeight = ip7(280)
        pickerViewBackView.frame = CGRect(x: 0, y: KSCREEN_HEIGHT - viewHeight, width: KSCREEN_WIDTH, height: viewHeight)
        pickerViewBackView.backgroundColor = blue_COLOUR
        self.maskView.addSubview(pickerViewBackView)


        let cancleBtn : UIButton = UIButton(frame: CGRect(x: ip7(20), y: (ip7(70)-ip7(24))/2, width: ip7(100), height: ip7(24)))
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(.white, for: .normal)
        cancleBtn.titleLabel?.font = fzFont_Medium(ip7(24))
        cancleBtn.backgroundColor = .clear
        cancleBtn.addTarget(self, action:#selector(InfoViewController.cancle_clik), for: .touchUpInside)
        pickerViewBackView.addSubview(cancleBtn)

        let sureBtn : UIButton = UIButton(frame: CGRect(x:KSCREEN_WIDTH -  ip7(20) - ip7(100), y: (ip7(70)-ip7(24))/2, width: ip7(100), height: ip7(24)))
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.titleLabel?.font = fzFont_Medium(ip7(24))
        sureBtn.backgroundColor = .clear
        sureBtn.addTarget(self, action:#selector(InfoViewController.sure_click), for: .touchUpInside)
        pickerViewBackView.addSubview(sureBtn)

        pickerView.frame = CGRect(x: 0, y: ip7(70), width: KSCREEN_WIDTH, height: ip7(210))
        pickerView.delegate = self;
        pickerView.backgroundColor = .white
        if currectNum == 0 {
             pickerView.selectRow(0, inComponent: 0, animated: true)
        } else {
             pickerView.selectRow(0, inComponent: 0, animated: true)
             pickerView.selectRow(1, inComponent: 0, animated: true)
             pickerView.selectRow(2, inComponent: 0, animated: true)
        }

        pickerViewBackView.addSubview(pickerView);

    }
    func sure_click(){
        self.removeMask()
    }

    func cancle_clik() {
        self.removeMask()
    }

    func removeMask() {
        pickerViewBackView.removeFromSuperview()
        self.maskView.removeFromSuperview()
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch currectNum {
        case 2:
            return regionListArr.count
        case 3:
            return 0
        case 4:
            return gradeArr.count
        case 5:
            return subjectArr.count
        case 6:
            return versionArr.count
        default:
            return 0
        }

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if currectNum == 2 {
            return 3
        } else {
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var nameStr :String = ""

        switch currectNum {
        case 2:
            let model : CommonModel_data_regionList = regionListArr[row]
            nameStr = model.name
        case 3:
            nameStr = "学校"
        case 4:
            let model : CommonModel_data_grade = gradeArr[row]
            nameStr = model.name
        case 5:
            let model : CommonModel_data_subject = subjectArr[row]
            nameStr = model.name
        case 6:
            let model : CommonModel_data_version = versionArr[row]
            nameStr = model.name
        default:
            nameStr = ""
        }

        let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(65)))
        nameLabel.text = nameStr
        nameLabel.textAlignment = .center
        nameLabel.textColor = dark_6_COLOUR
        nameLabel.font = fzFont_Thin(ip7(21))
        return nameLabel
    }
    func pickerView(_ pickerView: UIPickerView,rowHeightForComponent component: Int) -> CGFloat{
        return ip7(65)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component)
        print(row)
    }

    //MARK:获取公共数据
    func getData() {
        weak var weakSelf = self

        dataVC.getCommon(completion: { (data) in
            let model : CommonModel = data as! CommonModel
            if model.errno == 0 {
                weakSelf?.versionArr = model.data.version
                weakSelf?.subjectArr = model.data.subject
                weakSelf?.gradeArr = model.data.grade
                weakSelf?.regionListArr = model.data.regionList
            } else {
                weakSelf?.SVshowErro(infoStr: model.errmsg)
            }
        }) { (erro) in
                weakSelf?.SVshowErro(infoStr: "请求失败")
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
        } else if indexPath.row == 2 {
             KFBLog(message: "地区")
             currectNum = 2
            if regionListArr.count > 0 {
                let model = regionListArr[0]
                provinceNum = model.id
                self.cgreatPickerView()
            }

        }else if indexPath.row == 3 {
            KFBLog(message: "学校")


        }else if indexPath.row == 4 {
            KFBLog(message: "年级")
            currectNum = 4
            self.cgreatPickerView()
        }else if indexPath.row == 5 {
            KFBLog(message: "学科")
            currectNum = 5
            self.cgreatPickerView()
        }else if indexPath.row == 6 {
            KFBLog(message: "教材版本")
            currectNum = 6
            self.cgreatPickerView()
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
