//
//  AreaToolbar.swift
//  test
//
//  Created by quan on 2017/1/12.
//  Copyright © 2017年 langxi.Co.Ltd. All rights reserved.
//

import UIKit

protocol AreaToolbarDelegate: class {
    func sure(areaToolbar: AreaToolbar, textField: UITextField, locate: Location, item: UIBarButtonItem)
    func cancel(areaToolbar: AreaToolbar, textField: UITextField, locate: Location, item: UIBarButtonItem)
}


class AreaToolbar: UIToolbar {
    
   weak var barDelegate: AreaToolbarDelegate?
    var textField: UITextField!
    
    static func bar<T: UIViewController>(for controller: T, textField: UITextField, barTintColor: UIColor, tintColor: UIColor) -> AreaToolbar where T: AreaToolbarDelegate {
        let toolBar = AreaToolbar()
        toolBar.textField = textField
        toolBar.barDelegate = controller
        let cancelItem = UIBarButtonItem(title: "取消", style: .plain, target: toolBar, action: #selector(areaPickerCancel(_:)))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let sureItem = UIBarButtonItem(title: "确定", style: .plain, target: toolBar, action: #selector(areaPickerSure(_:)))
        toolBar.items = [cancelItem, flexibleItem, sureItem]
        
        toolBar.barTintColor = barTintColor
        toolBar.tintColor = tintColor
        return toolBar
    }
    
    private init(){
        super.init(frame: CGRect(x: 0, y: 0, width: APMAIN_WIDTH, height: 44))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func areaPickerCancel(_ item: UIBarButtonItem) {
        textField.resignFirstResponder()
        barDelegate?.cancel(areaToolbar: self, textField: textField, locate: locate, item: item)
    }
    
    func areaPickerSure(_ item: UIBarButtonItem) {
                textField.resignFirstResponder()
        barDelegate?.sure(areaToolbar: self, textField: textField, locate: locate, item: item)
    }
    
    // MARK: - lazy
    lazy var locate: Location = {
       return Location()
    }()


}
