import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String key = 'barCodeHistoryKey';

  static Future<void> saveHistory(String barCode, String label) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> history = preferences.getStringList(key) ?? [];

    final entryList = {
      'label': label,
      'time': _buildOnTime(),
      'barCode': barCode,
    };

    history.add(jsonEncode(entryList));

    await preferences.setStringList(key, history);
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final data = preferences.getStringList(key) ?? [];

    return data
        .map((value) => jsonDecode(value) as Map<String, dynamic>)
        .toList();
  }

  static Future<void> deleteHistory(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> history = preferences.getStringList(key) ?? [];
    if (index >= 0 && index < history.length) {
      history.removeAt(index);

      await preferences.setStringList(key, history);
    }
  }

  static String _buildOnTime() {
    DateTime now = DateTime.now();
    return DateFormat('dd MMM yyyy, hh:mm a').format(now);
  }
}
