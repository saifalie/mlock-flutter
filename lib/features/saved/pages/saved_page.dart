import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlock_flutter/core/utils/my_snackbar.dart';
import 'package:mlock_flutter/features/lockerStation/pages/locker_station_page.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';
import 'package:mlock_flutter/features/saved/bloc/saved_page_bloc.dart';
import 'package:mlock_flutter/core/theme/app_theme.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  void initState() {
    super.initState();
    context.read<SavedPageBloc>().add(LoadSavedStationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppTheme.darkGreen.withAlpha(200),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/logo/mlock_logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Saved Stations',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: BlocConsumer<SavedPageBloc, SavedPageState>(
        listener: (context, state) {
          if (state.status == SavedPageStatus.error) {
            MySnackbar.showErrorSnackbar(context, state.error);
          }
        },
        builder: (context, state) {
          // Loading state
          if (state.status == SavedPageStatus.loading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircularProgressIndicator(
                      color: AppTheme.lightGreen,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Loading your stations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkGreen,
                    ),
                  ),
                ],
              ),
            );
          }

          // Error state
          if (state.status == SavedPageStatus.error) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Unable to Load Stations',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'We encountered a problem while loading your saved stations.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextButton.icon(
                      onPressed:
                          () => context.read<SavedPageBloc>().add(
                            LoadSavedStationEvent(),
                          ),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.lightGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty state - UPDATED to support refresh and removed browse button
          if (state.stations == null || state.stations!.isEmpty) {
            return RefreshIndicator(
              color: AppTheme.lightGreen,
              backgroundColor: Colors.white,
              onRefresh: () async {
                context.read<SavedPageBloc>().add(RefreshSavedStationEvent());
              },
              child: ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 150,
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.darkGreen.withAlpha(20),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.accentGold.withAlpha(179),
                                    AppTheme.accentGold.withAlpha(77),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.bookmark_border_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'No Saved Stations',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkGreen,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Save your favorite locker stations to access them quickly. Look for the heart icon when browsing stations.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  height: 1.6,
                                ),
                              ),
                            ),
                            // Browse Stations button removed as requested
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Loaded state with stations
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: RefreshIndicator(
              color: AppTheme.lightGreen,
              backgroundColor: Colors.white,
              onRefresh: () async {
                context.read<SavedPageBloc>().add(RefreshSavedStationEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 32),
                itemCount: state.stations!.length,
                itemBuilder: (context, index) {
                  final station = state.stations![index];
                  return _buildStationCard(station);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStationCard(LockerStation station) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkGreen.withAlpha(15),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LockerStationPage(lockerStation: station),
                ),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Station Image - Takes up full width for a premium look
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Stack(
                  children: [
                    // Image or placeholder
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient:
                            station.images.isEmpty
                                ? LinearGradient(
                                  colors: [
                                    AppTheme.darkGreen.withAlpha(179),
                                    AppTheme.darkGreen.withAlpha(100),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                      ),
                      child:
                          station.images.isNotEmpty
                              ? Hero(
                                tag: 'station_image_${station.id}',
                                child: Image.network(
                                  station.images.first.url,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Icon(
                                        Icons.image_not_supported_rounded,
                                        size: 50,
                                        color: Colors.white.withAlpha(200),
                                      ),
                                ),
                              )
                              : Center(
                                child: Icon(
                                  Icons.lock_rounded,
                                  size: 50,
                                  color: Colors.white.withAlpha(200),
                                ),
                              ),
                    ),

                    // Status badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(station.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _formatStatus(station.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    // Gradient overlay for text readability
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withAlpha(179),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),

                    // Station name overlay
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              station.stationName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Favorite button (now on the image)
                          Material(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () => _toggleSaveStation(station),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.red,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address with icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 18,
                          color: AppTheme.lightGreen,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            station.address,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Rating section
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppTheme.accentGold,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          station.averageRating?.toStringAsFixed(1) ?? 'N/A',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGreen,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'rating',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // View details button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => LockerStationPage(
                                      lockerStation: station,
                                    ),
                              ),
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.lightGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to format station status
  String _formatStatus(String status) {
    // Convert from backend format to user-friendly format
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'Open';
      case 'INACTIVE':
        return 'Closed';
      case 'MAINTENANCE':
        return 'Maintenance';
      default:
        return status;
    }
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    // Return appropriate color based on status
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'INACTIVE':
        return Colors.red;
      case 'MAINTENANCE':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  // UPDATED METHOD: Now updates the SavedPageBloc as well
  void _toggleSaveStation(LockerStation station) {
    // 1. Toggle save status on the server via StationDetailBloc

    // context.read<StationDetailBloc>().add(ToggleSaveStationEvent(station.id));
    context.read<SavedPageBloc>().add(ToggleSaveStationEvent(station.id));

    // 2. Immediately refresh the saved list from the server
    context.read<SavedPageBloc>().add(RefreshSavedStationEvent());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${station.stationName} removed from saved stations'),
        backgroundColor: AppTheme.darkGreen,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppTheme.accentGold,
          onPressed: () {
            context.read<SavedPageBloc>().add(
              ToggleSaveStationEvent(station.id),
            );
            context.read<SavedPageBloc>().add(LoadSavedStationEvent());
          },
        ),
      ),
    );
  }
}
