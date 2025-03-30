import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mlock_flutter/core/permission/bloc/permissions_bloc.dart';
import 'package:mlock_flutter/core/theme/app_theme.dart';
import 'package:mlock_flutter/core/utils/my_dialog.dart';
import 'package:mlock_flutter/core/utils/my_snackbar.dart';
import 'package:mlock_flutter/data/location/bloc/location_bloc.dart';
import 'package:mlock_flutter/features/lockerStation/pages/locker_station_page.dart';
import 'package:mlock_flutter/features/map/bloc/locker_station_bloc.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false; // Set to false to rebuild when revisiting

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  // bool _initialCameraSet = false;

  // -------new code---------
  final PageController _pageController = PageController();
  List<LockerStation> _lockerStations = [];
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get current location state
    final locationState = context.read<LocationBloc>().state;

    // If we already have a position, use it immediately to load locker stations
    if (locationState.status == LocationStatus.updated &&
        locationState.position != null) {
      // Use existing position to load locker stations
      context.read<LockerStationBloc>().add(
        ForceLoadLockerStationEvent(locationState.position!),
      );
    }

    // Also start tracking for fresh position updates
    context.read<LocationBloc>().add(StartTrackingEvent());
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
      appBar: AppBar(title: Text("Explore")),
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
              } else if (state.status == LockerStationStatus.loading) {
                CircularProgressIndicator(
                  // valueColor: AlwaysStoppedAnimation<Color>(
                  //   Theme.of(context).colorScheme.onPrimary,
                  // ),
                );
              }
            },
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            // final screenSize = MediaQuery.of(context).size;
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            final cardHeight = screenHeight * 0.28;
            final buttonPadding = screenHeight * 0.01;
            final horizontalMargin = screenWidth * 0.01;
            return Stack(
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
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                  //----------------------------------------------
                ),

                //----------------new code-------pagebuilder--------------------
                Positioned(
                  bottom: buttonPadding,
                  left: horizontalMargin,
                  right: horizontalMargin,
                  child: Container(
                    height: cardHeight,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                      horizontal: screenWidth * 0.02,
                    ),
                    child: PageView.builder(
                      controller: _pageController,
                      pageSnapping: true,
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
                  bottom: cardHeight + buttonPadding,
                  right: horizontalMargin + 20,
                  child: FloatingActionButton(
                    heroTag: "locationButton",
                    mini: screenWidth < 600,
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
            );
          },
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

  void _updateLockerStations(List<LockerStation> stations) {
    //---------------new code----------------
    _lockerStations = stations;

    final stationMarkers =
        stations.asMap().entries.map((entry) {
          final index = entry.key;
          final station = entry.value;

          return Marker(
            markerId: MarkerId('station_${station.id}'),
            position: LatLng(
              station.location.coordinates[0],
              station.location.coordinates[1],
            ),
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

  void _centerOnMarker(LockerStation station) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            station.location.coordinates[0],
            station.location.coordinates[1],
          ),
          zoom: 15,
          bearing: 30,
          tilt: 90,
        ),
      ),
    );
  }

  //----------------------------------------
}

class _LockerStationCard extends StatelessWidget {
  final LockerStation station;
  final bool isSelected;

  const _LockerStationCard({required this.station, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: isSelected ? 4 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: _buildDetailsSection(context)),
            Expanded(flex: 2, child: _buildImageSection(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColors(
      theme,
      theme.brightness == Brightness.dark,
    );

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Station Name and Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      station.stationName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      station.status.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      station.address,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
        child:
            station.images.isNotEmpty
                ? Image.network(
                  station.images.first.url,
                  fit: BoxFit.cover,
                  loadingBuilder:
                      (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : _buildLoadingState(),
                  errorBuilder:
                      (context, error, stackTrace) => _buildPlaceholderImage(),
                )
                : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          // Rating
          Row(
            children: [
              Icon(Icons.star_rounded, size: 18, color: AppTheme.accentGold),
              const SizedBox(width: 4),
              Text(
                station.averageRating?.toStringAsFixed(1) ?? '0.0',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${station.ratingAndReviews.length})',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          // Details Button
          GestureDetector(
            child: Icon(
              Icons.arrow_circle_right,
              size: 35,
              color: colorScheme.primary,
            ),
            onTap: () => _navigateToDetailScreen(context, station),
          ),
          // Icon(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: colorScheme.primary,
          //     foregroundColor: colorScheme.onPrimary,
          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   onPressed: () => _navigateToDetailScreen(context, station),
          //   icon: Icon(Icons.arrow_circle_right,),
          // ),
        ],
      ),
    );
  }

  Color _getStatusColors(ThemeData theme, bool isDark) {
    switch (station.status.toUpperCase()) {
      case 'OPEN':
        return theme.colorScheme.secondary;
      case 'MAINTENANCE':
        return isDark ? Colors.amber : AppTheme.accentGold;
      case 'CLOSED':
        return theme.colorScheme.error;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLoadingState() {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.lock_clock_outlined, size: 32, color: Colors.white),
      ),
    );
  }

  void _navigateToDetailScreen(BuildContext context, LockerStation station) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LockerStationPage(lockerStation: station),
      ),
    );
  }
}

//-----------------new code--------------------

// class _LockerStationCard extends StatelessWidget {
//   final LockerStation station;
//   final bool isSelected;

//   const _LockerStationCard({required this.station, required this.isSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               station.stationName,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: isSelected ? Colors.blue : Colors.black,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               station.address,
//               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 8),

//             // Add more station details here
//             const SizedBox(height: 12),
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
//                 ),
//                 onPressed: () => _navigateToDetailScreen(context, station),
//                 child: const Text(
//                   'View Details',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateToDetailScreen(
//     BuildContext context,
//     LockerStation lockerstation,
//   ) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => LockerStationPage(lockerStation: lockerstation),
//       ),
//     );
//   }
// }
