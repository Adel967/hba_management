import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hba_management/core/exception/app_exceptions.dart';
import 'package:hba_management/layers/data/model/image_model.dart';

import '../data_provider/hotel_provider.dart';
import '../model/hotel_model.dart';

class HotelRepository {
  HotelProvider _exploreProvider;

  HotelRepository(this._exploreProvider);

  Future<List<HotelModel>> getHotels() async {
    final res = await _exploreProvider.getHotels();
    final List<HotelModel> hotels = getHotelListFromListMap(res.docs);
    return hotels;
  }

  Future<HotelModel> getHotelByManagerId(String hotelManagerId) async {
    final res = await _exploreProvider.getHotelByManager(hotelManagerId);
    final List<HotelModel> hotels = getHotelListFromListMap(res.docs);
    if (hotels.isEmpty) {
      throw AppException("No Hotels");
    }
    return hotels.first;
  }

  Future<bool> addHotel(HotelModel hotel, List<File> images) async {
    final res = await _exploreProvider.addHotel(hotel, images);
    if (res != null) {
      return true;
    }
    return false;
  }

  Future<void> updateHotel(HotelModel hotel, List<ImageModel> images) async {
    await _exploreProvider.updateHotel(hotel, images);
  }

  Future<void> removeHotel(String hotelId) async {
    await _exploreProvider.removeHotel(hotelId);
  }
}
