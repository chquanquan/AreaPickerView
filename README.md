# AreaPickerView_swift
areapicker in china, easy to use. 中国的地区选择器.简单易用.

之前的地址选择器都是网上找的,但是网上的第三方,功能很多,看起来还要配置不少东西.用起来麻烦. 然后,我就自己写了一个.只有地址选择功能,连数据源都自己搞好…方便很多.后来想想不知道,有没有人也像我一样只是想到一个简单的地区选择器而已.然后,我就上传上github上面了….. 希望有人能看到吧…

![Alt Text](https://github.com/chquanquan/AreaPickerView_swift/blob/master/Simulator%20Screen%20Shot%202017年1月28日%2020.10.22.png)


把AreaPickerView文件夹拖到你的工程,按类方法创建pickerView....并遵守代理方法.demo应该可以说明用法.
xib和代码创建的textField都没有问题.....

实现三个代理方法
```
internal func cancel(areaToolbar: AreaToolbar, textField: UITextField, locate: Location, item: UIBarButtonItem) {
//还原原来的值......
}

internal func sure(areaToolbar: AreaToolbar, textField: UITextField, locate: Location, item: UIBarButtonItem) {
//设置新值
}

internal func statusChanged(areaPickerView: AreaPickerView, pickerView: UIPickerView, textField: UITextField, locate: Location) {
//立即显示新值
}
```


如果你使用过程有任何疑问,可以讨论下:  QQ:380341629
如果可以给个星,让我高兴一下? ^_^
