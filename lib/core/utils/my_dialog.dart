import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlock_flutter/core/permission/bloc/permissions_bloc.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/booking/bloc/booking_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class MyDialog {
  static void showPermanentDenialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'You permanently denied location access. '
              'Please enable it in app settings to continue.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Close dialog first
                  Navigator.pop(context);

                  // Open device settings
                  final bool opened = await openAppSettings();

                  // Optional: Check if settings were opened
                  if (!opened) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to open settings')),
                    );
                  }
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
    );
  }

  static void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Location Permission Needed'),
            content: Text(
              'This app needs location access to function properly',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  logger.d('called the request again');
                  Navigator.pop(context);
                  context.read<PermissionsBloc>().add(
                    RequestLocationPermissionEvent(),
                  );
                },
                child: Text('Request Again'),
              ),
            ],
          ),
    );
  }

  static void showSuccessfullPaymentDialog(BuildContext context,BookingState state) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Booking Successful;'),
            content: Text(
              'Your locker has been booked successfully .\nBooking ID: ${state.bookingId}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
