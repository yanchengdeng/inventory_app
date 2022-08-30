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




### 一个模具会和多个标签关联如果读到多个标签，只显示一条模具信息，随机一个标签就可以了


### 问题确认
1. 缓存数据跟着账号走，这个账号是如何下发的？如果是h5的登录账号，如何获取
接口获取：rfidapp/rest/login/user
   
2. 本地已有数据  、再去网络下发任务 如何作对比取舍？

本地有和服务端的相同的 assetBindTaskId\labelReplaceTaskId\assetInventoryDetailId 
这些id 则用本地缓存的（缓存信息里包含用户操作数据，比服务端丰富），没有这些id 则视为新增的id任务

本地没有 服务器有，  本地增加
本地有   服务器没有， 本地删除
支付任务绑定 assetBindTaskId  只比对id
标签替换任务 labelReplaceTaskId  如果相同 哈需要比对 下发时间，如果下发时间不一致则删除本地 取网络
盘点任务  assetInventoryDetailId   同标签绑定任务一样，需要验证下发时间是否一致



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


3.网络数据与本地数据 差异处理问题：
a. 账号可在不同设备上登录，用本机存储数据业务。如 一台设备准备好了 几个模具任务，并且保存后 处于待上传状态
如果 切换到另一台设备时 ，此时给到新设备的数据仍然是 最初的状态和数据 仍需要操作一次。 数据高度同步的处理方式还是数据在后端处理最理想。
b.还有就是缓存问题，如果一台设备多个用户登录，用户使用过程中出现大量保存未上传，app里会保存大量图片。这个方案也是不可取的，参考微信处理方式
：微信也是以内存换性能，大量图片视频存放本地。导致一个app 多达十几个G 的存储空间。目前这个方案在常规app 不可取





###2022-08-14 待确定
盘点 ： 未完成的盘点里 任务没有标签的状况吗


###  FLUTTER 打包问题
1.对外提供包测试   使用 flutter build  APK  中的[D:\flutter_project\inventory_app\build\app\outputs\flutter-apk] debug_apk 
可以完整演示




##  2022-9=8-21
1. 键盘无中文输入法，盘点和绑定筛选页输入文字如何处理？
2. 接口返回的信息 都是字符串给出 导致很多业务逻辑要根据文字信息来处理，即不规范也容易出现后台改动前端功能失效问题，待接口修复方案
3. GPS 经纬度转换成 详细地址，使用高德需要申请key ,而且使用GPS 经纬度 不能直接用高德api 转换地址，需要调用高德接口做一步转化才可以，这里需要网络参与。而此时的操作场景
是无需网络也可以完成保存闭环。[目前APP已经做了 gps 自身可转换详细地址功能]
4. 一个账号可以在多个设备上登录，这样的逻辑会导致 本地与网络状态不匹配的问题，因为都有数据 已本地为准。其实这时候不同端的本地数据是有差异了



#2022-8-24
1. 读取页  返回键的意义到底如何定义 ： 正常有了保存功能的话，返回就是回到原始状态（返回和保存的区别）
2. 绑定时 读取到的标签数据 和其他操作数据，如果保存出现 标签被其他任务绑定时，这时候读取结果是不必保存的，如果保存基本是待上传，又会造成数据上传出现类似提示


#2022-8-29
<!-- 1. 盘点中读取RFID 倒计时 一分钟应该是偏长 ，正常5秒内应该都是可以读取出来，建议10秒足够了(现在绑定拍照自动获取rfid 是5秒，盘点中rfid读取为10秒) -->
2. app 我的页面可以增加清除缓存和版本信息的功能（后续也可能增加版本升级）









