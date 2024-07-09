import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hba_management/layers/data/model/hotel_model.dart';
import 'package:hba_management/layers/data/repository/hotel_repository.dart';
import 'package:hba_management/layers/data/repository/profile_repository.dart';
import '../../../injection_container.dart';
import '../../../layers/data/model/user_model.dart';

class AppState extends ChangeNotifier {
  final _profileRpo = sl<ProfileRepository>();
  final _hotelRepo = sl<HotelRepository>();

  UserModel? _userModel;
  HotelModel? _hotelModel;

  Future init() async {
    await getUserProfile();
  }

  UserModel get user => _userModel!;
  HotelModel get hotel => _hotelModel!;

  setHotel() async {
    _hotelModel = await _hotelRepo
        .getHotelByManagerId(FirebaseAuth.instance.currentUser!.uid);
  }

  Future getUserProfile() async {
    _userModel = await _profileRpo.getUserProfile();
  }
}
