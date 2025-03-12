import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mlock_flutter/core/permission/bloc/permissions_bloc.dart';
import 'package:mlock_flutter/data/location/bloc/location_bloc.dart';
import 'package:mlock_flutter/data/user/bloc/user_bloc.dart';
import 'package:mlock_flutter/data/user/repository/user_repository.dart';
import 'package:mlock_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:mlock_flutter/features/auth/pages/splash_screen.dart';
import 'package:mlock_flutter/features/auth/repositories/auth_repository.dart';
import 'package:mlock_flutter/features/map/bloc/locker_station_bloc.dart';
import 'package:mlock_flutter/firebase_options.dart';
import 'package:mlock_flutter/services/api/api_initialization.dart';
import 'package:mlock_flutter/services/api/auth_api_services.dart';
import 'package:mlock_flutter/services/cache/cache_service.dart';
import 'package:mlock_flutter/services/cache/user_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Intialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  // 1. Initialize core dependencies
  final apiClient = ApiClient();
  final cacheService = CacheService();

  // 2. Initialize API Services
  final authApiServices = AuthApiServices(apiClient);

  // 3. Initialize Cache Services
  final userCacheService = UserCacheService(cacheService);

  // Initialize repositories
  final authRepository = AuthRepository(authApiServices: authApiServices);
  final userRepository = UserRepository(
    authApiServices: authApiServices,
    userCacheService: userCacheService,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: userRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => AuthBloc(
                  authRepository: context.read<AuthRepository>(),
                  firebaseAuth: firebaseAuth,
                  googleSignIn: googleSignIn,
                ),
          ),
          BlocProvider(create: (context) => PermissionsBloc()),
          BlocProvider(
            create:
                (context) =>
                    UserBloc(userRepository: context.read<UserRepository>()),
          ),
          BlocProvider(create: (context) => LocationBloc()),
          BlocProvider(create: (context) => LockerStationBloc()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(254, 206, 1, 1),
          primary: const Color.fromRGBO(254, 206, 1, 1),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
