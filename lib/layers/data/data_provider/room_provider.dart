import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hba_management/core/enum.dart';
import 'package:hba_management/layers/data/model/hotel_model.dart';
import 'package:hba_management/layers/data/model/image_model.dart';
import 'package:hba_management/layers/data/model/room_model.dart';
import 'package:uuid/uuid.dart';
import '../../../core/firebase/firestore_keys.dart';

class RoomProvider {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getRoomsByHotel(
      String hotelId) async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.rooms_collections)
        .where("hotelId", isEqualTo: hotelId)
        .get();
  }

  Future<DocumentReference<Map<String, dynamic>>> addRoom(
      RoomsModel room, File image) async {
    final imagesUrl = await uploadImage(image);
    room.imageUrl = imagesUrl;
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.rooms_collections)
        .add(room.toJson());
  }

  Future<void> updateRoom(RoomsModel room, ImageModel image) async {
    if (image.imageType == ImageType.FILE) {
      removeImage(room.imageUrl!);

      final imagesUrl = await uploadImage(File(image.imageUrl));
      room.imageUrl = imagesUrl;
    }

    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.rooms_collections)
        .doc(room.id)
        .update(room.toJson());
  }

  Future<void> removeRoom(RoomsModel room) async {
    removeImage(room.imageUrl!);
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.rooms_collections)
        .doc(room.id)
        .delete();
  }

  Future<void> removeImage(String imageURl) async {
    await FirebaseStorage.instance.refFromURL(imageURl).delete();
  }

  Future<String> uploadImage(File image) async {
    Reference reference =
        _storage.ref().child("room/images/${Uuid().v4()}.jpg");
    await reference.putFile(image);
    String url = await reference.getDownloadURL();

    return url;
  }
}
