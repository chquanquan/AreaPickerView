//
//  LocationModel.swift
//  LeLingLianMeng
//
//  Created by quan on 2017/1/11.
//  Copyright © 2017年 langxi.Co.Ltd. All rights reserved.
//

import Foundation

class Location {
    
    var country = ""
    var province = ""
    var city = ""
    var area = ""
    var street = ""
//    var latitude: Double? //没数据
//    var longitude: Double? //没数据
    
    var provinceCode = ""
    var cityCode = ""
    var areaCode = ""
    
    func decription() {
        print("\(province): \(provinceCode) \(city): \(cityCode) \(area): \(areaCode)")
    }
    
}
