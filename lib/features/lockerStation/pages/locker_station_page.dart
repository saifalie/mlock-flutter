import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlock_flutter/core/app/main_wrapper.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/core/utils/my_snackbar.dart';
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
      appBar: AppBar(title: Text(widget.lockerStation.stationName)),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(detailedStation.images),
            const SizedBox(height: 16),

            Text(
              'Status: ${detailedStation.status}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              'Address: ${detailedStation.address}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Show locker information
            const Text(
              'Available Lockers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Display locker information
            _buildLockersList(detailedStation.lockers),
            const SizedBox(height: 16),

            // Opening hours
            const Text(
              'Opening Hours:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildOpeningHours(detailedStation.openingHours),
            const SizedBox(height: 16),

            // Show book button
            ElevatedButton(
              onPressed: () {
                _bottomSheetContainer(context, detailedStation);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Book a Locker'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockersList(List<Locker> lockers) {
    if (lockers.isEmpty) {
      return const Text('No lockers available');
    }

    // Group lockers by size
    final Map<String, List<Locker>> lockersBySize = {};
    for (var locker in lockers) {
      if (!lockersBySize.containsKey(locker.size)) {
        lockersBySize[locker.size] = [];
      }
      lockersBySize[locker.size]!.add(locker);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          lockersBySize.entries.map((entry) {
            final size = entry.key;
            final sizeLockers = entry.value;
            final availableCount =
                sizeLockers.where((l) => l.status == "AVAILABLE").length;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$size - ${availableCount}/${sizeLockers.length} Available',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Price: \$${sizeLockers.first.rentalPrice.toStringAsFixed(2)} per hour',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildOpeningHours(List<OpeningHours> hours) {
    if (hours.isEmpty) {
      return const Text('Opening hours not available');
    }

    return Column(
      children:
          hours.map((hour) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hour.day,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    hour.isClosed
                        ? 'Closed'
                        : '${hour.opensAt} - ${hour.closesAt}',
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
    // Locker? selectedLocker;
    bool bottomSheetClosedForPayment = false;

    // Available duration options
    final List<String> durationOptions = [
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
      if (locker.status != "AVAILABLE") continue;

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
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
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

              // Then after a delay, show the success dialog and navigate
              Future.delayed(const Duration(seconds: 3), () {
                // First close the bottom sheet
                // if (Navigator.canPop(context)) {
                //   Navigator.pop(context);
                // }

                // Wait a bit for the bottom sheet to close
                Future.delayed(const Duration(milliseconds: 300), () {
                  // Then show the success dialog
                  // MyDialog.showSuccessfullPaymentDialog(context, state);

                  // Reset the booking state
                  context.read<BookingBloc>().add(CompleteBookingEvent());

                  // Show success snackbar

                  MySnackbar.showSuccessSnackbar(context, 'Booking Confirmed');

                  // Optionally navigate to a tracking page
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
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Processing payment....'),
                    ],
                  ),
                ),
              );
            } else if (state.status == BookingStatus.paymentPending) {
              return Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Payment pending....'),
                    ],
                  ),
                ),
              );
            } else if (state.status == BookingStatus.bookingConfirmed) {
              return Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [SizedBox(height: 16), Text('Booking Confirmed')],
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
                  padding: const EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Book a Locker',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      Text(
                        station.stationName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Locker size sections
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                lockersBySize.entries.map((entry) {
                                  final size = entry.key;
                                  final sizeLockers = entry.value;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Text(
                                          '$size Size - ${sizeLockers.length} Available',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Price: ₹${sizeLockers.first.rentalPrice.toStringAsFixed(2)} per min',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // List of lockers for this size
                                      ...sizeLockers.map(
                                        (locker) => Card(
                                          margin: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          color:
                                              selectedLockerID == locker.id
                                                  ? Colors.blue.withOpacity(1)
                                                  : null,
                                          child: ListTile(
                                            title: Text(
                                              'Locker #${locker.lockerNumber}',
                                              style: TextStyle(
                                                color:
                                                    selectedLockerID ==
                                                            locker.id
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                            ),
                                            subtitle: Text(
                                              '${locker.size} - ₹${locker.rentalPrice.toStringAsFixed(2)}/min',
                                              style: TextStyle(
                                                color:
                                                    selectedLockerID ==
                                                            locker.id
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                            ),
                                            trailing: Radio<String>(
                                              value: locker.id,
                                              groupValue: selectedLockerID,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedLockerID = value;
                                                  selectedPrice =
                                                      calculatePrice();
                                                });
                                              },
                                            ),
                                            onTap: () {
                                              setState(() {
                                                selectedLockerID = locker.id;
                                                selectedPrice =
                                                    calculatePrice();
                                              });
                                            },
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 16),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),

                      // Duration selection
                      const Text(
                        'Select Duration:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedDuration,
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

                      const SizedBox(height: 16),

                      // Total price
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Price:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${selectedPrice}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Book button
                      ElevatedButton(
                        onPressed:
                            selectedLockerID == null
                                ? null
                                : () {
                                  bottomSheetClosedForPayment = true;
                                  // Navigator.pop(context);

                                  //get user info from user bloc if available
                                  // final userState =
                                  //     context.read<UserBloc>().state;
                                  //     final userName = userState is U
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
                                      lockerStationId: widget.lockerStation.id,
                                      duration: selectedDuration,
                                      amount: selectedPrice,
                                      rentalPrice: 0.3,
                                      userEmail: userEmail,
                                      userName: userName,
                                      userPhone: userPhone,
                                    ),
                                  );
                                },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Proceed to Payment'),
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


  Widget _buildImageCarousel(List<LockerImage> images) {
    if (images.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Text('No images available')),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() => _currentImageIndex = index);
            },
          ),
          items:
              images.map((LockerImage image) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: image.url,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Center(
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              Text('Failed to load image'),
                            ],
                          ),
                        ),
                    memCacheHeight: 400,
                    memCacheWidth: 600,
                    maxHeightDiskCache: 400,
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              images.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentImageIndex == entry.key
                            ? Theme.of(context).primaryColor
                            : Colors.grey.withOpacity(0.4),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
