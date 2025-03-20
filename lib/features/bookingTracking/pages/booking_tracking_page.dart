import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mlock_flutter/core/permission/bloc/permissions_bloc.dart';
import 'package:mlock_flutter/core/utils/my_dialog.dart';
import 'package:mlock_flutter/core/utils/my_snackbar.dart';
import 'package:mlock_flutter/data/location/bloc/location_bloc.dart';

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
  BitmapDescriptor? _lockerMarkerIcon;
  final CountDownController _countDownController = CountDownController();
  int _remainingSeconds = 0;
  

  @override
  void initState() {
    super.initState();

    markerImageLoader();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermissionsBloc>().add(CheckPermissionsEvent());

      final permissionState = context.read<PermissionsBloc>().state;

      if (permissionState.status == PermissionStatusI.granted) {
        context.read<LocationBloc>().add(StartTrackingEvent());
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locationState = context.read<LocationBloc>().state;

    if (locationState.status == LocationStatus.updated &&
        locationState.position != null) {
      _centerOnUserLocation(locationState.position!);
      //TODO: fetch the booking details
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Tracking')),
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
                (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == LocationStatus.updated &&
                  state.position != null) {
                _updateUserLocation(state.position!);
              } else if (state.status == LocationStatus.error) {
                MySnackbar.showErrorSnackbar(context, state.error);
              }
            },
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            final horizonatalMargin = screenWidth * 0.01;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.02,
                  ),
                  height: screenHeight * 0.5,
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
                        onMapCreated:
                            (controller) => _mapController = controller,
                      ),

                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: FloatingActionButton(
                          heroTag: 'locationButton',
                          mini: screenWidth < 400,
                          onPressed: () {
                            final locationState =
                                context.read<LocationBloc>().state;
                            if (locationState.position != null) {
                              _centerOnUserLocation(locationState.position!);
                            }
                          },
                          child: const Icon(Icons.my_location),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _updateUserLocation(Position position) async {
    _centerOnUserLocation(position);
    //show the path form user to the lockerstation
    //TODO:
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
}
