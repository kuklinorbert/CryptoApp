import 'package:cryptoapp/features/cryptoapp/data/repositories/auth_repository_impl.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/auth_repository.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/check_auth.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/logout.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/resend_code.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/send_code.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/verify_code.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Bloc
  sl.registerLazySingleton(() => AuthBloc(
      sendCode: sl(),
      checkAuth: sl(),
      verifyCode: sl(),
      logout: sl(),
      resendCode: sl()));

  //Use cases
  sl.registerLazySingleton(() => SendCode(sl()));
  sl.registerLazySingleton(() => CheckAuth(sl()));
  sl.registerLazySingleton(() => VerifyCode(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => ResendCode(sl()));
  //Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  //Data sources

  //Core

  //External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
