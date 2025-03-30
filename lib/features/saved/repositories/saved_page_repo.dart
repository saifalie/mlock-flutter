import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';
import 'package:mlock_flutter/features/saved/repositories/saved_page_api.dart';

class SavedPageRepo {
  final SavedPageApi _savedPageApi;

  SavedPageRepo(this._savedPageApi);

  Future<List<LockerStation>> getSavedStationsRepo() async {
    try {
      final response = await _savedPageApi.getSavdStations();

      // Check if data is null or empty
      if (response['data'] == null || (response['data'] as List).isEmpty) {
        // Return an empty list when no saved stations
        return [];
      }

      final stationList =
          (response['data'] as List)
              .map((station) => LockerStation.fromJson(station))
              .toList();

      logger.d('list of saved stations repo: $stationList');
      logger.d('saved repo stations list: ${stationList[0].stationName}');

      return stationList;
    } catch (e) {
      logger.e('Error StationDetail getParticularStation method: $e');
      rethrow;
    }
  }
}
