import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String USER_DATA_KEY = 'user_data';
  static const String USER_FETCH_TIME_KEY = 'user_fetch_time';

  // Generic method to save data
  Future<bool> saveData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, jsonEncode(data));
  }

  // Generic method to retrieve data
  Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return null;
    return jsonDecode(data);
  }

  // Generic method to save timestamp
  Future<bool> saveTimestamp(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(
      '${key}_timestamp',
      DateTime.now().toIso8601String(),
    );
  }

  // Generic method to get timestamp
  Future<DateTime?> getTimestamp(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final timestamp = prefs.getString('${key}_timestamp');

    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  // Clear specific cache
  Future<bool> clearCache(String key) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('${key}_timestamp');
    return prefs.remove(key);
  }

  // Clear all cache
  Future<bool> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
