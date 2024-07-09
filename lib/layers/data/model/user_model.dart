import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/enum.dart';

List<UserModel> getUserListFromListMap(List<QueryDocumentSnapshot> list) =>
    List<UserModel>.from(
        list.map((x) => UserModel.fromQueryDocumentSnapshot(x)));

class UserModel {
  String? id;
  String? email;
  String? userName;
  String? phoneNumber;
  String? birthDate;
  Gender? gender;
  String? createdAt;
  String? pushToken;
  String? password;
  int? role;

  UserModel(
      {this.id,
      required this.email,
      required this.userName,
      required this.phoneNumber,
      required this.birthDate,
      required this.gender,
      required this.createdAt,
      required this.pushToken,
      this.password,
      required this.role});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'userName': this.userName,
      'phoneNumber': this.phoneNumber,
      'birthDate': this.birthDate,
      'gender': genderToString(this.gender!),
      'createdAt': this.createdAt,
      'pushToken': this.pushToken,
      'role': this.role
    };
  }

  factory UserModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot map) {
    return UserModel(
      id: map.id,
      email: map['email'],
      userName: map['userName'],
      phoneNumber: map['phoneNumber'],
      birthDate: map['birthDate'],
      gender: stringToGender(map['gender']),
      createdAt: map['createdAt'],
      pushToken: map['pushToken'],
      role: map['role'],
    );
  }

  factory UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> map) {
    return UserModel(
      id: map.id,
      email: map['email'],
      userName: map['userName'],
      phoneNumber: map['phoneNumber'],
      birthDate: map['birthDate'],
      gender: stringToGender(map['gender']),
      createdAt: map['createdAt'],
      pushToken: map['pushToken'],
      role: map['role'],
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? userName,
    String? phoneNumber,
    String? birthDate,
    Gender? gender,
    String? createdAt,
    String? pushToken,
    String? password,
    int? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      pushToken: pushToken ?? this.pushToken,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}
