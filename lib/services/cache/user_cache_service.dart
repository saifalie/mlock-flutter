import 'package:mlock_flutter/services/cache/cache_service.dart';

class UserCacheService {
  final CacheService _cacheService;

  UserCacheService(this._cacheService);

  //save user data
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    return _cacheService.saveData(CacheService.USER_DATA_KEY, userData);
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    final data = await _cacheService.getData(CacheService.USER_DATA_KEY);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  // save user fetch time
  Future<bool> saveLastFetchTime(DateTime time) async {
    return _cacheService.saveData(
      CacheService.USER_FETCH_TIME_KEY,
      time.toIso8601String(),
    );
  }

  // Get last fetch time

  Future<DateTime?> getLastFetchTime() async {
    final timeString = await _cacheService.getData(
      CacheService.USER_FETCH_TIME_KEY,
    );
    return timeString != null ? DateTime.parse(timeString) : null;
  }

  Future<void> clearUserData() async {
    await _cacheService.clearCache(CacheService.USER_DATA_KEY);
    await _cacheService.clearCache(CacheService.USER_FETCH_TIME_KEY);
  }
}
