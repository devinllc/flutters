
import 'package:assign/home.dart';
import 'package:assign/profile/data/datasources/profile_remote_datasource.dart';
import 'package:assign/profile/data/repositories/profile_repository_impl.dart';
import 'package:assign/profile/domain/repositories/profile_repository.dart';
import 'package:assign/user/data/datasources/user_remote_datasource.dart';
import 'package:assign/user/data/repositories/user_repository_impl.dart';
import 'package:assign/user/domain/repositories/user_repository.dart';
import 'package:assign/user/domain/usecases/create_user_usecase.dart';
import 'package:assign/user/domain/usecases/login_user_usecase.dart';
import 'package:assign/user/domain/usecases/resend_verification_email_usecase.dart';
import 'package:assign/profile/domain/usecases/get_profile_usecase.dart';
import 'package:assign/profile/presentation/provider/profile_provider.dart';
import 'package:assign/user/presentation/providers/%20user_provider.dart';

import 'package:assign/user/presentation/screens/signup_screen.dart';



import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance; // Service locator

void setup() {
  // Register Dio instance
  sl.registerLazySingleton<Dio>(() => Dio());

  // Register UserRemoteDataSource with injected Dio instance
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSource(sl()));

  // Register UserRepository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // Register UseCases for User
  sl.registerLazySingleton<LoginUserUseCase>(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton<CreateUserUseCase>(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton<ResendVerificationEmailUseCase>(
      () => ResendVerificationEmailUseCase(sl()));

  // Register Profile dependencies
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(ProfileRemoteDataSource(Dio())));

  sl.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(sl()));
  sl.registerFactory<ProfileProvider>(() => ProfileProvider(sl()));

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setup(); // Setup dependencies

  final prefs = await SharedPreferences.getInstance();
  final userData = prefs.getString('user_data');
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  final initialRoute =
      isLoggedIn && userData != null ? '/home' : '/signup'; // Conditional route

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            sl(),
            sl(),
            sl(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(sl()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WeMotions App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: initialRoute == '/home' ? HomePage() : SignupScreen(),
      ),
    );
  }
}
