import 'package:get_it/get_it.dart';
import 'package:hba_management/core/app/state/app_state.dart';
import 'package:hba_management/layers/bloc/admin/admin_cubit.dart';
import 'package:hba_management/layers/bloc/auth/auth_cubit.dart';
import 'package:hba_management/layers/bloc/hotel/hotel_cubit.dart';
import 'package:hba_management/layers/bloc/room/room_cubit.dart';
import 'package:hba_management/layers/data/data_provider/auth_provider.dart';
import 'package:hba_management/layers/data/data_provider/room_provider.dart';
import 'package:hba_management/layers/data/data_provider/user_provider.dart';
import 'package:hba_management/layers/data/repository/admin_repository.dart';
import 'package:hba_management/layers/data/repository/auth_repository.dart';
import 'package:hba_management/layers/data/repository/room_repository.dart';
import 'layers/data/data_provider/hotel_provider.dart';
import 'layers/data/data_provider/profile_provider.dart';
import 'layers/data/repository/hotel_repository.dart';
import 'layers/data/repository/profile_repository.dart';

final sl = GetIt.instance;

void initInjection() {
  //cubit
  sl.registerLazySingleton(() => HotelCubit());
  sl.registerLazySingleton(() => AuthCubit());
  sl.registerLazySingleton(() => AdminCubit());
  sl.registerLazySingleton(() => AppState());
  sl.registerLazySingleton(() => RoomCubit());

  //repos
  sl.registerLazySingleton(() => HotelRepository(sl()));
  sl.registerLazySingleton(() => AuthRepository(sl()));
  sl.registerLazySingleton(() => AdminRepository(sl()));
  sl.registerLazySingleton(() => ProfileRepository(sl()));
  sl.registerLazySingleton(() => RoomRepository(sl()));

  //data_provider
  sl.registerLazySingleton(() => HotelProvider());
  sl.registerLazySingleton(() => AuthProvider());
  sl.registerLazySingleton(() => AdminProvider());
  sl.registerLazySingleton(() => ProfileProvider());
  sl.registerLazySingleton(() => RoomProvider());
}
