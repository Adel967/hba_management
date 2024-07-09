import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hba_management/core/enum.dart';
import 'package:hba_management/layers/data/model/hotel_model.dart';
import 'package:hba_management/layers/data/model/image_model.dart';
import 'package:uuid/uuid.dart';
import '../../../core/firebase/firestore_keys.dart';

class HotelProvider {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getHotels() async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.hotels_collections)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getHotelByManager(
      String hotelManager) async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.hotels_collections)
        .where("hotelManagerId", isEqualTo: hotelManager)
        .get();
  }

  Future<DocumentReference<Map<String, dynamic>>> addHotel(
      HotelModel hotel, List<File> images) async {
    final imagesUrl = await Future.wait<String>(
        List.generate(images.length, (index) => uploadImage(images[index])));
    hotel.imagesUrl = List.from(imagesUrl);
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.hotels_collections)
        .add(hotel.toJson());
  }

  Future<void> updateHotel(HotelModel hotel, List<ImageModel> images) async {
    final imagesUrl = await Future.wait<String>(images
        .where((element) => element.imageType == ImageType.FILE)
        .map((e) => uploadImage(File(e.imageUrl))));
    hotel.imagesUrl = [];
    if (imagesUrl.isNotEmpty) {
      hotel.imagesUrl = List.from(imagesUrl);
    }
    hotel.imagesUrl!.addAll(images
        .where((element) => element.imageType == ImageType.NETWORK)
        .map((e) => e.imageUrl)
        .toList());
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.hotels_collections)
        .doc(hotel.hotelsId)
        .update(hotel.toJson());
  }

  Future<void> removeHotel(String hotelID) async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.hotels_collections)
        .doc(hotelID)
        .delete();
  }

  Future<void> removeHotelManager(String managerID) async {
    final hotels = await getHotelByManager(managerID);
    if (hotels.docs.isEmpty) {
      return;
    }

    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.hotels_collections)
        .doc(hotels.docs.first.id)
        .update({"hotelManagerId": ""});
  }

  Future<String> uploadImage(File image) async {
    Reference reference =
        _storage.ref().child("hotels/images/${Uuid().v4()}.jpg");
    await reference.putFile(image);
    String url = await reference.getDownloadURL();

    return url;
  }
}
