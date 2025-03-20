import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlock_flutter/core/app/main_wrapper.dart';
import 'package:mlock_flutter/core/permission/bloc/permissions_bloc.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/core/utils/my_dialog.dart';
import 'package:mlock_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:mlock_flutter/features/auth/pages/login_page.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    logger.d('Splash Screen Page initState methode called----');
    _initializeAuthCheck();
  }

  void _initializeAuthCheck() async {
    // Use milliseconds instead of microseconds (300ms is better)
    await Future.delayed(const Duration(seconds: 1));

    // Check if widget is still mounted before accessing context
    if (!mounted) return;

    context.read<AuthBloc>().add(AuthCheckRequestedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen:
                (previous, current) =>
                    current.status == AuthStatus.authenticated ||
                    current.status == AuthStatus.unauthenticated ||
                    current.status == AuthStatus.error,
            listener: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                context.read<PermissionsBloc>().add(CheckPermissionsEvent());
              } else if (state.status == AuthStatus.unauthenticated) {
                _navigateToLogin(context);
              } else if (state.status == AuthStatus.error) {
                _showErrorSnackbar(context, state.error);
              }
            },
          ),
          BlocListener<PermissionsBloc, PermissionsState>(
            listener: (context, state) {
              if (state.status == PermissionStatusI.granted) {
                _navigateToMain(context);
              } else if (state.status == PermissionStatusI.denied) {
                MyDialog.showPermissionDialog(context);
              } else if (state.status == PermissionStatusI.deniedPermanently) {
                MyDialog.showPermanentDenialDialog(context);
              }
            },
          ),
        ],
        child: _buildSplashContent(),
      ),
    );
  }

  Widget _buildSplashContent() {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace with your app's logo
            const Icon(Icons.lock, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMain(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainWrapper(initialPage: 1,)),
      (route) => false,
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _showErrorSnackbar(BuildContext context, String? message) {
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

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Location Permission Needed'),
            content: Text(
              'This app needs location access to function properly',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  logger.d('called the request again');
                  Navigator.pop(context);
                  context.read<PermissionsBloc>().add(
                    RequestLocationPermissionEvent(),
                  );
                },
                child: Text('Request Again'),
              ),
            ],
          ),
    );
  }

  void _showPermanentDenialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'You permanently denied location access. '
              'Please enable it in app settings to continue.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Close dialog first
                  Navigator.pop(context);

                  // Open device settings
                  final bool opened = await openAppSettings();

                  // Optional: Check if settings were opened
                  if (!opened) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to open settings')),
                    );
                  }
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
    );
  }
}
