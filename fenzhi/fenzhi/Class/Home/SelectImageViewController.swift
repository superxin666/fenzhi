//
//  SelectImageViewController.swift
//  fenzhi
//
//  Created by lvxin on 2017/11/7.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import AssetsLibrary

class SelectImageViewController: UIViewController {
//    let imageCollectionView : UICollectionView = UICollectionView()
    let libary : ALAssetsLibrary = ALAssetsLibrary()
    var imageArr : [ImageModel] = Array()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getData()
    }
    
    func getData()  {
        libary.enumerateGroups(withTypes: ALAssetsGroupType(ALAssetsGroupSavedPhotos), using: { (group, stop) in
            if group != nil {
                group?.enumerateAssets({ (result, index, stop) in
                    //ALAssetsGroupPropertyType
                    let assetType  = result?.value(forProperty: ALAssetsGroupPropertyType)
                    if assetType is String {
                        if assetType as! String ==  ALAssetTypePhoto {
                            let fileName : String = (result?.defaultRepresentation().filename())!
                            let model : ImageModel = ImageModel()
                            model.imageName = fileName
                            model.imageUrl = (result?.defaultRepresentation().url())!
                            self.imageArr.append(model)
                            if index + 1 == group?.numberOfAssets(){
                                KFBLog(message: self.imageArr.count)
                            }
                        }
                    } else {
                        KFBLog(message: "不是字符串")
                    }
                    
                })
                
            }
        }) { (erro) in
            KFBLog(message: "获取照片失败")
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
