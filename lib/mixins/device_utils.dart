import 'dart:math';

mixin DeviceUtils {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final _rnd = Random();

  String getRandomString(int length) {
    String randomString = "";
    for (int i = 0; i < length; i++) {
      randomString += _chars[_rnd.nextInt(_chars.length)];
    }
    return randomString;
  }
}
