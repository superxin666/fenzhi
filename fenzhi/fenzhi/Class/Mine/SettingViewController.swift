//
//  SettingViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/11.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UpLoadFileDelegate{
    
    let topBackImageView : UIImageView = UIImageView()
    let iconImageView : UIImageView = UIImageView()
    let mainTabelView : UITableView = UITableView()
    let nameArr = ["姓名","地区","手机号","年级","学校","学科","教材版本",]
//    let plaNameArr = ["输入您的名字","请选择您所在的地区","请选择您所在学校","请选择您所在学校年级","请选择您所教学科","请选择您所用教材版本",]
    var plaNameArr = Array<String>()
    var pickerView:UIPickerView = UIPickerView()
    let pickerViewBackView:UIView = UIView()
    
    let dataVC = CommonDataMangerViewController()
    let lodginDataVC = LogDataMangerViewController()
    var dataModel :ProfileMineModel!
    var currectNum:Int!
    var schoolArr:[GetschoollistModel_schoolList] = Array()//学校
    var versionArr:[CommonModel_data_version] = Array()//教材版本
    var bookArr:[GetbooklistModel_data_bookList] = Array()//书本
    var subjectArr:[CommonModel_data_subject] = Array()//学科
    var gradeArr:[CommonModel_data_grade] = Array()//年级
    var regionListArr:[CommonModel_data_regionList] = Array()//区域 省
    var cityArr:[GetregionlistModel_regionList] = Array()//区域 city
    var districtArr:[GetregionlistModel_regionList] = Array()//区域 district
    var currectDisModel : GetregionlistModel_regionList = GetregionlistModel_regionList()//当前所选择区域
    
    
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
    var gradeType:Int? = Int()
    var gradeNameStr = ""
    var subjectNum:String = ""
    var subjectNameStr = ""
    var bookNum:Int? = Int()
    var bookNameStr = ""
    
    var versionNum : Int? = Int()
    var versionStr = ""
    
    
    var iconImage = UIImage()
    var uploadImageModel: UploadimgModel!
    var avatarStr = ""
    var isLoadIcon :Bool = false
    
    let upfile = UpLoadFile()
    var tokenModel : GetststokenModel = GetststokenModel()
    var userType:String!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationbar_transparency()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = backView_COLOUR
        self.navigation_title_fontsize(name: "个人信息", fontsize: 27)
        self.navigationBar_leftBtn()
        self.navigationBar_rightBtn_title(name: "保存",textColour: .white)
        userType = LoginModelMapper.getLoginIdAndTokenInUD().userType
        KFBLog(message: "账户类型\(userType)")
        if userType! == "0"{
            plaNameArr.append(dataModel.data.name)
            plaNameArr.append(dataModel.data.districtName)
            plaNameArr.append(dataModel.data.phone)
            
            plaNameArr.append(dataModel.data.gradeName)
            plaNameArr.append(dataModel.data.schoolName)
            plaNameArr.append(dataModel.data.subjectName)
            plaNameArr.append(dataModel.data.versionName+dataModel.data.bookName)
        } else {
            plaNameArr.append(dataModel.data.name)
            plaNameArr.append(dataModel.data.districtName)
            plaNameArr.append(dataModel.data.phone)
        }

        provinceNum = self.dataModel.data.province
        cityNum = self.dataModel.data.city
        districtNum = self.dataModel.data.district
        self.crearUI()
        self.getData()
       
    }
    
    override func navigationRightBtnClick() {
        if userType == "0"{
            self.getSupplyinfoData()
        } else {
            self.getSupplyinfoData_vis()
        }

    }
    //MARK:获取阿里云token
    func getToken() {
        dataVC.getststoken(completion: { (data) in
            self.tokenModel = data as! GetststokenModel
            KFBLog(message: self.tokenModel.data.credentials.AccessKeyId)
            let data = UIImageJPEGRepresentation(self.iconImage, 1.0)
            let nameNum = arc4random()
            let imageName = String.getTimeNow() +  "\(nameNum)"
            KFBLog(message: "照片名字" + imageName)
            self.upfile.initOSSClient(self.tokenModel.data.credentials.AccessKeyId, sec: self.tokenModel.data.credentials.AccessKeySecret, token: self.tokenModel.data.credentials.SecurityToken)
            self.upfile.delegate = self
            self.upfile.upLoadImage(data, imageName: imageName)
        }) { (erro) in
            
        }
    }
    func complete(_ filename: String!) {
        KFBLog(message:"上传成功" + filename)
        isLoadIcon = false
        self.avatarStr = filename
        self.dataModel.data.avatar = filename
        
    }
    //MARK:上传数据
    func getSupplyinfoData() {
        self.SVshowLoad()
        weak var weakSelf = self
        
//        if currectDisModel.type == 3 {
//            cityNum = provinceNum
//            districtNum = currectDisModel.id
//        }
        
        var cell : InfoTableViewCell!
        cell = mainTabelView.visibleCells[0] as! InfoTableViewCell


        if cell._nameTextField.isFirstResponder {
            cell._nameTextField.resignFirstResponder()
        }
        let nameStr = cell.nameStr
        KFBLog(message: nameStr)
        if nameStr.count > 0 {
            self.dataModel.data.name = nameStr
        }
        if isLoadIcon {
            self.SVshowErro(infoStr: "稍等，正在上传头像")
            return
        }
        KFBLog(message: self.dataModel.data.name)
        if currectDisModel.type == 3 {
            cityNum = provinceNum
            districtNum = currectDisModel.id
        }

        lodginDataVC.supplyinfo(name: self.dataModel.data.name, province: provinceNum!, city: cityNum!, district: districtNum!, school: self.dataModel.data.school, grade: self.dataModel.data.grade, subject: self.dataModel.data.subject, book: self.dataModel.data.book, avatar: self.dataModel.data.avatar, completion: { (data) in
            self.SVdismiss()
            
            let smsdataModel = data as! SmsModel
            if  smsdataModel.errno == 0 {
                //                提交信息成功
                KFBLog(message: "提交成功")
                weakSelf?.navigationLeftBtnClick()
            } else {
                //
                weakSelf?.SVshowErro(infoStr: (smsdataModel.errmsg))
            }
        }, failure: { (erro) in
            
        })
        
    }
    func getSupplyinfoData_vis(){
        self.SVshowLoad()
        weak var weakSelf = self

        //        if currectDisModel.type == 3 {
        //            cityNum = provinceNum
        //            districtNum = currectDisModel.id
        //        }

        var cell : InfoTableViewCell!
        cell = mainTabelView.visibleCells[0] as! InfoTableViewCell


        if cell._nameTextField.isFirstResponder {
            cell._nameTextField.resignFirstResponder()
        }
        let nameStr = cell.nameStr
        KFBLog(message: nameStr)
        if nameStr.count > 0 {
            self.dataModel.data.name = nameStr
        }
        if isLoadIcon {
            self.SVshowErro(infoStr: "稍等，正在上传头像")
            return
        }
        KFBLog(message: self.dataModel.data.name)
        if currectDisModel.type == 3 {
            cityNum = provinceNum
            districtNum = currectDisModel.id
        }

        lodginDataVC.supplyinfo_vis(name: self.dataModel.data.name, province: provinceNum!, city: cityNum!, district: districtNum!,avatar: self.dataModel.data.avatar, completion: { (data) in
            self.SVdismiss()

            let smsdataModel = data as! SmsModel
            if  smsdataModel.errno == 0 {
                //                提交信息成功
                KFBLog(message: "提交成功")
                weakSelf?.navigationLeftBtnClick()
            } else {
                //
                weakSelf?.SVshowErro(infoStr: (smsdataModel.errmsg))
            }
        }, failure: { (erro) in

        })
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
                    self.pickerView.reloadComponent(2)
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
        var type = 0
        if self.dataModel.data.grade > 6 {
            type = 1
        }
        
        dataVC.getschoollist(regionId: dataModel.data.district, type: type, pageNum: 1, count: 20, completion: { (data) in
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
    
        dataVC.getbooklist(version: versionNum!, grade: dataModel.data.grade, subject: dataModel.data.subject, completion: { (data) in
            let model : GetbooklistModel = data as! GetbooklistModel
            weakSelf?.bookArr = model.data.bookList
            self.pickerView.reloadComponent(1)
        }) { (erro) in
            
        }
    }
    //MARK: 创建视图
    func crearUI() {
        topBackImageView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip7(234))
        topBackImageView.image = #imageLiteral(resourceName: "bg1")
        topBackImageView.isUserInteractionEnabled = true
        self.view.addSubview(topBackImageView)
        
        iconImageView.frame = CGRect(x: (KSCREEN_WIDTH - ip7(63))/2, y: LNAVIGATION_HEIGHT, width: ip7(63), height: ip7(63))
//        iconImageView.kf.setImage(with: URL(string: dataModel.data.avatar))
         iconImageView.setImage_kf(imageName:  dataModel.data.avatar, placeholderImage: #imageLiteral(resourceName: "tx_m"))
        
        iconImageView.kfb_makeRound()
        iconImageView.isUserInteractionEnabled = true
        topBackImageView.addSubview(iconImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.icon_click))
        iconImageView.addGestureRecognizer(tap)
        
        
        mainTabelView.frame = CGRect(x: 0, y: topBackImageView.frame.maxY + ip7(20), width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - ip7(20) - topBackImageView.frame.maxY )
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
     //MARK:icon
    func icon_click() {
        KFBLog(message: "照片点击")
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
            self.iconImageView.image = image
            self.upLoadIcon()
        })
    }
    func upLoadIcon(){
        self.getToken()
        isLoadIcon = true

    }

    
    //MARK:PickerView
    func cgreatPickerView()  {
        
//        var cell : InfoTableViewCell!
//        cell = mainTabelView.visibleCells[1] as! InfoTableViewCell
//        if cell._nameTextField.isFirstResponder {
//            cell._nameTextField.resignFirstResponder()
//        }
        
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
        cancleBtn.addTarget(self, action:#selector(SettingViewController.cancle_clik), for: .touchUpInside)
        pickerViewBackView.addSubview(cancleBtn)
        
        let sureBtn : UIButton = UIButton(frame: CGRect(x:KSCREEN_WIDTH -  ip7(20) - ip7(100), y: (ip7(70)-ip7(24))/2, width: ip7(100), height: ip7(24)))
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.titleLabel?.font = fzFont_Medium(ip7(24))
        sureBtn.backgroundColor = .clear
        sureBtn.addTarget(self, action:#selector(SettingViewController.sure_click), for: .touchUpInside)
        pickerViewBackView.addSubview(sureBtn)
        
        pickerView.frame = CGRect(x: 0, y: ip7(70), width: KSCREEN_WIDTH, height: ip7(210))
        pickerView.delegate = self;
        pickerView.backgroundColor = .white
        if currectNum == 1 {
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        } else if currectNum == 6{
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
        case 1:
            cell = mainTabelView.visibleCells[1] as! InfoTableViewCell
            dirShowStr = provinceNameStr + cityNameStr + districtNameStr
            self.dataModel.data.province = provinceNum!
            self.dataModel.data.city = cityNum!
            self.dataModel.data.district = districtNum!
        case 2:
            KFBLog(message: "手机号")
        case 3://年级
            cell = mainTabelView.visibleCells[3] as! InfoTableViewCell
            dirShowStr = gradeNameStr
            self.dataModel.data.grade = gradeNum!
        case 4://学校
            cell = mainTabelView.visibleCells[4] as! InfoTableViewCell
            dirShowStr = schoolNameStr
            self.dataModel.data.school = schoolNum!
        case 5://学科
            cell = mainTabelView.visibleCells[5] as! InfoTableViewCell
            dirShowStr = subjectNameStr
            self.dataModel.data.subject = Int(subjectNum)!
        case 6://教材
            cell = mainTabelView.visibleCells[6] as! InfoTableViewCell
            //"\(bookNum)"
            dirShowStr = versionStr + bookNameStr
            self.dataModel.data.book = bookNum!
            KFBLog(message: dirShowStr)
        default:
            dirShowStr = ""
        }
        
        KFBLog(message: dirShowStr)
        cell.setUpName(name: dirShowStr)
        districtNameStr = ""
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
        districtNameStr = ""
        self.removeMask()
    }
    
    
    func removeMask() {
        pickerViewBackView.removeFromSuperview()
        self.maskView.removeFromSuperview()
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch currectNum {
        case 1:
            if component == 0 {
                return regionListArr.count//省
            } else if component == 1 {
                return cityArr.count//city
            } else {
                return districtArr.count//区
            }
        case 2://手机号
           return 0
        case 3://年级
            return gradeArr.count
        case 4://学校
            return schoolArr.count
        case 5://学科
            return subjectArr.count
        case 6://版本
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
        if currectNum == 1 {
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
        case 1://地区
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
                if model.type == 3 {
                    districtNum = model.id
                }
            } else {
                var model : GetregionlistModel_regionList = GetregionlistModel_regionList()
                model = districtArr[row]
                districtNameStr = model.name
                districtNum = model.id
                nameStr = model.name//city
//                currectDisModel = model
            }
        case 3://年纪
            let model : CommonModel_data_grade = gradeArr[row]
            nameStr = model.name
            gradeNum = Int(model.id)!
            gradeType = Int(model.type)!
            gradeNameStr = model.name
        case 4://学校
            let model : GetschoollistModel_schoolList = schoolArr[row]
            nameStr = model.name
            schoolNum = model.id
            schoolNameStr = model.name
            nameStr = model.name
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
                KFBLog(message: "\(model.id)")
                KFBLog(message:"教材版本号" + versionStr + "\(String(describing: versionNum!))")
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component)
        print(row)
        if currectNum == 1 {
            if component == 0 {
                //省
                let model : CommonModel_data_regionList = regionListArr[row]
                provinceNum = model.id
                provinceNameStr = model.name
                self.getRegsionData(type: 0,parentId: model.id)
            } else if component == 1{
                //市
                let model : GetregionlistModel_regionList = cityArr[row]
                cityNum = model.id
                self.getRegsionData(type: 1,parentId: model.id)
            } else {
                //区
                
            }
        } else if currectNum == 6 {
            if component == 0 {
                //版本
                self.getbookData()
            }
        }
        
    }
    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userType == "0" {
            return 7
        } else {
            return 3
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : InfoTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: INFOCELLID, for: indexPath) as! InfoTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if (cell == nil)  {
            cell = InfoTableViewCell(style: .default, reuseIdentifier: INFOCELLID)
        }
        if indexPath.row == 0 {
            cell.setUpUI_name_txtFiled(name: nameArr[indexPath.row], pla: plaNameArr[indexPath.row])
        } else {
            cell.setUpUI_name(name: nameArr[indexPath.row], pla: plaNameArr[indexPath.row])
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         currectNum = indexPath.row
        if (indexPath.row != 0) {
            let cell : InfoTableViewCell = mainTabelView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InfoTableViewCell
            if cell._nameTextField.isFirstResponder {
                cell._nameTextField.resignFirstResponder()
            }
        }
        
        if indexPath.row == 1 {
            //地区
            if regionListArr.count > 0 {
//                provinceNum = dataModel.data.province
                let model = regionListArr[0]
                provinceNum = model.id
                self.getRegsionData(type: 0, parentId: provinceNum!)
                self.cgreatPickerView()
            }
        }
        else if indexPath.row == 2 {
            KFBLog(message: "手机号")
 
        }
        
        else if indexPath.row == 3 {
            //年级
            self.cgreatPickerView()
        } else if indexPath.row == 4 {
            //学校
            self.getSchoolData()
            self.cgreatPickerView()

        } else if indexPath.row == 5 {
            //学科
            self.cgreatPickerView()
        } else if indexPath.row == 6{
            //教材版本
            let model : CommonModel_data_version = versionArr[0]
            versionNum = model.id
            self.getbookData()
            self.cgreatPickerView()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            return ip7(90);
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
