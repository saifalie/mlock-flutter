import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/lockerStation/repository/station_detail_api.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';

class StationDetailRepo {
  final StationDetailApi _stationDetailApi;

  StationDetailRepo({required StationDetailApi stationDetailApi})
    : _stationDetailApi = stationDetailApi;

  Future<LockerStation> getParticularStation({
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

      return station;
    } catch (e) {
      logger.e('Error StationDetail getParticularStation method: $e');
      rethrow;
    }
  }
}
