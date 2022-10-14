import 'package:distractfreeyt/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookmarklink {
  static late SharedPreferences _preferences;

  static const _key = 'link';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future save(List<String> link) async =>
      await _preferences.setStringList(_key, link);

  static List<String>? getdata() => _preferences.getStringList(_key);
}
