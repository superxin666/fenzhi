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
    let lodginDataVC = LogDataMangerViewController()
    var iconImage : UIImage = UIImage()
    var upIconcell : UpIconTableViewCell!
    var uploadImageModel : UploadimgModel = UploadimgModel()
    var smsdataModel : SmsModel = SmsModel()
    
    let mainTabelView : UITableView = UITableView()

    let nameArr = ["","姓名","地区","学校","年级","学科","教材版本",]
    let plaNameArr = ["","输入您的名字","请选择您所在的地区","请选择您所在学校","请选择您所在学校年级","请选择您所教学科","请选择您所用教材版本",]
    var schoolArr:[GetschoollistModel_schoolList] = Array()//学校
    var versionArr:[CommonModel_data_version] = Array()//教材版本
    var bookArr:[GetbooklistModel_data_bookList] = Array()//书本
    var subjectArr:[CommonModel_data_subject] = Array()//学科
    var gradeArr:[CommonModel_data_grade] = Array()//年级
    var regionListArr:[CommonModel_data_regionList] = Array()//区域 省
    var cityArr:[GetregionlistModel_regionList] = Array()//区域 city
    var districtArr:[GetregionlistModel_regionList] = Array()//区域 district
    var currectDisModel : GetregionlistModel_regionList = GetregionlistModel_regionList()//当前所选择区域


    var currectNum:Int!

    var avatarStr = ""
    var nameStr = ""

    var provinceNum:Int? = Int()
    var provinceNameStr = ""
    var cityNum:Int? = Int()
    var cityNameStr = ""
    var districtNum:Int? = Int()
    var districtNameStr = ""
    var dirShowStr : String = ""


    var schoolNum:Int? = Int()
    var schoolNameStr = ""
    var gradeNum:Int? = Int()
    var gradeNameStr = ""
    var subjectNum:String = ""
    var subjectNameStr = ""
    var bookNum:Int? = Int()
    var bookNameStr = ""

    var versionNum : Int? = Int()
    var versionStr = ""

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
        
        var cell : InfoTableViewCell!
        cell = mainTabelView.visibleCells[1] as! InfoTableViewCell
        if cell._nameTextField.isFirstResponder {
            cell._nameTextField.resignFirstResponder()
        }

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
        if currectNum == 2 {
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        } else if currectNum ==  6{
             pickerView.selectRow(0, inComponent: 0, animated: true)
             pickerView.selectRow(0, inComponent: 1, animated: true)
        } else {
             pickerView.selectRow (0, inComponent: 0, animated: true)
        }
        pickerViewBackView.addSubview(pickerView);

    }
    func sure_click(){
        if cityArr.count > 0 {
            cityArr.removeAll()
        }
        if districtArr.count > 0 {
            districtArr.removeAll()
        }
        if schoolArr.count > 0 {
            schoolArr.removeAll()
        }
        if bookArr.count>0 {
            bookArr.removeAll()
        }
        
        
        var cell : InfoTableViewCell!
        switch currectNum {
        case 2:
            cell = mainTabelView.visibleCells[2] as! InfoTableViewCell
            dirShowStr = provinceNameStr + cityNameStr + districtNameStr
        case 3:
            cell = mainTabelView.visibleCells[3] as! InfoTableViewCell
            dirShowStr = schoolNameStr
        case 4:
            cell = mainTabelView.visibleCells[4] as! InfoTableViewCell
            dirShowStr = gradeNameStr
        case 5:
            cell = mainTabelView.visibleCells[5] as! InfoTableViewCell
            dirShowStr = subjectNameStr
        case 6:
            cell = mainTabelView.visibleCells[6] as! InfoTableViewCell
            //"\(bookNum)"
            dirShowStr = versionStr + bookNameStr
        default:
            dirShowStr = ""
        }

        KFBLog(message: dirShowStr)
        cell.setUpName(name: dirShowStr)
        self.removeMask()
    }

    func cancle_clik() {
        if cityArr.count > 0 {
            cityArr.removeAll()
        }
        if districtArr.count > 0 {
            districtArr.removeAll()
        }
        if schoolArr.count > 0 {
            schoolArr.removeAll()
        }
        if bookArr.count>0 {
            bookArr.removeAll()
        }
        

        provinceNum = 0
        cityNum = 0
        districtNum = 0
        self.removeMask()
    }


    func removeMask() {
        pickerViewBackView.removeFromSuperview()
        self.maskView.removeFromSuperview()
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch currectNum {
        case 2:
            if component == 0 {
                return regionListArr.count//省
            } else if component == 1 {
                return cityArr.count//city
            } else {
                return districtArr.count//区
            }

        case 3:
            return schoolArr.count
        case 4:
            return gradeArr.count
        case 5:
            return subjectArr.count
        case 6:
            if component == 0 {
                return versionArr.count//版本
            } else {
                return bookArr.count//书
            }

        default:
            return 0
        }

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if currectNum == 2 {
            return 3
        } else if currectNum == 6 {
            return 2
        } else {
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var nameStr :String = ""

        switch currectNum {
        case 2://地区

            if component == 0 {
                var model : CommonModel_data_regionList = CommonModel_data_regionList()
                model = regionListArr[row]
                provinceNameStr = model.name
                provinceNum = model.id
                nameStr = model.name
            } else if component == 1 {
                var model : GetregionlistModel_regionList = GetregionlistModel_regionList()
                model = cityArr[row]
                cityNameStr = model.name
                cityNum = model.id
                nameStr = model.name//city
                currectDisModel = model
            } else {
                var model : GetregionlistModel_regionList = GetregionlistModel_regionList()
                model = districtArr[row]
                districtNameStr = model.name
                districtNum = model.id
                nameStr = model.name//city
                currectDisModel = model
            }

        case 3:
            let model : GetschoollistModel_schoolList = schoolArr[row]
            nameStr = model.name
            schoolNum = model.id
            schoolNameStr = model.name
            nameStr = model.name
        case 4://年纪
            let model : CommonModel_data_grade = gradeArr[row]
            nameStr = model.name
            gradeNum = Int(model.id)!
            gradeNameStr = model.name
        case 5://学科
            let model : CommonModel_data_subject = subjectArr[row]
            nameStr = model.name
            subjectNum = model.id
            subjectNameStr = model.name
        case 6://教材版本

            if component == 0 {
                let model : CommonModel_data_version = versionArr[row]
                nameStr = model.name
                versionStr = model.name
                versionNum = model.id
            } else {
                let model : GetbooklistModel_data_bookList = bookArr[row]
                nameStr = model.name
                bookNameStr = model.name
                bookNum = model.id!
            }

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
        if currectNum == 2 {
            if component == 0 {
                //省
                let model : CommonModel_data_regionList = regionListArr[row]
                provinceNum = model.id
                provinceNameStr = model.name
                self.getRegsionData(type: 0,parentId: provinceNum!)
            } else if component == 1{
                //市
                let model : GetregionlistModel_regionList = cityArr[row]
                cityNum = model.id
                self.getRegsionData(type: 1,parentId: cityNum!)
            } else {
                //区

            }
        }

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

    //MARK:获取区域
    func getRegsionData(type :Int,parentId : Int) {
        weak var weakSelf = self
        dataVC.getgetregionlist(parentId: parentId, completion: { (data) in
            let model : GetregionlistModel = data as! GetregionlistModel
            if model.errno == 0 {
                if type == 0 {
                    //city
                    weakSelf?.cityArr = model.data.regionList
                    self.pickerView.reloadComponent(1)
                } else if type == 1 {
                    //district
                    weakSelf?.districtArr = model.data.regionList
                    self.pickerView.reloadComponent(2)
                }

            } else {
                weakSelf?.SVshowErro(infoStr: model.errmsg)
            }

        }) { (erro) in
               weakSelf?.SVshowErro(infoStr: "请求失败")
        }
    }
    //MARK:获取学校
    func getSchoolData() {
        weak var weakSelf = self
        dataVC.getschoollist(regionId: currectDisModel.id, type: gradeNum!, pageNum: 1, count: 20, completion: { (data) in
            let model : GetschoollistModel = data as! GetschoollistModel
            weakSelf?.schoolArr = model.data.schoolList
            self.pickerView.reloadComponent(0)
        }) { (erro) in

        }
    }

    //MARK:获取书本
    func getbookData() {
        weak var weakSelf = self
        KFBLog(message: "gradeNum\(String(describing: subjectNum))")
        dataVC.getbooklist(version: versionNum!, grade: gradeNum!, subject: Int(subjectNum)!, completion: { (data) in
            let model : GetbooklistModel = data as! GetbooklistModel
            weakSelf?.bookArr = model.data.bookList
             self.pickerView.reloadComponent(1)
        }) { (erro) in

        }
    }
     //MARK:开启纷知
    func getSupplyinfoData() {
        self.SVshowLoad()
        weak var weakSelf = self

        
        if currectDisModel.type == 3 {
            cityNum = provinceNum
            districtNum = currectDisModel.id
        }
        
        lodginDataVC.supplyinfo(name: nameStr, province: provinceNum!, city: cityNum!, district: districtNum!, school: schoolNum!, grade: gradeNum!, subject: Int(subjectNum)!, book: bookNum!, avatar: avatarStr, completion: { (data) in
             weakSelf?.smsdataModel = data as! SmsModel
            if  weakSelf?.smsdataModel.errno == 0 {
                //提交信息成功
                KFBLog(message: "提交成功")
                let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
                dele.showMain()
                
            } else {
                //
                weakSelf?.SVshowErro(infoStr: (weakSelf?.smsdataModel.errmsg)!)
            }
        }, failure: { (erro) in
            
        })

    }


    func creatUI()  {
        mainTabelView.frame = CGRect(x: 0, y: ip7(15), width: KSCREEN_WIDTH, height: ip7(130) + ip7(90*6))
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
        
        

        let logBtn : UIButton = UIButton(frame: CGRect(x: ip7(40), y: mainTabelView.frame.maxY + ip7(50), width: KSCREEN_WIDTH - ip7(80), height: ip7(50)))
        logBtn.setTitle("开启纷知", for: .normal)
        logBtn.backgroundColor = blue_COLOUR
        logBtn.setTitleColor( .white, for: .normal)
        logBtn.titleLabel?.font = fzFont_Thin(ip7(21))
        logBtn.addTarget(self, action:#selector(InfoViewController.login_click), for: .touchUpInside)
        self.view.addSubview(logBtn)
        
    }
    
    func login_click() {
        KFBLog(message: "开启纷知")
        //头像
        if avatarStr.characters.count == 0 {
            self.SVshowErro(infoStr: "请选择头像")
            return
        }
//        姓名
        var cell : InfoTableViewCell!
        cell = mainTabelView.visibleCells[1] as! InfoTableViewCell
        nameStr = cell.nameStr
        if cell.nameStr.characters.count == 0 {
            self.SVshowErro(infoStr: "请填写姓名")
            return
        }
        //区域
        if !(currectDisModel.type == 3) {
            self.SVshowErro(infoStr: "请选择城市具体到区")
            return
        }
        //教材 版本
        if versionNum == nil {
            self.SVshowErro(infoStr: "请选择教材版本")
            return
        }
        //书本
        if bookNameStr.characters.count == 0 {
            self.SVshowErro(infoStr: "请选择教材版本")
            return
        }
        
        //年级
        if gradeNum == 100 {
            self.SVshowErro(infoStr: "请选择年级")
            return
        }
        //学科
        if (subjectNum == "") {
            self.SVshowErro(infoStr: "请选择学科")
            return
        }

        //学校
        if schoolNameStr.characters.count == 0 {
            self.SVshowErro(infoStr: "请选择学校")
            return
        }
        self.getSupplyinfoData()
        
        
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
            if indexPath.row == 1 {
                cell.setUpUI_name_txtFiled(name: nameArr[indexPath.row], pla: plaNameArr[indexPath.row])
            } else {
                cell.setUpUI_name(name: nameArr[indexPath.row], pla: plaNameArr[indexPath.row])
            }
     
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
                self.getRegsionData(type: 0, parentId: provinceNum!)
                self.cgreatPickerView()
            }

        }else if indexPath.row == 3 {
            KFBLog(message: "学校")
            currectNum = 3
            if !(currectDisModel.type == 3) {
                 self.SVshowErro(infoStr: "请选择城市具体到区")
                return
            }

            if gradeNum == 100 {
                self.SVshowErro(infoStr: "请选择年级")
                return
            }
            self.getSchoolData()
            self.cgreatPickerView()


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
            let model = versionArr[0]
            versionNum = model.id
            if versionNum == nil {
                self.SVshowErro(infoStr: "请选择教材版本")
                return
            }
            if gradeNum == 100 {
                self.SVshowErro(infoStr: "请选择年级")
                return
            }
            if (subjectNum == "") {
                self.SVshowErro(infoStr: "请选择学科")
                return
            }
            self.getbookData()
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
                weakSelf!.avatarStr = weakSelf!.uploadImageModel.data
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
