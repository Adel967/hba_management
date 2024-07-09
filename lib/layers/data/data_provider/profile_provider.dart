import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/enum.dart';
import '../../../core/firebase/firestore_keys.dart';
import '../model/user_model.dart';

class ProfileProvider {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  User currentUser = _auth.currentUser!;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile() async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.users_collections)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }
}
