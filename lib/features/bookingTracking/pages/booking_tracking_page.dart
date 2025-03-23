import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mlock_flutter/core/permission/bloc/permissions_bloc.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/core/utils/my_dialog.dart';
import 'package:mlock_flutter/core/utils/my_snackbar.dart';
import 'package:mlock_flutter/data/location/bloc/location_bloc.dart';
import 'package:mlock_flutter/data/user/bloc/user_bloc.dart';
import 'package:mlock_flutter/features/bookingTracking/bloc/booking_tracking_bloc.dart';
import 'package:mlock_flutter/features/bookingTracking/models/booking_model.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';
import 'package:mlock_flutter/features/rating/pages/rating_page.dart';

class BookingTrackingPage extends StatefulWidget {
  const BookingTrackingPage({super.key});

  @override
  State<BookingTrackingPage> createState() => _BookingTrackingPageState();
}

class _BookingTrackingPageState extends State<BookingTrackingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  BitmapDescriptor? _lockerMarkerIcon;
  final CountDownController _countDownController = CountDownController();
  int _remainingSeconds = 0;
  bool _isInExtraTime = false;
  int _extraTimeSeconds = 0;
  Timer? _extraTimeTimer;
  // UserState? userstate;
  final String userPhone = '9826080407';
  final userName = "John Doe";
  final userEmail = "john@example.com";

  LatLng? _userLocation;
  LatLng? _lockerStationLocation;
  bool _isRouteDrawn = false;

  // Google Maps API key
  final String googleApiKey = "AIzaSyAQ1Rteb95EX5lsssLzLITcPmn1PCw8DGA";

  @override
  void initState() {
    super.initState();

    markerImageLoader();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermissionsBloc>().add(CheckPermissionsEvent());
      context.read<BookingTrackingBloc>().add(
        FetchBookingDetailsBookingTrackingEvent(),
      );

      final permissionState = context.read<PermissionsBloc>().state;

      if (permissionState.status == PermissionStatusI.granted) {
        context.read<LocationBloc>().add(StartTrackingEvent());
      }
    });
  }

  @override
  void dispose() {
    _extraTimeTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locationState = context.read<LocationBloc>().state;
    final bookingState = context.read<BookingTrackingBloc>().state;
    // userstate = context.read<UserBloc>().state;

    if (locationState.status == LocationStatus.updated &&
        locationState.position != null) {
      // Update user location
      _userLocation = LatLng(
        locationState.position!.latitude,
        locationState.position!.longitude,
      );

      _centerOnUserLocation(locationState.position!);

      // Check if booking is loaded and try to draw route
      if (bookingState.status == BookingTrackingStatus.loaded &&
          bookingState.booking != null &&
          bookingState.booking!.lockerStation != null) {
        _updateLockerStationLocation(bookingState.booking!.lockerStation!);
        _attemptDrawRoute();
      }
    }

    context.read<LocationBloc>().add(StartTrackingEvent());
  }

  void markerImageLoader() {
    BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48), devicePixelRatio: 0.5),
      'assets/images/lockers.png',
    ).then((icon) {
      setState(() {
        _lockerMarkerIcon = icon;
      });
    });
  }

  void _setupCountdownTimer(BookingModel booking) {
    if (booking.checkoutTime == null) return;

    final now = DateTime.now();

    if (booking.checkoutTime!.isAfter(now)) {
      // Normal countdown case
      _remainingSeconds = booking.checkoutTime!.difference(now).inSeconds;
      _isInExtraTime = false;

      // Cancel any existing extra time timer
      _extraTimeTimer?.cancel();
    } else {
      // Extra time case
      _isInExtraTime = true;
      _extraTimeSeconds = now.difference(booking.checkoutTime!).inSeconds;

      // Start a timer to update the extra time counter
      _extraTimeTimer?.cancel();
      _extraTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _extraTimeSeconds++;
          });
        } else {
          timer.cancel();
        }
      });
    }

    setState(() {});
  }

  void _updateLockerStationLocation(LockerStation lockerStation) {
    _lockerStationLocation = LatLng(
      lockerStation.location.coordinates[0],
      lockerStation.location.coordinates[1],
    );
  }

  void _addLockerMarker(LockerStation lockerStation) {
    if (_lockerMarkerIcon == null) return;

    // Update locker station location
    _updateLockerStationLocation(lockerStation);

    final lockerMarker = Marker(
      markerId: MarkerId(lockerStation.id),
      position: _lockerStationLocation!,
      icon: _lockerMarkerIcon ?? BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: lockerStation.stationName,
        snippet: lockerStation.address,
      ),
    );

    setState(() {
      _markers.add(lockerMarker);
    });

    // Try to draw route after adding marker
    _attemptDrawRoute();
  }

  // Attempt to draw route if both locations are available
  void _attemptDrawRoute() {
    if (_userLocation != null &&
        _lockerStationLocation != null &&
        !_isRouteDrawn) {
      _drawRoute();
    }
  }

  // Method to draw route from user location to locker station
  Future<void> _drawRoute() async {
    if (_userLocation == null || _lockerStationLocation == null) return;

    try {
      // Clear previous coordinates
      _polylineCoordinates.clear();

      // Request route from Google Directions API
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(
            _userLocation!.latitude,
            _userLocation!.longitude,
          ),
          destination: PointLatLng(
            _lockerStationLocation!.latitude,
            _lockerStationLocation!.longitude,
          ),
          mode: TravelMode.driving,
        ),
      );

      // Process result and add points to polyline coordinates
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        // Mark route as drawn
        _isRouteDrawn = true;

        // Update the polyline on the map
        setState(() {
          // Remove previous route if exists
          _polylines.removeWhere(
            (polyline) => polyline.polylineId.value == 'route',
          );

          // Add new route
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              color: Colors.blue,
              width: 5,
              points: _polylineCoordinates,
              patterns: [
                PatternItem.dash(20),
                PatternItem.gap(10),
              ], // Optional: makes it a dashed line
            ),
          );
        });

        // Adjust camera to show both user and locker station
        _fitBoundsOnMap();
      } else {
        // Handle no points case (e.g., log or show message)
        print("No route points returned from API: ${result.errorMessage}");
      }
    } catch (e) {
      print("Error drawing route: $e");
    }
  }

  // Adjust map to fit both user and locker station
  void _fitBoundsOnMap() {
    if (_mapController == null ||
        _userLocation == null ||
        _lockerStationLocation == null)
      return;

    try {
      // Create bounds that include both points
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          _userLocation!.latitude < _lockerStationLocation!.latitude
              ? _userLocation!.latitude
              : _lockerStationLocation!.latitude,
          _userLocation!.longitude < _lockerStationLocation!.longitude
              ? _userLocation!.longitude
              : _lockerStationLocation!.longitude,
        ),
        northeast: LatLng(
          _userLocation!.latitude > _lockerStationLocation!.latitude
              ? _userLocation!.latitude
              : _lockerStationLocation!.latitude,
          _userLocation!.longitude > _lockerStationLocation!.longitude
              ? _userLocation!.longitude
              : _lockerStationLocation!.longitude,
        ),
      );

      // Add padding
      final padding = 100.0;

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, padding),
      );
    } catch (e) {
      print("Error fitting bounds: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Tracking')),
      body: MultiBlocListener(
        listeners: [
          // Permission listener
          BlocListener<PermissionsBloc, PermissionsState>(
            listenWhen:
                (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == PermissionStatusI.granted) {
                context.read<LocationBloc>().add(StartTrackingEvent());
              } else if (state.status == PermissionStatusI.denied) {
                MyDialog.showPermissionDialog(context);
              }
            },
          ),

          BlocListener<LocationBloc, LocationState>(
            listenWhen:
                (previous, current) =>
                    previous.status != current.status ||
                    (previous.position != null &&
                        current.position != null &&
                        (previous.position!.latitude !=
                                current.position!.latitude ||
                            previous.position!.longitude !=
                                current.position!.longitude)),
            listener: (context, state) {
              if (state.status == LocationStatus.updated &&
                  state.position != null) {
                _updateUserLocation(state.position!);
              } else if (state.status == LocationStatus.error) {
                MySnackbar.showErrorSnackbar(context, state.error);
              }
            },
          ),

          BlocListener<BookingTrackingBloc, BookingTrackingState>(
            listenWhen:
                (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == BookingTrackingStatus.loaded &&
                  state.booking != null) {
                if (state.booking!.lockerStation != null) {
                  _addLockerMarker(state.booking!.lockerStation!);
                  _setupCountdownTimer(state.booking!);
                }
              } else if (state.status ==
                  BookingTrackingStatus.checkoutSuccess) {
                // Dismiss loading dialog if it's showing
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context, rootNavigator: true).pop();
                }

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder:
                        (context) => RatingPage(
                          lockerStationId: state.booking!.lockerStation!.id,
                        ),
                  ),
                );

                // Show success message
                // showDialog(
                //   context: context,
                //   builder:
                //       (context) => AlertDialog(
                //         title: const Text('Checkout Successful'),
                //         content: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             const Text(
                //               'Your locker has been successfully checked out.',
                //             ),
                //             if (state.extraTimePayment != null) ...[
                //               const SizedBox(height: 8),
                //               Text(
                //                 'Extra time charge: \$${state.extraTimePayment!.toStringAsFixed(2)}',
                //                 style: const TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ],
                //           ],
                //         ),
                //         actions: [
                //           ElevatedButton(
                //             onPressed: () {
                //               Navigator.of(context).pushReplacement(
                //                 MaterialPageRoute(
                //                   builder:
                //                       (context) => RatingPage(
                //                         lockerStationId:
                //                             state.booking!.lockerStation!.id,
                //                       ),
                //                 ),
                //               );
                //             },
                //             child: const Text('OK'),
                //           ),
                //         ],
                //       ),
                // );
              } else if (state.status ==
                  BookingTrackingStatus.checkoutProcessing) {
                Center(child: CircularProgressIndicator());
              } else if (state.status == BookingTrackingStatus.error) {
                // Dismiss loading dialog if it's showing
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
                MySnackbar.showErrorSnackbar(
                  context,
                  state.error ?? 'Failed to process your request',
                );
              } else if (state.status == BookingTrackingStatus.paymentFailure) {
                MySnackbar.showErrorSnackbar(context, state.error);
              }
            },
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Wrap the map section in a BlocBuilder to conditionally show it
                BlocBuilder<BookingTrackingBloc, BookingTrackingState>(
                  builder: (context, state) {
                    if (state.status == BookingTrackingStatus.loaded &&
                        state.booking != null &&
                        state.booking!.lockerStation != null) {
                      // Only show map when booking is found
                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.02,
                          ),
                          child: Stack(
                            children: [
                              GoogleMap(
                                initialCameraPosition: const CameraPosition(
                                  target: LatLng(0, 0),
                                  zoom: 2,
                                ),
                                zoomControlsEnabled: false,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                mapToolbarEnabled: false,
                                markers: _markers,
                                polylines: _polylines,
                                onMapCreated: (controller) {
                                  _mapController = controller;
                                  _attemptDrawRoute();
                                },
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: FloatingActionButton(
                                  heroTag: 'trackingActionButton',
                                  mini: screenWidth < 400,
                                  onPressed: () {
                                    final locationState =
                                        context.read<LocationBloc>().state;
                                    if (locationState.position != null) {
                                      _centerOnUserLocation(
                                        locationState.position!,
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.my_location),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: FloatingActionButton(
                                  heroTag: 'redrawRouteButton',
                                  mini: screenWidth < 400,
                                  onPressed: () {
                                    _isRouteDrawn = false;
                                    _attemptDrawRoute();
                                  },
                                  child: const Icon(Icons.route),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // If no booking found, return an empty container instead of the map
                      return Expanded(child: Container());
                    }
                  },
                ),

                // Keep the original booking details section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.02,
                  ),
                  child: BlocBuilder<BookingTrackingBloc, BookingTrackingState>(
                    builder: (context, state) {
                      if (state.status == BookingTrackingStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.status == BookingTrackingStatus.loaded &&
                          state.booking != null) {
                        return _buildCountdownSection(
                          state.booking!,
                          screenWidth,
                        );
                      } else if (state.status ==
                          BookingTrackingStatus.notFound) {
                        return _buildNoBookingContent(screenWidth);
                      } else if (state.status == BookingTrackingStatus.error) {
                        return Center(
                          child: Text(
                            'Error: ${state.error ?? 'Unknown error'}',
                          ),
                        );
                      } else {
                        return _buildNoBookingContent(screenWidth);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Create a separate helper method for the no booking content
  Widget _buildNoBookingContent(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Active Booking Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'You don\'t have any active bookings at the moment.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(screenWidth * 0.6, 48),
            ),
            onPressed: () {
              // Navigate to booking creation page
            },
            child: const Text('Create New Booking'),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownSection(BookingModel booking, double screenWidth) {
    final isActive = booking.checkoutTime?.isAfter(DateTime.now()) ?? false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Locker: ${booking.lockerStation!.stationName} - ${booking.locker!.lockerNumber}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          if (booking.checkoutTime != null)
            Center(
              child:
                  isActive
                      ? CircularCountDownTimer(
                        initialDuration: 0,
                        controller: _countDownController,
                        width: screenWidth * 0.5,
                        fillColor: Colors.blue,
                        height: screenWidth * 0.5,
                        duration: _remainingSeconds,
                        ringColor: Colors.grey[300]!,
                        backgroundColor: Colors.white,
                        strokeWidth: 15.0,
                        strokeCap: StrokeCap.round,
                        textStyle: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textFormat: CountdownTextFormat.HH_MM_SS,
                        isReverse: true,
                        autoStart: true,
                        onComplete: () {
                          if (mounted) {
                            setState(() {
                              _isInExtraTime = true;
                              _extraTimeSeconds = 0;

                              // Start a timer to update the extra time counter
                              _extraTimeTimer?.cancel();
                              _extraTimeTimer = Timer.periodic(
                                const Duration(seconds: 1),
                                (timer) {
                                  if (mounted) {
                                    setState(() {
                                      _extraTimeSeconds++;
                                    });
                                  } else {
                                    timer.cancel();
                                  }
                                },
                              );
                            });
                          }
                        },
                      )
                      : _buildExtraTimeDisplay(screenWidth),
            ),

          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(screenWidth * 0.9, 48),
              backgroundColor: isActive ? Colors.blue : Colors.red,
            ),
            onPressed: () {
              _handleCheckout(booking);
            },
            child: const Text('Checkout Now'),
          ),
        ],
      ),
    );
  }

  void _handleCheckout(BookingModel booking) {
    // Get booking ID and check if in extra time
    final bookingId = booking.id;
    final hasExtraTime = _isInExtraTime;
    final extraTimeSeconds = _extraTimeSeconds;

    // Calculate rental price per minute (you might need to get this from booking)
    // For demonstration, let's set a default value
    final rentalPrice = booking.rentalPrice;

    // Calculate extra seconds if in extra time
    final checkoutTime = DateTime.now();
    final extraSeconds =
        checkoutTime.difference(booking.checkoutTime!).inSeconds;

    // Show confirmation dialog with extra time payment if needed
    if (hasExtraTime) {
      final extraPayment = (extraTimeSeconds / 60) * rentalPrice;

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Extra Time Payment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booked time: ${_formatDuration(booking.duration)}'),
                  Text(
                    'Extra time: ${_formatDuration(extraTimeSeconds ~/ 60)}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Extra charge: ₹${extraPayment.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    // Dispatch checkout event with extra time
                    context.read<BookingTrackingBloc>().add(
                      CheckoutBookingEvent(
                        bookingId: bookingId,
                        hasExtraTime: true,
                        extraTimeSeconds: extraSeconds,
                        rentalPrice: rentalPrice,
                        userEmail: userEmail,
                        userName: userName,
                        userPhone: userPhone,
                      ),
                    );
                    // Show loading dialog
                    _showLoadingDialog();
                  },
                  child: const Text('Pay & Checkout'),
                ),
              ],
            ),
      );
    } else {
      // No extra time, just confirm checkout
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Confirm Checkout'),
              content: const Text('Are you sure you want to checkout now?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Dispatch regular checkout event

                    // logger.d('user: ${userstate!.user}');

                    // final userState = context.read<UserBloc>().state;
                    // logger.d('user: ${userState.user}');

                    context.read<BookingTrackingBloc>().add(
                      CheckoutBookingEvent(
                        bookingId: bookingId,
                        hasExtraTime: false,
                        extraTimeSeconds: 0,
                        rentalPrice: rentalPrice,
                        userEmail: userEmail,
                        userPhone: userPhone,
                        userName: userName,
                      ),
                    );
                    // Show loading dialog
                    _showLoadingDialog();
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
      );
    }
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes minutes';
    } else {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return hours > 0
          ? '$hours hour${hours > 1 ? 's' : ''}${mins > 0 ? ' $mins minute${mins > 1 ? 's' : ''}' : ''}'
          : '$mins minute${mins > 1 ? 's' : ''}';
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing checkout...'),
              ],
            ),
          ),
    );
  }

  Widget _buildExtraTimeDisplay(double screenWidth) {
    // Format extra time as hours, minutes, seconds
    final hours = _extraTimeSeconds ~/ 3600;
    final minutes = (_extraTimeSeconds % 3600) ~/ 60;
    final seconds = _extraTimeSeconds % 60;

    final timeString =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Column(
      children: [
        Container(
          width: screenWidth * 0.5,
          height: screenWidth * 0.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.red, width: 15.0),
          ),
          child: Center(
            child: Text(
              timeString,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'EXTRA TIME',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  void _updateUserLocation(Position position) {
    _centerOnUserLocation(position);

    // Update user location for route calculation
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });

    // Check if route needs to be redrawn
    if (_lockerStationLocation != null && !_isRouteDrawn) {
      _drawRoute();
    }
  }

  void _centerOnUserLocation(Position position) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18,
        ),
      ),
    );
  }

  //--------------------------
}
