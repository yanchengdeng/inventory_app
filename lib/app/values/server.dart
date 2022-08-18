enum Environment { DEVELOPMENT, SIT, PRODUCTION }

///为当前环境
const SERVER_ENV = Environment.SIT;

///=======================本地测试=======================================
///接口域名统一配置  token失效返回 585
const SERVER_API_URL1 = 'http://47.102.199.31:59101/rfidapp/rest';

///文件服务域名统一配置  pwlvjy(Test1234)
const SERVER_FILE_UPLOAD1 = 'https://csapi-qa.saic-gm.com/cs';

///==========================SIT 测试使用 统一改用改域名========================
const SERVER_API_URL =
    'https://rfid-native-api.apps-qa.saic-gm.com/MidNodeJS/rest';

/**
 * 文件上传有两种方式
1.直接用文件服务器的地址。例如https://csapi-qa.saic-gm.com/cs/file/frontend/upload
2.网关Nginx代理，{host}/FileUpload/file/frontend/upload
 */

const SERVER_FILE_UPLOAD = 'https://csapi-qa.saic-gm.com/cs';

///文件服务地址  异常返回 500  已废弃
/// const SERVER_FILE_API_URL =
///    'https://rfid-native-api.apps-qa.saic-gm.com/MidNodeJS/rest';

///文件上传   已废弃
/// const SERVER_FILE_UPLOAD =
///    'https://rol-web-supplier-qa.apps.saic-gm.com/openfile';

///返回结果为1 表示正确返回
const SERVER_RESULT_OK = 1;

///统一接口返回 585 则表示token过期需要重新登录获取
/// 文件服务则是 500 表示token 过期
const TOKEN_OUT_CODE = 585;
const FILE_SERVER_TOKEN_OUT_CODE = 500;
