import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hba_management/core/firebase/firestore_keys.dart';

import '../../../injection_container.dart';
import 'hotel_provider.dart';

class AuthProvider {
  Future<QuerySnapshot<Map<String, dynamic>>> logIn(
      String email, password) async {
    final user = await checkIfUserIsAdmin(email);
    if (user.size != 0) {
      if (user.docs.first["role"] == 1 || user.docs.first["role"] == 2) {
        if (user.docs.first["role"] == 2) {
          final res = await sl<HotelProvider>()
              .getHotelByManager(user.docs.first["id"]);
          if (res.size == 0) {
            throw Exception("This user is not a manager for any hotel!");
          }
        }
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return user;
      }
    }
    throw Exception("Wrong email or password");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> checkIfUserIsAdmin(
      String email) async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.users_collections)
        .where("email", isEqualTo: email)
        .get();
  }
}
