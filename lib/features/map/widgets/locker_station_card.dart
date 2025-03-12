import 'package:flutter/material.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_model.dart';

class LockerStationCard extends StatelessWidget {
  final LockerStationModel station;
  final bool isSelected;
  final VoidCallback? onTap;
  const LockerStationCard({
    super.key,
    required this.station,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
