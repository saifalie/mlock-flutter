import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mlock_flutter/core/permission/bloc/permissions_bloc.dart';
import 'package:mlock_flutter/core/utils/my_dialog.dart';
import 'package:mlock_flutter/core/utils/my_snackbar.dart';
import 'package:mlock_flutter/data/location/bloc/location_bloc.dart';
import 'package:mlock_flutter/features/map/bloc/locker_station_bloc.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  // bool _initialCameraSet = false;

  // -------new code---------
  final PageController _pageController = PageController();
  List<LockerStationModel> _lockerStations = [];
  int _selectedIndex = 0;
  BitmapDescriptor? _lockerMarkerIcon; // Store the custom icon
  //-----------------------------

  @override
  void initState() {
    super.initState();

    markerImageLoader();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermissionsBloc>().add(CheckPermissionsEvent());

      // --------new code--------
      // Check current permissions and start tracking if granted
      final permissionsState = context.read<PermissionsBloc>().state;
      if (permissionsState.status == PermissionStatusI.granted) {
        context.read<LocationBloc>().add(StartTrackingEvent());
      }

      //-------------------------
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ------------------marker custom icon
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
  //---------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          // Permission listener
          BlocListener<PermissionsBloc, PermissionsState>(
            listener: (context, state) {
              if (state.status == PermissionStatusI.granted) {
                context.read<LocationBloc>().add(StartTrackingEvent());
              } else if (state.status == PermissionStatusI.denied) {
                MyDialog.showPermissionDialog(context);
              }
            },
            listenWhen: (prev, curr) => prev.status != curr.status,
          ),

          // Location listener
          BlocListener<LocationBloc, LocationState>(
            listener: (context, state) {
              if (state.status == LocationStatus.error) {
                MySnackbar.showErrorSnackbar(context, state.error);
              } else if (state.status == LocationStatus.updated &&
                  state.position != null) {
                _updateUserLocation(state.position!, state.radiusMeters ?? 500);
              }
            },
          ),

          // Locker station listener
          BlocListener<LockerStationBloc, LockerStationState>(
            listener: (context, state) {
              if (state.status == LockerStationStatus.loaded &&
                  state.lockerStations != null) {
                _updateLockerStations(state.lockerStations!);
              }
            },
          ),
        ],
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              markers: _markers,
              zoomControlsEnabled: false,
              circles: _circles,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              //----------new code--------------
              onTap:
                  (_) => _pageController.animateToPage(
                    0,
                    duration: const Duration(microseconds: 300),
                    curve: Curves.easeInOut,
                  ),
              //----------------------------------------------
            ),

            //----------------new code-------pagebuilder--------------------
            Positioned(
              bottom: 7,
              left: 10,
              right: 10,
              child: Container(
                height: 220,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _lockerStations.length,
                  onPageChanged: (index) {
                    setState(() => _selectedIndex = index);
                    _centerOnMarker(_lockerStations[index]);
                  },
                  itemBuilder: (context, index) {
                    final station = _lockerStations[index];
                    return _LockerStationCard(
                      station: station,
                      isSelected: index == _selectedIndex,
                    );
                  },
                ),
              ),
            ),
            //---------------------------------------------------

            // My location button
            Positioned(
              bottom: 220,
              right: 16,
              child: FloatingActionButton(
                heroTag: "locationButton",
                mini: true,
                onPressed: () {
                  final locationState = context.read<LocationBloc>().state;
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
    );
  }

  void _updateUserLocation(Position position, double radiusMeters) {
    // -----new code-----
    // Center camera on EVERY location update
    _centerOnUserLocation(position); // Always call this

    //------------------------

    // Update radius circle
    final userCircle = Circle(
      circleId: const CircleId('user_radius'),
      center: LatLng(position.latitude, position.longitude),
      radius: radiusMeters,
      strokeWidth: 2,
      strokeColor: Colors.blue,
      fillColor: Colors.blue.withOpacity(0.15),
    );

    setState(() {
      _circles.clear();
      _circles.add(userCircle);
    });

    // Trigger locker station search
    context.read<LockerStationBloc>().add(LoadLockerStationEvent(position));
  }

  void _updateLockerStations(List<LockerStationModel> stations) {
    //---------------new code----------------
    _lockerStations = stations;

    final stationMarkers =
        stations.asMap().entries.map((entry) {
          final index = entry.key;
          final station = entry.value;

          return Marker(
            markerId: MarkerId('station_${station.id}'),
            position: station.location.coordinates,
            icon:
                _lockerMarkerIcon ??
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
            infoWindow: InfoWindow(
              title: station.stationName,
              snippet: station.address,
            ),
            anchor: const Offset(0.5, 0.5),
            flat: true,
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              _centerOnMarker(station);
            },
          );
        }).toSet();

    setState(() {
      _markers.removeWhere((m) => m.markerId.value.startsWith('station_'));
      _markers.addAll(stationMarkers);
    });

    //----------------------------------
    // Prepare station markers
    // final stationMarkers =
    //     stations
    //         .map(
    //           (station) => Marker(
    //             markerId: MarkerId('station_${station.id}'),
    //             position: station.location.coordinates,
    //             icon: BitmapDescriptor.defaultMarkerWithHue(
    //               BitmapDescriptor.hueOrange,
    //             ),
    //             infoWindow: InfoWindow(
    //               title: station.stationName,
    //               snippet: station.address,
    //             ),
    //           ),
    //         )
    //         .toSet();

    // // Update markers
    // setState(() {
    //   _markers.removeWhere((m) => m.markerId.value.startsWith('station_'));
    //   _markers.addAll(stationMarkers);
    // });
  }

  void _centerOnUserLocation(Position position) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  //---------------new code-----------------------

  void _centerOnMarker(LockerStationModel station) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: station.location.coordinates,
          zoom: 15,
          bearing: 30,
          tilt: 90,
        ),
      ),
    );
  }

  //----------------------------------------
}

//-----------------new code--------------------

class _LockerStationCard extends StatelessWidget {
  final LockerStationModel station;
  final bool isSelected;

  const _LockerStationCard({required this.station, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              station.stationName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              station.address,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            // Add more station details here
          ],
        ),
      ),
    );
  }
}
