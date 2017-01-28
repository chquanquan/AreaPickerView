//
//  NewAreaPickerView.swift
//  test
//
//  Created by quan on 2017/1/12.
//  Copyright © 2017年 langxi.Co.Ltd. All rights reserved.
//

import UIKit

let stateKey = "state"
let citiesKey = "cities"
let cityKey = "city"
let areasKey = "areas"

let APDefaultBarTintColor = UIColor(red: 200/255, green: 22/255, blue: 35/255, alpha: 1.0)
let APDefaultTintColor = UIColor.white
///屏幕宽度
let APMAIN_WIDTH: CGFloat = {
    UIScreen.main.bounds.size.width
}()

enum PickerType: Int {
    case province
    case city
    case area
}

protocol AreaPickerViewDelegate: class {
    func statusChanged(areaPickerView: AreaPickerView, pickerView: UIPickerView, textField: UITextField, locate: Location)
}

protocol AreaPickerDelegate: AreaPickerViewDelegate, AreaToolbarDelegate {}

class AreaPickerView: UIView {
    
    var cities = [[String: AnyObject]]()
    var areas = [String]()
    var textField: UITextField!
    var pickerView:UIPickerView!
    var toolbar: AreaToolbar!
    weak var delegate: AreaPickerViewDelegate?
    
    static func picker<controller: UIViewController>(for controller: controller, textField: UITextField, barTintColor: UIColor = APDefaultBarTintColor, tintColor: UIColor = APDefaultTintColor) -> AreaPickerView where controller: AreaPickerDelegate {
        
        let areaPickerView = AreaPickerView()
        areaPickerView.delegate = controller
        areaPickerView.textField = textField
        
        let pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.white
        areaPickerView.pickerView = pickerView
        
        pickerView.delegate = areaPickerView
        pickerView.dataSource = areaPickerView
        
        
        areaPickerView.cities = areaPickerView.provinces[0][citiesKey] as! [[String : AnyObject]]!
        if let province = areaPickerView.provinces[0][stateKey] as? String {
            areaPickerView.locate.province = province
        }
        
        if let city = areaPickerView.cities[0][cityKey] as? String {
            areaPickerView.locate.city = city
        }
        
        
        areaPickerView.areas = areaPickerView.cities[0][areasKey] as! [String]!
        
        if areaPickerView.areas.count > 0 {
            areaPickerView.locate.area = areaPickerView.areas[0]
        } else {
            areaPickerView.locate.area = ""
        }
        
        textField.inputView = pickerView
        areaPickerView.toolbar = AreaToolbar.bar(for: controller, textField: textField, barTintColor: APDefaultBarTintColor, tintColor: APDefaultTintColor)
        textField.inputAccessoryView = areaPickerView.toolbar
        
        return areaPickerView
    }
    
    private init(){
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        print("地址选择器被销毁")
//    }
    
    func shouldSelected(proName: String, cityName: String, areaName: String?) {
        
        for index in 0..<provinces.count {
            let pro = provinces[index]
            if pro[stateKey] as! String == proName {
                cities = provinces[index][citiesKey] as! [[String : AnyObject]]!
                if let province = provinces[index][stateKey] as? String {
                    locate.province = province
                }
                pickerView.selectRow(index, inComponent: PickerType.province.rawValue, animated: false)
                break
            }
        }
        
        for index in 0..<cities.count {
            let city = cities[index]
            //            print("城市的名称是\(city[cityKey])")
            if city[cityKey] as! String == cityName {
                if let city = cities[index][cityKey] as? String {
                    locate.city = city
                }
                
                areas = cities[index][areasKey] as! [String]!
                pickerView.selectRow(index, inComponent: PickerType.city.rawValue, animated: false)
                break
            }
        }
        
        if areaName != nil {
            
            for (index, name) in areas.enumerated() {
                //                print("区域的名称是\(name)")
                if name == areaName! {
                    locate.area = areas[index]
                    pickerView.selectRow(index, inComponent: PickerType.area.rawValue, animated: false)
                    break
                }
            }
        }
    }
    
    
    func setCode(provinceName: String, cityName: String, areaName: String?){
        
        let url = Bundle.main.url(forResource: "addressCode", withExtension: nil)
        let data = try! Data(contentsOf: url!)
        let dict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
        let provinces = dict["p"] as! [[String: AnyObject]]
        
        for pro in provinces {
            if pro["n"] as! String == provinceName {
                if let proCode = pro["v"] as? String {
                    locate.provinceCode = proCode //找到省编号
                }
                
                
                var foundCity = false
                for city in pro["c"] as! [[String: AnyObject]] {
                    if city["n"] as! String == cityName {
                        if let cityCode = city["v"] as? String {
                            locate.cityCode = cityCode  //找到城市编码
                        }
                        for area in city["d"] as! [[String: String]] {
                            if area["n"] == areaName {
                                locate.areaCode = area["v"]!
                            }
                        }
                        foundCity = true
                    }
                }
                
                //如果第二层没有找到相应的城市.那就是直辖市了,要重新找
                if !foundCity {
                    for city in pro["c"] as! [[String: AnyObject]] {
                        let areas = city["d"] as! [[String: String]] //直接查找三级区域
                        for area in areas {
                            if area["n"] == cityName {
                                locate.areaCode = area["v"]!
                                if let cityCode = city["v"] as? String {
                                    locate.cityCode = cityCode
                                }
                                break
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    // MARK: - lazy
    lazy var provinces: [[String: AnyObject]] = {
        let path = Bundle.main.path(forResource: "area", ofType: "plist")
        return NSArray(contentsOfFile: path!) as! [[String: AnyObject]]
    }()
    
    lazy var locate: Location = {
        return Location()
    }()
    
    
}



extension AreaPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let pickerType = PickerType(rawValue: component)!
        switch pickerType {
        case .province:
            return provinces.count
        case .city:
            return cities.count
        case .area:
            return areas.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let pickerType = PickerType(rawValue: component)!
        switch pickerType {
        case .province:
            return provinces[row][stateKey] as! String?
        case .city:
            return cities[row][cityKey] as! String?
        case .area:
            if areas.count > 0 {
                return areas[row]
            } else {
                return ""
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        print("选中了某一行")
        let pickerType = PickerType(rawValue: component)!
        switch pickerType {
        case .province:
            cities = provinces[row][citiesKey] as! [[String : AnyObject]]!
            pickerView.reloadComponent(PickerType.city.rawValue)
            pickerView.selectRow(0, inComponent: PickerType.city.rawValue, animated: true)
            reloadAreaComponent(pickerView: pickerView, row: 0)
            if let province = provinces[row][stateKey] as? String {
                locate.province = province
            }
        case .city:
            reloadAreaComponent(pickerView: pickerView, row: row)
        case .area:
            if areas.count > 0 {
                locate.area = areas[row]
            } else {
                locate.area = ""
            }
        }
        setCode(provinceName: locate.province, cityName: locate.city, areaName: locate.area)
        toolbar.locate = locate
        delegate?.statusChanged(areaPickerView: self, pickerView: pickerView, textField: textField, locate: locate)
    }
    
    func reloadAreaComponent(pickerView: UIPickerView, row: Int) {
        
        
        guard row < cities.count - 1 else {
            return
        }
        
        areas = cities[row][areasKey] as! [String]!
        pickerView.reloadComponent(PickerType.area.rawValue)
        pickerView.selectRow(0, inComponent: PickerType.area.rawValue, animated: true)
        if let city = cities[row][cityKey] as? String {
            locate.city = city
        }
        if areas.count > 0 {
            locate.area = areas[0]
        } else {
            locate.area = ""
        }
    }
}




