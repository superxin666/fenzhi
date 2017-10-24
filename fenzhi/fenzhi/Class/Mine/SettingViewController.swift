//
//  SettingViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/11.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let topBackImageView : UIImageView = UIImageView()
    let iconImageView : UIImageView = UIImageView()
    let mainTabelView : UITableView = UITableView()
    let nameArr = ["姓名","地区","学校","年级","学科","教材版本",]
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
        plaNameArr.append(dataModel.data.name)
        plaNameArr.append(dataModel.data.districtName)
        plaNameArr.append(dataModel.data.schoolName)
        plaNameArr.append(dataModel.data.gradeName)
        plaNameArr.append(dataModel.data.subjectName)
        plaNameArr.append(dataModel.data.versionName)
        self.crearUI()
        self.getData()
    }
    
    override func navigationRightBtnClick() {
        self.getSupplyinfoData()
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
        let nameStr = cell.nameStr
        KFBLog(message: nameStr)
        if cell._nameTextField.isFirstResponder {
            cell._nameTextField.resignFirstResponder()
        }
        if nameStr.characters.count > 0 {
            self.dataModel.data.name = nameStr
        }
        KFBLog(message: self.dataModel.data.name)
        
        lodginDataVC.supplyinfo(name: self.dataModel.data.name, province: self.dataModel.data.province, city: self.dataModel.data.city, district: self.dataModel.data.district, school: self.dataModel.data.school, grade: self.dataModel.data.grade, subject: self.dataModel.data.subject, book: self.dataModel.data.book, avatar: self.dataModel.data.avatar, completion: { (data) in
            self.SVdismiss()
            
            let smsdataModel = data as! SmsModel
            if  smsdataModel.errno == 0 {
                //                提交信息成功
                KFBLog(message: "提交成功")
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
        
        dataVC.getschoollist(regionId: self.dataModel.data.district, type: type, pageNum: 1, count: 20, completion: { (data) in
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
        self.view.addSubview(topBackImageView)
        
        iconImageView.frame = CGRect(x: (KSCREEN_WIDTH - ip7(63))/2, y: LNAVIGATION_HEIGHT, width: ip7(63), height: ip7(63))
        iconImageView.kf.setImage(with: URL(string: dataModel.data.avatar))
        iconImageView.kfb_makeRound()
        topBackImageView.addSubview(iconImageView)
        
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
        } else if currectNum == 5{
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
            cell = mainTabelView.visibleCells[2] as! InfoTableViewCell
            dirShowStr = schoolNameStr
            self.dataModel.data.school = schoolNum!
        case 3:
            cell = mainTabelView.visibleCells[3] as! InfoTableViewCell
            dirShowStr = gradeNameStr
            self.dataModel.data.grade = gradeNum!
        case 4:
            cell = mainTabelView.visibleCells[4] as! InfoTableViewCell
            dirShowStr = subjectNameStr
            self.dataModel.data.subject = Int(subjectNum)!
        case 5:
            cell = mainTabelView.visibleCells[5] as! InfoTableViewCell
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
        case 1:
            if component == 0 {
                return regionListArr.count//省
            } else if component == 1 {
                return cityArr.count//city
            } else {
                return districtArr.count//区
            }
            
        case 2:
            return schoolArr.count
        case 3:
            return gradeArr.count
        case 4:
            return subjectArr.count
        case 5:
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
        } else if currectNum == 5 {
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
            } else {
                var model : GetregionlistModel_regionList = GetregionlistModel_regionList()
                model = districtArr[row]
                districtNameStr = model.name
                districtNum = model.id
                nameStr = model.name//city
                currectDisModel = model
            }
            
        case 2:
            let model : GetschoollistModel_schoolList = schoolArr[row]
            nameStr = model.name
            schoolNum = model.id
            schoolNameStr = model.name
            nameStr = model.name
        case 3://年纪
            let model : CommonModel_data_grade = gradeArr[row]
            nameStr = model.name
            gradeNum = Int(model.id)!
            gradeType = Int(model.type)!
            gradeNameStr = model.name
        case 4://学科
            let model : CommonModel_data_subject = subjectArr[row]
            nameStr = model.name
            subjectNum = model.id
            subjectNameStr = model.name
        case 5://教材版本
            
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
        }
        
    }
    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
        if indexPath.row == 1 {
            if regionListArr.count > 0 {
                provinceNum = dataModel.data.province
                self.getRegsionData(type: 0, parentId: self.dataModel.data.province)
                self.cgreatPickerView()
            }
        } else if indexPath.row == 2 {
            KFBLog(message: "学校")
            self.getSchoolData()
            self.cgreatPickerView()
        } else if indexPath.row == 3 {
            //年级
            self.cgreatPickerView()
        } else if indexPath.row == 4 {
            //学科
            self.cgreatPickerView()
        } else if indexPath.row == 5{
            //教材版本
            versionStr = ""
            versionNum = 0
            bookNameStr = ""
            bookNum = 0
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
