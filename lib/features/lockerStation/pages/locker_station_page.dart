import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mlock_flutter/core/app/main_wrapper.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/booking/bloc/booking_bloc.dart';
import 'package:mlock_flutter/features/lockerStation/bloc/station_detail_bloc.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';

class LockerStationPage extends StatefulWidget {
  final LockerStation lockerStation; // Basic station data from map
  const LockerStationPage({super.key, required this.lockerStation});

  @override
  State<LockerStationPage> createState() => _LockerStationPageState();
}

class _LockerStationPageState extends State<LockerStationPage> {
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Request full station details
    context.read<StationDetailBloc>().add(
      LoadStationDetailEvent(widget.lockerStation.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(widget.lockerStation.stationName)),
      body: BlocBuilder<StationDetailBloc, StationDetailState>(
        builder: (context, state) {
          switch (state.status) {
            case StationDetailStatus.initial:
            case StationDetailStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case StationDetailStatus.loaded:
              // Use the detailed station data once loaded
              return _buildStationDetails(state.station!);

            case StationDetailStatus.error:
              return Center(
                child: Text('Error: ${state.error ?? "Unknown error"}'),
              );
          }
        },
      ),
    );
  }

  Widget _buildStationDetails(LockerStation detailedStation) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Custom app bar with image carousel
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Carousel slider
                    _buildImageCarousel(detailedStation.images),

                    // Gradient overlay for better text visibility
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(153),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Station name at bottom
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              detailedStation.stationName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Favorite/Save button
                          BlocBuilder<StationDetailBloc, StationDetailState>(
                            builder: (context, state) {
                              if (state.status != StationDetailStatus.loaded) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(51),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  color:
                                      state.isSaved
                                          ? Theme.of(context).colorScheme.error
                                          : Colors.white,
                                  onPressed: () {
                                    context.read<StationDetailBloc>().add(
                                      ToggleSaveStationEvent(
                                        widget.lockerStation.id,
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    state.isSaved
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 28,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status and Rating
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              detailedStation.status,
                            ).withAlpha(26),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _getStatusColor(detailedStation.status),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStatusIcon(detailedStation.status),
                                size: 16,
                                color: _getStatusColor(detailedStation.status),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                detailedStation.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(
                                    detailedStation.status,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (detailedStation.averageRating != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                detailedStation.averageRating!.toStringAsFixed(
                                  1,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Address with icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            detailedStation.address,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Opening Hours Section with Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Opening Hours',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildOpeningHours(detailedStation.openingHours),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Reviews Section
                    const Text(
                      'Reviews & Ratings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildReviewsSection(detailedStation),

                    const SizedBox(height: 24),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),

        Positioned(
          bottom: 30,
          left: 16,
          right: 16,
          child:
          // Book button
          ElevatedButton(
            onPressed: () {
              final hasActiveBooking =
                  context.read<StationDetailBloc>().state.hasActiveBooking;
              logger.d('hasActiveBooking: $hasActiveBooking');

              if (hasActiveBooking) {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text('Active Booking Found'),
                        content: Text(
                          'You already have an active booking. You can only have one booking at a time.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                );
              } else {
                _bottomSheetContainer(context, detailedStation);
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Book a Locker',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // Get color based on status
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
      case 'AVAILABLE':
        return Colors.green;
      case 'CLOSED':
        return Colors.red;
      case 'MAINTENANCE':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  // Get icon based on status
  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
      case 'AVAILABLE':
        return Icons.check_circle_outline;
      case 'CLOSED':
        return Icons.cancel_outlined;
      case 'MAINTENANCE':
        return Icons.build_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildOpeningHours(List<OpeningHours> hours) {
    if (hours.isEmpty) {
      return const Text(
        'Opening hours not available',
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      );
    }

    return Column(
      children:
          hours.map((hour) {
            final isToday = _isToday(hour.day);

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withAlpha(51),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (isToday)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        hour.day,
                        style: TextStyle(
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                          color:
                              isToday
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    hour.isClosed
                        ? 'Closed'
                        : '${hour.opensAt} - ${hour.closesAt}',
                    style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color:
                          hour.isClosed
                              ? Colors.red
                              : (isToday
                                  ? Theme.of(context).colorScheme.primary
                                  : null),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  bool _isToday(String day) {
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final today = DateTime.now().weekday - 1; // 0-6 index
    return daysOfWeek[today].startsWith(day) ||
        day.startsWith(daysOfWeek[today]);
  }

  Widget _buildReviewsSection(LockerStation station) {
    if (station.ratingAndReviews.isEmpty) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.rate_review_outlined,
                size: 40,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              const Text(
                'No reviews yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                'Be the first to leave a review!',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // Only show visible reviews
    final visibleReviews =
        station.ratingAndReviews.where((review) => review.isVisible).toList();

    return Column(
      children: [
        // Summary rating
        if (station.averageRating != null)
          Row(
            children: [
              RatingBar.builder(
                initialRating: station.averageRating!,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 24,
                ignoreGestures: true,
                itemBuilder:
                    (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (_) {}, // Not interactive
              ),
              const SizedBox(width: 8),
              Text(
                '(${visibleReviews.length})',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ],
          ),

        const SizedBox(height: 16),

        // Review cards
        ...visibleReviews.map((review) => _buildReviewCard(review)),
        // ...visibleReviews.take(3).map((review) => _buildReviewCard(review)),

        // Show more button if there are more than 3 reviews
        // if (visibleReviews.length > 3)
        //   TextButton(
        //     onPressed: () {
        //       // Implement "View all reviews" functionality
        //     },
        //     child: Text(
        //       'View all ${visibleReviews.length} reviews',
        //       style: TextStyle(
        //         color: Theme.of(context).colorScheme.primary,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildReviewCard(RatingAndReview review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Circle avatar with initial
                CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(26),
                  child: Text(
                    'U', // First letter of User
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RatingBar.builder(
                  initialRating: review.rating.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 16,
                  ignoreGestures: true,
                  itemBuilder:
                      (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (_) {}, // Not interactive
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (review.message != null && review.message!.isNotEmpty)
              Text(review.message!, style: const TextStyle(fontSize: 14))
            else
              Text(
                'No comment provided',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<LockerImage> images) {
    if (images.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        autoPlay: true,
        enlargeCenterPage: false,
        viewportFraction: 1.0,
        autoPlayInterval: const Duration(seconds: 5),
        onPageChanged: (index, reason) {
          setState(() => _currentImageIndex = index);
        },
      ),
      items:
          images.map((LockerImage image) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(),
              child: Stack(
                children: [
                  // Image
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: image.url,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 32),
                                SizedBox(height: 8),
                                Text('Failed to load image'),
                              ],
                            ),
                          ),
                      memCacheHeight: 600,
                      memCacheWidth: 900,
                      maxHeightDiskCache: 600,
                    ),
                  ),

                  // Indicators
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          images.asMap().entries.map((entry) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    _currentImageIndex == entry.key
                                        ? Colors.white
                                        : Colors.white.withAlpha(102),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  void _bottomSheetContainer(BuildContext context, LockerStation station) {
    // Default selected values
    String? selectedLockerID;
    String selectedDuration = '1 hr'; // Default duration
    int selectedPrice = 0;
    bool bottomSheetClosedForPayment = false;

    // Available duration options
    final List<String> durationOptions = [
      '1 min',
      '30 min',
      '1 hr',
      '1:30 hr',
      '2 hr',
      '2:30 hr',
      '3 hr',
    ];

    // Group lockers by size
    final Map<String, List<Locker>> lockersBySize = {};
    for (var locker in station.lockers) {
      if (!lockersBySize.containsKey(locker.size)) {
        lockersBySize[locker.size] = [];
      }
      lockersBySize[locker.size]!.add(locker);
    }

    showModalBottomSheet(
      elevation: 10,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (context) {
        return BlocConsumer<BookingBloc, BookingState>(
          listenWhen: (previous, current) {
            logger.d(
              'State changed from ${previous.status} to ${current.status}',
            );
            return true; // Listen to all state changes
          },
          listener: (context, state) {
            logger.d('Listener called with state status: ${state.status}');
            if (state.status == BookingStatus.bookingConfirmed) {
              logger.d('Booking confirmed handler triggered');

              // Display the success UI in the bottom sheet first
              Future.delayed(const Duration(seconds: 3), () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  context.read<BookingBloc>().add(CompleteBookingEvent());
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => MainWrapper(initialPage: 0),
                    ),
                    (route) => false,
                  );
                });
              });
            } else if (state.status == BookingStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );

              Future.delayed(const Duration(seconds: 2), () {
                context.read<BookingBloc>().add(CompleteBookingEvent());
              });
            }
          },
          builder: (context, state) {
            // Check if we need to show loading states
            if (state.status == BookingStatus.paymentProcessing) {
              return Container(
                height: 300,
                padding: const EdgeInsets.all(24),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        'Processing payment...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state.status == BookingStatus.paymentPending) {
              return Container(
                height: 300,
                padding: const EdgeInsets.all(24),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        'Payment pending...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state.status == BookingStatus.bookingConfirmed) {
              return Container(
                height: 300,
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 64,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Booking Confirmed!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return StatefulBuilder(
              builder: (context, setState) {
                // Calculate price based on selected duration and locker
                int calculatePrice() {
                  if (selectedLockerID == null) return 0;

                  // Find the selected locker
                  final selectedLocker = station.lockers.firstWhere(
                    (locker) => locker.id == selectedLockerID,
                    orElse: () => station.lockers.first,
                  );

                  // Parse duration to get hours
                  double hours = 0.0;
                  if (selectedDuration == '30 min') {
                    hours = 0.5;
                  } else if (selectedDuration == '1 min') {
                    hours = 1 / 60; // 1 minute as fraction of hour
                  } else {
                    final durationParts = selectedDuration.split(' ');
                    if (durationParts[0].contains(':')) {
                      final hourMinParts = durationParts[0].split(':');
                      hours =
                          double.parse(hourMinParts[0]) +
                          (double.parse(hourMinParts[1]) / 60);
                    } else {
                      hours = double.parse(durationParts[0]);
                    }
                  }

                  return (selectedLocker.rentalPrice * hours * 60).round();
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Book a Locker',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                station.stationName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.withAlpha(26),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Duration selection
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(13),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Duration',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(13),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedDuration,
                                  elevation: 0,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedDuration = newValue!;
                                      selectedPrice = calculatePrice();
                                    });
                                  },
                                  items:
                                      durationOptions.map((duration) {
                                        return DropdownMenuItem(
                                          value: duration,
                                          child: Text(duration),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Locker selector
                      const Text(
                        'Select a Locker',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                lockersBySize.entries.map((entry) {
                                  final size = entry.key;
                                  final sizeLockers = entry.value;
                                  final availableLockers =
                                      sizeLockers
                                          .where(
                                            (locker) =>
                                                locker.status == "AVAILABLE",
                                          )
                                          .toList();

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 20.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Size header with price
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary.withAlpha(26),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                size == 'SMALL'
                                                    ? Icons.backpack
                                                    : (size == 'MEDIUM'
                                                        ? Icons.work
                                                        : Icons.luggage),
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                              ),
                                              const SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '$size Size',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                    ),
                                                  ),
                                                  if (availableLockers
                                                      .isNotEmpty)
                                                    Text(
                                                      '₹${availableLockers.first.rentalPrice.toStringAsFixed(2)}/min',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        // Available lockers count
                                        Text(
                                          '${availableLockers.length} Available',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        // Visual locker grid
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children:
                                              sizeLockers.map((locker) {
                                                final bool isAvailable =
                                                    locker.status ==
                                                    "AVAILABLE";
                                                final bool isSelected =
                                                    selectedLockerID ==
                                                    locker.id;

                                                return GestureDetector(
                                                  onTap:
                                                      isAvailable
                                                          ? () {
                                                            setState(() {
                                                              selectedLockerID =
                                                                  locker.id;
                                                              selectedPrice =
                                                                  calculatePrice();
                                                            });
                                                          }
                                                          : null,
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          isSelected
                                                              ? Theme.of(
                                                                    context,
                                                                  )
                                                                  .colorScheme
                                                                  .primary
                                                              : (isAvailable
                                                                  ? Colors.white
                                                                  : Colors.red
                                                                      .withAlpha(
                                                                        51,
                                                                      )),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            isSelected
                                                                ? Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary
                                                                : (isAvailable
                                                                    ? Colors
                                                                        .grey
                                                                        .shade300
                                                                    : Colors.red
                                                                        .withAlpha(
                                                                          77,
                                                                        )),
                                                        width:
                                                            isSelected ? 2 : 1,
                                                      ),
                                                      boxShadow:
                                                          isSelected ||
                                                                  !isAvailable
                                                              ? null
                                                              : [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withAlpha(
                                                                        13,
                                                                      ),
                                                                  blurRadius: 3,
                                                                  offset:
                                                                      const Offset(
                                                                        0,
                                                                        1,
                                                                      ),
                                                                ),
                                                              ],
                                                    ),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            isAvailable
                                                                ? Icons
                                                                    .lock_open
                                                                : Icons.lock,
                                                            size: 20,
                                                            color:
                                                                isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : (isAvailable
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .red
                                                                            .withAlpha(
                                                                              179,
                                                                            )),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            '#${locker.lockerNumber}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  isSelected
                                                                      ? Colors
                                                                          .white
                                                                      : (isAvailable
                                                                          ? Colors
                                                                              .black
                                                                          : Colors.red.withAlpha(
                                                                            179,
                                                                          )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),

                      // Bottom price and booking section
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Price container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(13),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Price:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    '₹${selectedPrice}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Book button
                            ElevatedButton(
                              onPressed:
                                  selectedLockerID == null ||
                                          context
                                              .read<StationDetailBloc>()
                                              .state
                                              .hasActiveBooking
                                      ? null
                                      : () {
                                        bottomSheetClosedForPayment = true;

                                        final userName = "John Doe";
                                        final userEmail = "john@example.com";
                                        final userPhone = "1234567890";
                                        logger.d('amount: $selectedPrice');
                                        logger.d(
                                          'selected duration $selectedDuration',
                                        );

                                        //Initiate booking
                                        context.read<BookingBloc>().add(
                                          InitiateBookingEvent(
                                            lockerId: selectedLockerID!,
                                            lockerStationId:
                                                widget.lockerStation.id,
                                            duration: selectedDuration,
                                            amount: selectedPrice,
                                            rentalPrice: 77,
                                            userEmail: userEmail,
                                            userName: userName,
                                            userPhone: userPhone,
                                          ),
                                        );
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                disabledBackgroundColor: Colors.grey.shade300,
                                disabledForegroundColor: Colors.grey.shade600,
                                minimumSize: const Size.fromHeight(54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Proceed to Payment',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ).then((_) {
      // When bottom sheet is closed, check if it was closed for payment
      if (bottomSheetClosedForPayment) {
        // check current state
        final currentState = context.read<BookingBloc>();

        // If payment is still pending/processing, reopen the bottom sheet
        if (currentState.state == BookingStatus.paymentPending ||
            currentState.state == BookingStatus.paymentProcessing) {
          // Reopen bottom sheet after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            _bottomSheetContainer(context, station);
          });
        }
      }
    });
  }
}
