import 'package:logger/logger.dart';

class LoggerW {
  // Sample of abstract logging function
  static void write(String text, {bool isError = false}) {
    Future.microtask(() => print('** $text. isError: [$isError]'));
  }

  var logger = Logger(
      printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          colors: true,
          printEmojis: true,
          printTime: true));
}

class LogSingleton {
  static Logger? _log = null;
  // 私有的命名构造函数
  LogSingleton._internal();
  static Logger? getInstance() {
    // ignore: unnecessary_null_comparison
    if (_log == null) {
      _log = Logger(
          printer: PrettyPrinter(
              methodCount: 2,
              errorMethodCount: 8,
              colors: true,
              printEmojis: true,
              printTime: true));
    }

    return _log;
  }
}

class Log {
  static String TAG = "yancheng";
  static void d(String message) {
    LogSingleton.getInstance()?.d("$TAG:$message");
  }

  static void w(String message) {
    LogSingleton.getInstance()?.w("$TAG:$message");
  }

  static void e(String message) {
    LogSingleton.getInstance()?.e("$TAG:$message");
  }
}
