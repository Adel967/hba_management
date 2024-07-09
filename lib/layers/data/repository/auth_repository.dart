import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hba_management/core/firebase/constants.dart';
import 'package:hba_management/layers/data/data_provider/auth_provider.dart'
    as auth;
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/exception/app_exceptions.dart';

class AuthRepository {
  auth.AuthProvider _authProvider;

  AuthRepository(this._authProvider);

  Future<Either<AppException, QuerySnapshot<Map<String, dynamic>>>> logIn(
      String email, password) async {
    try {
      try {
        final user = await _authProvider.logIn(email, password);
        return Right(user);
      } on FirebaseAuthException catch (e) {
        return Left(
            AppException(FirebaseConstants.getMessageFromErrorCode(e.code)));
      }
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }
}
