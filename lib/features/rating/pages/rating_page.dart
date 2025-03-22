import 'package:flutter/material.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';

class RatingPage extends StatelessWidget {
  final String bookingId;
  final LockerStation lockerStation;
  const RatingPage({
    super.key,
    required this.bookingId,
    required this.lockerStation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: const Text('Rating Page'));
  }
}
