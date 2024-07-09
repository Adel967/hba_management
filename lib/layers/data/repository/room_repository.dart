import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hba_management/core/exception/app_exceptions.dart';
import 'package:hba_management/layers/data/data_provider/room_provider.dart';
import 'package:hba_management/layers/data/model/image_model.dart';
import 'package:hba_management/layers/data/model/room_model.dart';

import '../data_provider/hotel_provider.dart';
import '../model/hotel_model.dart';

class RoomRepository {
  RoomProvider _roomProvider;

  RoomRepository(this._roomProvider);

  Future<List<RoomsModel>> getRoomsByHotelsId(String hotelId) async {
    final res = await _roomProvider.getRoomsByHotel(hotelId);
    final List<RoomsModel> rooms = getRoomListFromListMap(res.docs);
    return rooms;
  }

  Future<bool> addRoom(RoomsModel room, File images) async {
    final res = await _roomProvider.addRoom(room, images);
    if (res != null) {
      return true;
    }
    return false;
  }

  Future<void> updateRoom(RoomsModel room, ImageModel image) async {
    await _roomProvider.updateRoom(room, image);
  }

  Future<void> removeRoom(RoomsModel room) async {
    await _roomProvider.removeRoom(room);
  }
}
