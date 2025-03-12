import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlock_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:mlock_flutter/features/auth/pages/login_page.dart';
import 'package:mlock_flutter/features/booking/pages/booking_tracking_page.dart';
import 'package:mlock_flutter/features/map/pages/map_page.dart';
import 'package:mlock_flutter/features/profile/pages/profile_page.dart';
import 'package:mlock_flutter/features/saved/pages/saved_page.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int currentPage = 0;

  List<Widget> pages = const [
    BookingTrackingPage(),
    MapPage(),
    SavedPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) =>
              current.status == AuthStatus.unauthenticated &&
              previous.status != AuthStatus.unauthenticated,
      listener: (context, state) {
        // When user becomes unauthenticated, navigate to login page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      },
      child: Scaffold(
        // body: LoginPage(),
        body: IndexedStack(index: currentPage, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          selectedFontSize: 0,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          unselectedFontSize: 0,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          currentIndex: currentPage,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.location_city), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              label: '',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.face), label: ''),
          ],
        ),
      ),
    );
  }
}
