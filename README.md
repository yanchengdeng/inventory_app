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



