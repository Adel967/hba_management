import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hba_management/core/shared_preferences/shared_preferences_instance.dart';
import 'package:hba_management/core/shared_preferences/shared_preferences_key.dart';
import 'package:meta/meta.dart';
import '../../../injection_container.dart';
import '../../data/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  AuthRepository _authRepository = sl<AuthRepository>();

  login(String email, password) async {
    emit(AuthLoading());
    final res = await _authRepository.logIn(email, password);
    res.fold((l) => emit(AuthError(error: l.message!)), (r) async {
      await SharedPreferencesInstance.pref
          .setInt(SharedPreferencesKeys.UserRole, r.docs.first["role"]);
      emit(AuthLoaded());
    });
  }
}
