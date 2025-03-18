import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlock_flutter/features/auth/bloc/auth_bloc.dart';

class MySnackbar {
  static void showErrorSnackbar(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Authentication error occurred'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed:
              () => context.read<AuthBloc>().add(AuthCheckRequestedEvent()),
        ),
      ),
    );
  }

  static void showSuccessSnackbar(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Success'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Ok',
          onPressed: Navigator.of(context).pop,
        ),
      ),
    );
  }
}
