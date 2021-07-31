import 'package:cryptoapp/core/network/network_info.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/events_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/favourites_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/items_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/data/repositories/auth_repository_impl.dart';
import 'package:cryptoapp/features/cryptoapp/data/repositories/events_repository_impl.dart';
import 'package:cryptoapp/features/cryptoapp/data/repositories/favourites_repository_impl.dart';
import 'package:cryptoapp/features/cryptoapp/data/repositories/items_repository_impl.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/auth_repository.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/events_repository.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/favourites_repository.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/items_repository.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/add_favourite.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/check_auth.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/check_favourite.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_events.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_favourites.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_search_result.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/logout.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/remove_favourite.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/resend_code.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/send_code.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/verify_code.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/events/events_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/cryptoapp/domain/usecases/refresh_items.dart';

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

  sl.registerLazySingleton(() =>
      ItemsBloc(getItems: sl(), getSearchResult: sl(), refreshItems: sl()));

  sl.registerLazySingleton(() => FavouritesBloc(
      addFavourite: sl(),
      getFavourites: sl(),
      checkFavourite: sl(),
      removeFavourite: sl()));

  //Use cases
  sl.registerLazySingleton(() => SendCode(sl()));
  sl.registerLazySingleton(() => CheckAuth(sl()));
  sl.registerLazySingleton(() => VerifyCode(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => ResendCode(sl()));
  sl.registerLazySingleton(() => GetEvents(sl()));
  sl.registerLazySingleton(() => GetItems(sl()));
  sl.registerLazySingleton(() => GetSearchResult(sl()));
  sl.registerLazySingleton(() => RefreshItems(sl()));
  sl.registerLazySingleton(() => AddFavourite(sl()));
  sl.registerLazySingleton(() => GetFavourites(sl()));
  sl.registerLazySingleton(() => CheckFavourite(sl()));
  sl.registerLazySingleton(() => RemoveFavourite(sl()));

  //Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(networkInfo: sl()));

  sl.registerLazySingleton<EventsRepository>(
      () => EventsRepositoryImpl(eventsDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<ItemsRepository>(
      () => ItemsRepositoryImpl(networkInfo: sl(), itemsDataSource: sl()));

  sl.registerLazySingleton<FavouritesRepository>(
      () => FavouritesRepositoryImpl(favouritesDataSource: sl()));

  //Data sources
  sl.registerLazySingleton<EventsDataSource>(
      () => EventsDataSourceImpl(client: sl()));

  sl.registerLazySingleton<ItemsDataSource>(
      () => ItemsDataSourceImpl(client: sl()));

  sl.registerLazySingleton<FavouritesDataSource>(
      () => FavouritesDataSourceImpl(client: sl()));

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => DataConnectionChecker());
}
