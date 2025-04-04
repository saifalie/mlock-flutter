import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mlock_flutter/core/app/main_wrapper.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/rating/bloc/rating_bloc.dart';

class RatingPage extends StatefulWidget {
  final String lockerStationId;
  const RatingPage({super.key, required this.lockerStationId});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double? _selectedRating;
  final _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<RatingBloc, RatingState>(
      listener: (context, state) {
        if (state.status == RatingStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainWrapper(initialPage: 1),
            ),
          );
        } else if (state.status == RatingStatus.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error.toString())));
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.onSecondary,
        // appBar: AppBar(
        //   title: const Text('Rate Station'),
        //   centerTitle: true,
        //   elevation: 0,
        // ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              color: Colors.white.withAlpha(200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'How was your experience?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your feedback helps us improve our service',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder:
                          (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        logger.d('Rating updated: $rating');
                        setState(() {
                          _selectedRating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade50,
                      ),
                      child: TextField(
                        controller: _reviewController,
                        decoration: const InputDecoration(
                          labelText: 'Share your thoughts (optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          contentPadding: EdgeInsets.all(16),
                        ),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<RatingBloc, RatingState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              onPressed:
                                  state.status == RatingStatus.loading
                                      ? null
                                      : () => context.read<RatingBloc>().add(
                                        SkipRatingEvent(),
                                      ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Skip'),
                            ),
                            ElevatedButton(
                              onPressed:
                                  (state.status == RatingStatus.loading ||
                                          _selectedRating == null)
                                      ? null
                                      : _submitRating,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child:
                                  state.status == RatingStatus.loading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : const Text('Submit'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitRating() {
    logger.d('Submitting rating: $_selectedRating');
    context.read<RatingBloc>().add(
      SubmitRatingEvent(
        rating: _selectedRating!,
        message: _reviewController.text,
        lockerStationId: widget.lockerStationId,
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
