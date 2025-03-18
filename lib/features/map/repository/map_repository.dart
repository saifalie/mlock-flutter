import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';
import 'package:mlock_flutter/features/map/repository/map_api_service.dart';

class MapRepository {
  final MapApiService _mapApiService;
  // final Map<String, dynamic> _lockerStationCache = {};
  // DateTime? _lastFetchTime;

  MapRepository({required MapApiService mapApiService})
    : _mapApiService = mapApiService;

  Future<Map<String, dynamic>> fetchNearbyLockerStation({
    required String latitude,
    required String longitude,
  }) async {
    try {
      final response = await _mapApiService.fetchNearbyLockerStation(
        latitude: latitude,
        longitude: longitude,
      );

      logger.d('nearlockerstation repo: ${response['data']}');
      return response['data'];
    } catch (e) {
      logger.e('Error in FetchNearbyLockerStation method repo : $e');
      rethrow;
    }
  }

  Future<List<LockerStation>> getAllLockerStation() async {
    try {
      final response = await _mapApiService.getAllLockerStation();

      final List<dynamic> rawData = response['data'];

      logger.d('Raw API response: ${response.toString()}');
      logger.d('Response type: ${response.runtimeType}');
      logger.d('response data type: ${response['data'].runtimeType}');

      final stations =
          rawData
              .map(
                (item) => LockerStation.fromJson(item as Map<String, dynamic>),
              )
              .toList();

      return stations;
      // logger.d('getalllockersattion repo: ${response['data']}');
      // return response['data'];
    } catch (e) {
      logger.e('Error in get All lockerstation method repo: $e');
      rethrow;
    }
  }
}
