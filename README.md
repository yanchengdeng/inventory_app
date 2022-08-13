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
'0':'待绑定','1':'重新绑定','2':'已上传','？？？':'待上传3'
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


### 问题确认
1. 缓存数据跟着账号走，这个账号是如何下发的？如果是h5的登录账号，如何获取
接口获取：rfidapp/rest/login/user
   
2. 本地已有数据  、再去网络下发任务 如何作对比取舍？

本地有和服务端的相同的 assetBindTaskId\labelReplaceTaskId\assetInventoryDetailId 
这些id 则用本地缓存的（缓存信息里包含用户操作数据，比服务端丰富），没有这些id 则视为新增的id任务

本地没有 服务器有，  本地增加
本地有   服务器没有， 本地删除
服务器和本地都有的情况下比对下发时间DISTRIBUTION_DATE：下发时间一致，不动；下发时间不一致，清空对应模具信息再缓存
因为替换和盘点的labelReplaceTaskId\assetInventoryDetailId  和绑定的assetBindTaskId不一样，相同模具重复下发时的ID是不变的，
需要借助下发时间做进一步判断是否需要删除缓存
3. 首页绑定




4. ## 接口：https://rfid-native-api.apps-qa.saic-gm.com/MidNodeJS/rest/file/token/get   获取获取文件token 会报x-mid-token 过期，这
## 应该不合理 ，正常用户在操作数据当中 提示过期  是否前面的数据都已经



#### 设计更改 ：
1· 详情页的扫描 和读写 用android 原生处理
2.上传图片地址为   ：上传的uuid  ed6baf02-ca1e-4e17-8751-566c872f8f66 


```text
待处理：
返回监听 或是 close页面监听 有些状态需要恢复初始值 ： tabselcted  、

```

##2022-08-11待确定问题：
1.拍照验证  一定要在拍照前读到 已有的rfid标签？？才可拍照
![img_1.png](img_1.png)

2.user/login 接口 还未完善去掉user-code 会报错，还未实现token 替换user-code
上 ST 的时候再把user-code 去掉



