import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mlock_flutter/core/constants/navigation.constants.dart';
import 'package:mlock_flutter/core/permission/bloc/permissions_bloc.dart';
import 'package:mlock_flutter/core/theme/app_theme.dart';
import 'package:mlock_flutter/data/location/bloc/location_bloc.dart';
import 'package:mlock_flutter/data/user/bloc/user_bloc.dart';
import 'package:mlock_flutter/data/user/repository/user_repository.dart';
import 'package:mlock_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:mlock_flutter/features/auth/pages/splash_screen.dart';
import 'package:mlock_flutter/features/auth/repositories/auth_repository.dart';
import 'package:mlock_flutter/features/booking/bloc/booking_bloc.dart';
import 'package:mlock_flutter/features/booking/repositories/booking_api_service.dart';
import 'package:mlock_flutter/features/booking/repositories/booking_repository.dart';
import 'package:mlock_flutter/features/bookingTracking/bloc/booking_tracking_bloc.dart';
import 'package:mlock_flutter/features/bookingTracking/repositories/booking_tracking_api.dart';
import 'package:mlock_flutter/features/bookingTracking/repositories/booking_tracking_repository.dart';
import 'package:mlock_flutter/features/lockerStation/bloc/station_detail_bloc.dart';
import 'package:mlock_flutter/features/lockerStation/repository/station_detail_api.dart';
import 'package:mlock_flutter/features/lockerStation/repository/station_detail_repo.dart';
import 'package:mlock_flutter/features/map/bloc/locker_station_bloc.dart';
import 'package:mlock_flutter/features/map/repository/map_api_service.dart';
import 'package:mlock_flutter/features/map/repository/map_repository.dart';
import 'package:mlock_flutter/features/rating/bloc/rating_bloc.dart';
import 'package:mlock_flutter/features/rating/repositories/ratingandreview_api.dart';
import 'package:mlock_flutter/features/rating/repositories/ratingandreview_repo.dart';
import 'package:mlock_flutter/features/saved/bloc/saved_page_bloc.dart';
import 'package:mlock_flutter/features/saved/repositories/saved_page_api.dart';
import 'package:mlock_flutter/features/saved/repositories/saved_page_repo.dart';

import 'package:mlock_flutter/firebase_options.dart';
import 'package:mlock_flutter/services/api/api_initialization.dart';
import 'package:mlock_flutter/services/api/auth_api_services.dart';
import 'package:mlock_flutter/services/cache/cache_service.dart';
import 'package:mlock_flutter/services/cache/user_cache_service.dart';
import 'package:mlock_flutter/services/notifications/firebase_notification.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize dotenv
  await dotenv.load(fileName: '.env');

  //Intialize Firebase  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  final firebaseNotification = FirebaseNotification();

  //notification initialize
  await firebaseNotification.initNotifications();

  // 1. Initialize core dependencies
  final apiClient = ApiClient();
  final cacheService = CacheService();

  // 2. Initialize API Services
  final authApiServices = AuthApiServices(apiClient);
  final mapApiService = MapApiService(apiClient);
  final stationDetailApi = StationDetailApi(apiClient);
  final bookingApiService = BookingApiService(apiClient);
  final bookingTrackingApi = BookingTrackingApi(apiClient);
  final ratingAndReviewApi = RatingandreviewApi(apiClient);
  final savedPageApi = SavedPageApi(apiClient);

  // 3. Initialize Cache Services
  final userCacheService = UserCacheService(cacheService);

  // Initialize repositories
  final authRepository = AuthRepository(authApiServices: authApiServices);
  final userRepository = UserRepository(
    authApiServices: authApiServices,
    userCacheService: userCacheService,
  );
  final mapRepository = MapRepository(mapApiService: mapApiService);
  final stationDetailRepo = StationDetailRepo(
    stationDetailApi: stationDetailApi,
  );
  final bookingRepository = BookingRepository(
    bookingApiService: bookingApiService,
    razorpayKeyId: dotenv.env['RAZORPAY_KEY_ID']!,
  );
  final bookingTrackingRepository = BookingTrackingRepository(
    bookingTrackingApi,
  );
  final ratingandreviewRepo = RatingandreviewRepo(ratingAndReviewApi);

  final savedPageRepo = SavedPageRepo(savedPageApi);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: userRepository),
        RepositoryProvider.value(value: mapRepository),
        RepositoryProvider.value(value: stationDetailRepo),
        RepositoryProvider.value(value: bookingRepository),
        RepositoryProvider.value(value: bookingTrackingRepository),
        RepositoryProvider.value(value: ratingandreviewRepo),
        RepositoryProvider.value(value: firebaseNotification),
        RepositoryProvider.value(value: savedPageRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => AuthBloc(
                  authRepository: context.read<AuthRepository>(),
                  firebaseAuth: firebaseAuth,
                  googleSignIn: googleSignIn,
                  firebaseNotification: context.read<FirebaseNotification>(),
                ),
          ),
          BlocProvider(create: (context) => PermissionsBloc()),
          BlocProvider(
            create:
                (context) =>
                    UserBloc(userRepository: context.read<UserRepository>()),
          ),
          BlocProvider(create: (context) => LocationBloc()),
          BlocProvider(
            create:
                (context) => LockerStationBloc(
                  mapRepository: context.read<MapRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => StationDetailBloc(
                  stationDetailRepo: context.read<StationDetailRepo>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => BookingBloc(
                  bookingRepository: context.read<BookingRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => BookingTrackingBloc(
                  bookingTrackingRepository:
                      context.read<BookingTrackingRepository>(),
                  bookingRepository: context.read<BookingRepository>(),
                  razorpayKeyId: dotenv.env['RAZORPAY_KEY_ID']!,
                ),
          ),
          BlocProvider(
            create:
                (context) =>
                    RatingBloc(ratingandreviewRepo: ratingandreviewRepo),
          ),
          BlocProvider(
            create:
                (context) => SavedPageBloc(
                  savedPageRepo: savedPageRepo,
                  stationDetailRepo: context.read<StationDetailRepo>(),
                ),
          ),
        ],
        child: MyApp(firebaseNotification: firebaseNotification),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FirebaseNotification firebaseNotification;
  const MyApp({super.key, required this.firebaseNotification});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: SplashScreen(),
    );
  }
}
