import 'dart:io';

import 'package:hba_management/layers/data/data_provider/user_provider.dart';
import 'package:hba_management/layers/data/model/user_model.dart';

import '../data_provider/hotel_provider.dart';
import '../model/hotel_model.dart';

class AdminRepository {
  AdminProvider _adminProvider;

  AdminRepository(this._adminProvider);

  Future<List<UserModel>> getAdmins() async {
    final res = await _adminProvider.getAdmins();
    final List<UserModel> admins = getUserListFromListMap(res.docs);
    return admins;
  }

  Future<void> addAdmin(UserModel user) async {
    await _adminProvider.addAdmin(user);
  }

  Future<void> updateAdmin(UserModel user, String? hotelId) async {
    await _adminProvider.updateAdmin(user, hotelId);
  }

  Future<void> removeAdmin(String adminId) async {
    await _adminProvider.removeAdmin(adminId);
  }
}
