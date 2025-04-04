import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/auth/models/user/user_model.dart';
import 'package:mlock_flutter/services/api/auth_api_services.dart';
import 'package:mlock_flutter/services/cache/user_cache_service.dart';

class UserRepository {
  final AuthApiServices _authApiServices;
  final UserCacheService _userCacheService;

  // Cache expiration time in minutes
  final int cacheExpirationMinutes = 15;

  UserRepository({
    required AuthApiServices authApiServices,
    required UserCacheService userCacheService,
  }) : _authApiServices = authApiServices,
       _userCacheService = userCacheService;

  Future<UserModel> getUserData({bool forceRefresh = false}) async {
    logger.d('getuser call');
    // If force refresh is requested, bypass the cache
    if (forceRefresh) {
      return _fetchAndCacheUserData();
    }

    // Check cache first
    final cacheData = await _userCacheService.getUserData();
    final lastFetchTime = await _userCacheService.getLastFetchTime();
    final now = DateTime.now();

    // If we have valid cached data, use it
    if (cacheData != null) {
      lastFetchTime != null &&
          now.difference(lastFetchTime).inMinutes < cacheExpirationMinutes;
      return UserModel(
        id: cacheData['_id'],
        name: cacheData['name'],
        email: cacheData['email'],
        profilePicture: cacheData['profilePicture'],
        coordinates: cacheData['location']['coordinates'],
        currentLocker: cacheData['currentLocker'],
      );
    }

    // Otherwise fetch fresh data
    return _fetchAndCacheUserData();
  }

  Future<UserModel> _fetchAndCacheUserData() async {
    final userData = await _authApiServices.getUserDataApi();

    // Cache the fresh data
    await _userCacheService.saveUserData(userData);
    await _userCacheService.saveLastFetchTime(DateTime.now());

    logger.d('userdata: $userData');

    return UserModel(
      id: userData['_id'],
      name: userData['name'],
      email: userData['email'],
      profilePicture: userData['profilePicture'],
      coordinates: userData['location']['coordinates'],
      currentLocker: userData['currentLocker'],
    );
  }

  // Update user data (and cache)

  // Future<UserModel> updateUserData(Map<String,dynamic> updates)async{
  //   final updatedData = await
  // }

  // Clear user data on logout
  Future<void> clearUserData() async {
    await _userCacheService.clearUserData();
  }
}
