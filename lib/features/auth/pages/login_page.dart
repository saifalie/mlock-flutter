import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlock_flutter/core/app/main_wrapper.dart';
import 'package:mlock_flutter/features/auth/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoginPage')),
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to MLOCK',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed:
                        state.status == AuthStatus.loading
                            ? null
                            : () {
                              context.read<AuthBloc>().add(
                                GoogleSignInRequestedEvent(),
                              );
                            },
                    label: Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => MainWrapper()),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}
