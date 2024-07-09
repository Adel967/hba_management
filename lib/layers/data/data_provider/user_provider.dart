import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hba_management/layers/data/data_provider/hotel_provider.dart';
import 'package:hba_management/layers/data/model/hotel_model.dart';
import 'package:hba_management/layers/data/model/user_model.dart';
import 'package:uuid/uuid.dart';
import '../../../core/firebase/firestore_keys.dart';
import '../../../injection_container.dart';

class AdminProvider {
  Future<QuerySnapshot<Map<String, dynamic>>> getAdmins() async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.users_collections)
        .where("role", isEqualTo: 2)
        .get();
  }

  Future<void> addAdmin(UserModel user) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'secondary', options: Firebase.app().options);
    final res = await FirebaseAuth.instanceFor(app: app)
        .createUserWithEmailAndPassword(
            email: user.email!, password: user.password!);
    user.id = res.user!.uid;
    app.delete();
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.users_collections)
        .doc(res.user!.uid)
        .set(user.toMap());
  }

  Future<void> updateAdmin(UserModel user, String? hotelId) async {
    if (hotelId != null) {
      await FirebaseFirestore.instance
          .collection(FireStoreKeys.hotels_collections)
          .doc(hotelId)
          .update({"hotelManagerId": user.id});
    }
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.users_collections)
        .doc(user.id)
        .update(user.toMap());
  }

  Future<void> removeAdmin(String adminId) async {
    await sl<HotelProvider>().removeHotelManager(adminId);

    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.users_collections)
        .doc(adminId)
        .delete();
  }
}
