//
//  ViewController.swift
//  test
//
//  Created by quan on 2017/1/11.
//  Copyright © 2017年 langxi.Co.Ltd. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var textField: UITextField!
    
    var areaPickerView: AreaPickerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        //初始化地址(如果有),方便弹出pickerView后能够主动选中,这时候还没有区域代码信息,但是只要一划动并确定就有了.理论上进入地址控制器时候,要么全部信息有,要么全部信息没有....我先赋值只是为了演示功能.
        myLocate.province = "广东省"
        myLocate.city = "广州市"
        myLocate.area = "天河区"
        setAreaText(locate: myLocate)
        
        //areaPickerView.有控制器在的时候,不会被销毁.跟控制器时间销毁...没关系吧?
        areaPickerView = AreaPickerView.picker(for: self, textField: textField)
        textField.delegate = self  //也个也最好实现.因为可以在将要显示PickerView的时候,主动选中一个地区.
        
        //为了点击空白的时候能够退键盘
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewDidTap(tapGR:)))
        tapGR.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGR)
    }
    
    func viewDidTap(tapGR: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - lazy
    lazy var myLocate: Location = {
        return Location()
    }()
    
}

extension ViewController: UITextFieldDelegate {
    
    //主动选择某一个地区,主动弹出某个区域以选中....
    func textFieldDidBeginEditing(_ textField: UITextField) {
            areaPickerView?.shouldSelected(proName: myLocate.province, cityName: myLocate.city, areaName: myLocate.area)
    }
}

extension ViewController: AreaPickerDelegate {
    internal func cancel(areaToolbar: AreaToolbar, textField: UITextField, locate: Location, item: UIBarButtonItem) {
        print("点击了取消")
        //还原原来的值......
        myLocate.decription()
        setAreaText(locate: myLocate)
    }

    internal func sure(areaToolbar: AreaToolbar, textField: UITextField, locate: Location, item: UIBarButtonItem) {
        print("点击了确定")
        //当picker定住的时候,就有会值.**********但是******************
        //picker还有转动的时候有些值是空的........取值前一定要判断是否为空.否则crash.....
        //赋值新地址......
        print("最后的值是\n")
        locate.decription()
//        myLocate = locate //不能直接赋值地址,这个是引用来的
        myLocate.province = locate.province
        myLocate.provinceCode = locate.provinceCode
        myLocate.city = locate.city
        myLocate.cityCode = locate.cityCode
        myLocate.area = locate.area
        myLocate.areaCode = locate.areaCode
        
    }

    internal func statusChanged(areaPickerView: AreaPickerView, pickerView: UIPickerView, textField: UITextField, locate: Location) {
        //立即显示新值
        print("转到的值:\n")
        locate.decription()
        if !locate.area.isEmpty {
            textField.text = "\(locate.province) \(locate.city) \(locate.area)"
        } else {
            textField.text = "\(locate.province) \(locate.city)"
        }
    }

    
    func setAreaText(locate: Location) {
        var areaText = ""
        if locate.city.isEmpty {
            areaText = locate.province
        } else if locate.area.isEmpty {
            areaText = "\(locate.province) \(locate.city)"
        } else {
            areaText = "\(locate.province) \(locate.city) \(locate.area)"
        }
        textField.text = areaText
    }
    
}



