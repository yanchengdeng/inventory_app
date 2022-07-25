enum Environment { DEVELOPMENT, PRODUCTION }

const SERVER_ENV = Environment.DEVELOPMENT;

///接口域名统一配置  token失效返回 585
const SERVER_API_URL = 'http://47.102.199.31:59101/rfidapp/rest';

///文件服务地址  异常返回 500
const SERVER_FILE_API_URL =
    'https://rfid-native-api.apps-qa.saic-gm.com/MidNodeJS/rest';

///返回结果为1 表示正确返回
const SERVER_RESULT_OK = 1;

///统一接口返回 585 则表示token过期需要重新登录获取
const TOKEN_OUT_CODE = 585;
