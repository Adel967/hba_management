import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hba_management/layers/data/model/user_model.dart';
import 'package:hba_management/layers/data/repository/admin_repository.dart';
import 'package:meta/meta.dart';
import '../../../core/firebase/constants.dart';
import '../../../injection_container.dart';
part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial());

  final _adminRepo = sl<AdminRepository>();

  getAdmins() async {
    emit(AdminLoading());
    try {
      final admins = await _adminRepo.getAdmins();
      emit(AdminLoaded(admins: admins));
    } catch (e) {
      emit(AdminError(error: "There is an error!"));
    }
  }

  addAdmin(UserModel user) async {
    emit(AdminUploading());
    try {
      try {
        await _adminRepo.addAdmin(user);
        emit(AdminUploaded());
      } on FirebaseAuthException catch (e) {
        emit(AdminUploadingError(
            error: FirebaseConstants.getMessageFromErrorCode(e.code)));
      }
    } catch (e) {
      emit(AdminUploadingError(error: "There is an error!"));
    }
  }

  updateAdmin(UserModel user, String? hotelId) async {
    emit(AdminUploading());
    try {
      await _adminRepo.updateAdmin(user, hotelId);
      emit(AdminUploaded());
    } catch (e) {
      emit(AdminUploadingError(error: "There is an error!"));
    }
  }

  removeAdmin(String adminId) async {
    emit(AdminUploading());
    try {
      await _adminRepo.removeAdmin(adminId);
      emit(AdminUploaded());
    } catch (e) {
      emit(AdminUploadingError(error: "There is an error!"));
    }
  }
}
