# inventory_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

###  在线使用json to  data 
(https://javiercbk.github.io/json_to_dart/)[https://javiercbk.github.io/json_to_dart/]

(https://app.quicktype.io/)[https://app.quicktype.io/]

### 参考  UI  及 网络请求 参考  ：Flutter_duceecat_news_get

### 待确定
'0':'待绑定','1':'重新绑定','2':'已上传','？？？':'待上传'
1. 模具绑定列表    待上传的status 是多少？

```text
待调试
1. 设备  sdk 功能实现
2. 本地数据库
3. 水印图片
4. flutter 调用android 原生开发
```



### 接口异常处理
普通接口token 过期显示585
文件服务  返回500


```
读取标签设置
/**
* 设置天线功率
*绑定那边 是  500
盘点3000
* @param power 最大30，最小15
*/

public void setAntennaPower(int power) {

if (rfid_Reader != null) {
if (power > 30)
power = 3000;
else if (power < 5)
power = 500;
else
power = power * 100;
AntennaPower[] antennaPowers = new AntennaPower[1];
AntennaPower antennaPower = new AntennaPower(1, power);
antennaPowers[0] = antennaPower;
try {
rfid_Reader.setAntennaPower(antennaPowers);
} catch (Exception e) {
e.printStackTrace();
}
}
}


```


### 移植到安卓问题
1.测试 读取 rfid数据的sdk 在普通的安卓手机上读取失败
2.扫描sdk 在普通安卓手机上实现不了，目前看到设备上是有一个扫描按钮来触发的


### 一个模具会和多个标签关联如果读到多个标签，只显示一条模具信息，随机一个标签就可以了


