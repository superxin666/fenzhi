//
//  ImageModel.swift
//  fenzhi
//
//  Created by lvxin on 2017/11/9.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class ImageModel: Mappable {
    var imageName: String = ""
    var imageUrl : URL!

    
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        
        imageName <- map["imageName"]
        imageUrl <- map["imageUrl"]
        
    }
}
