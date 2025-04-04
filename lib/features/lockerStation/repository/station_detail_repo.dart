import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/lockerStation/repository/station_detail_api.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';

class StationDetailRepo {
  final StationDetailApi _stationDetailApi;

  StationDetailRepo({required StationDetailApi stationDetailApi})
    : _stationDetailApi = stationDetailApi;

  Future<Map<String, dynamic>> getParticularStation({
    required String stationId,
  }) async {
    try {
      final response = await _stationDetailApi.fetchParticularStation(
        stationId: stationId,
      );

      logger.d('repo repo $response');
      final rawData = response['data'];

      logger.d('Raw Api response Particular Station: $rawData');

      final station = LockerStation.fromJson(rawData['lockerStation']);

      return {
        'station': station,
        'hasActiveBooking': rawData['hasActiveBooking'],
      };
    } catch (e) {
      logger.e('Error StationDetail getParticularStation method: $e');
      rethrow;
    }
  }

  Future<bool> toggleSaveStationRepo(String stationId) async {
    try {
      final response = await _stationDetailApi.toggleSaveStation(stationId);
      logger.d('toggleSaveStationRepo data: $response');
      return response['data']['isSaved'];
    } catch (e) {
      logger.e('Toggle save error: $e');
      rethrow;
    }
  }

  Future<bool> isStationSavedRepo(String stationId) async {
    try {
      final response = await _stationDetailApi.checkSavedStatus(stationId);

      logger.d('isStationSavedRepo data: $response');
      return response['data']['isSaved'];
    } catch (e) {
      logger.e('Check saved error: $e');
      return false;
    }
  }
}
