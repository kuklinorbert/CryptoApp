import 'package:cryptoapp/core/network/network_info.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/events_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/data/repositories/auth_repository_impl.dart';
import 'package:cryptoapp/features/cryptoapp/data/repositories/events_repository_impl.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/auth_repository.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/events_repository.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/check_auth.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_events.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/logout.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/resend_code.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/send_code.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/verify_code.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/events/events_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //Bloc
  sl.registerLazySingleton(() => AuthBloc(
      sendCode: sl(),
      checkAuth: sl(),
      verifyCode: sl(),
      logout: sl(),
      resendCode: sl()));

  sl.registerLazySingleton(() => NavigationbarBloc());

  sl.registerLazySingleton(() => EventsBloc(getEvents: sl()));

  //Use cases
  sl.registerLazySingleton(() => SendCode(sl()));
  sl.registerLazySingleton(() => CheckAuth(sl()));
  sl.registerLazySingleton(() => VerifyCode(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => ResendCode(sl()));

  sl.registerLazySingleton(() => GetEvents(sl()));

  //Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(networkInfo: sl()));

  sl.registerLazySingleton<EventsRepository>(
      () => EventsRepositoryImpl(eventsDataSource: sl(), networkInfo: sl()));
  //Data sources
  sl.registerLazySingleton<EventsDataSource>(
      () => EventsDataSourceImpl(client: sl()));

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => DataConnectionChecker());
}
