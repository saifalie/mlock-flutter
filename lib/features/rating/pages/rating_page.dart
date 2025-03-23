import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mlock_flutter/core/app/main_wrapper.dart';
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
        appBar: AppBar(title: const Text('Rate Station')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder:
                    (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  print('Rating updated: $rating');
                  setState(() {
                    _selectedRating = rating;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  labelText: 'Review (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              BlocBuilder<RatingBloc, RatingState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed:
                            state.status == RatingStatus.loading
                                ? null
                                : () => context.read<RatingBloc>().add(
                                  SkipRatingEvent(),
                                ),
                        child: const Text('Skip'),
                      ),
                      ElevatedButton(
                        onPressed:
                            (state.status == RatingStatus.loading ||
                                    _selectedRating == null)
                                ? null
                                : _submitRating,
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
    );
  }

  void _submitRating() {
    print('Submitting rating: $_selectedRating');
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
