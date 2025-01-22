import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String key = 'barCodeHistoryKey';

  static Future<void> saveHistory(String barCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> list = preferences.getStringList(key) ?? [];
    list.add('$barCode ${_buildOnTime()}');
    await preferences.setStringList(key, list);
    print(list);
  }

  static Future<List<String>> getHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getStringList(key) ?? [];
    return data;
  }

  static Future<void> deleteHistory(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> scanList = preferences.getStringList(key) ?? [];
    if (index >= 0 && index < scanList.length) {
      scanList.removeAt(index);

      await preferences.setStringList(key, scanList);

    }
  }


  static String _buildOnTime() {
    DateTime now = DateTime.now();
    String realTime = DateFormat('dd MMM yyyy, hh:mm a').format(now);
    return realTime;
  }
}
