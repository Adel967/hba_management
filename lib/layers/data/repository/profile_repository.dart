import '../data_provider/profile_provider.dart';
import '../model/user_model.dart';

class ProfileRepository {
  ProfileProvider _profileProvider;

  ProfileRepository(this._profileProvider);

  Future<UserModel> getUserProfile() async {
    final res = await _profileProvider.getUserProfile();
    return UserModel.fromJson(res);
  }
}
