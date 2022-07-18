/**
 * author : yanc
 * data : 2022/6/28
 * time : 23:17
 * desc : 常量信息
 */

///模具任务状态  -1  默认全部状态
const int BIND_STATUS_ALL = -1;
const int BIND_STATUS_WAING = 0;
const int BIND_STATUS_REBIND = 1;
const int BIND_STATUS_UPLOADED = 2;
const int BIND_STATUS_WAITING_UPLOAD = 3;

const MOULD_BIND_STATUS = {
  BIND_STATUS_ALL: '全部',
  BIND_STATUS_WAING: '待绑定',
  BIND_STATUS_REBIND: '重新绑定',
  BIND_STATUS_UPLOADED: '已上传',
  BIND_STATUS_WAITING_UPLOAD: '待上传'
};

/// 工装类型
const String TOOL_TYPE_F = 'F';
const String TOOL_TYPE_G = 'G';
const String TOOL_TYPE_M = 'M';

///任务类型   0为支付，1为标签替换
const int MOULD_TASK_TYPE_PAY = 0;
const int MOULD_TASK_TYPE_LABEL = 1;

///card 阴影值 elevation
const double CARD_ELEVATION = 5.0;

const String WEB_LOGIN_URL_HOST = 'https://sgm-stg.login.ap1.covapp.io/login.do?';

///网页登录地址  测试账号 寒武蚂蚁:
/// REBE002/Test4444
/// REBE002ADMIN/Test4444
const String WEB_LOGIN_URL =
    'http://sgm-stg.broker.ap1.covapp.io/fed/app/idp.saml20?entityID=https://spdev.saic-gm.com/spsaml20/rfid&TARGET=https://spdev.saic-gm.com/spsaml20/rfid';

///分割去除 token
const SPLIT_URL = 'x-mid-token=';
