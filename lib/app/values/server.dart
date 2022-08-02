enum Environment { DEVELOPMENT, PRODUCTION }

const SERVER_ENV = Environment.DEVELOPMENT;

///接口域名统一配置  token失效返回 585
const SERVER_API_URL = 'http://47.102.199.31:59101/rfidapp/rest';

///文件服务地址  异常返回 500  已废弃
// const SERVER_FILE_API_URL =
//     'https://rfid-native-api.apps-qa.saic-gm.com/MidNodeJS/rest';

///文件上传
// const SERVER_FILE_UPLOAD =
//     'https://rol-web-supplier-qa.apps.saic-gm.com/openfile';

const SERVER_FILE_UPLOAD = 'https://csapi-qa.saic-gm.com/cs';

///返回结果为1 表示正确返回
const SERVER_RESULT_OK = 1;

///统一接口返回 585 则表示token过期需要重新登录获取
/// 文件服务则是 500 表示token 过期
const TOKEN_OUT_CODE = 585;
const FILE_SERVER_TOKEN_OUT_CODE = 500;
