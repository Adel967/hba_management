import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hba_management/core/app/state/app_state.dart';
import 'package:hba_management/layers/data/model/image_model.dart';
import 'package:hba_management/layers/data/model/room_model.dart';
import 'package:hba_management/layers/data/repository/room_repository.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  RoomCubit() : super(RoomInitial());

  final _roomRepo = sl<RoomRepository>();

  getRooms(BuildContext context) async {
    emit(RoomLoading());
    try {
      final rooms = await _roomRepo.getRoomsByHotelsId(
          Provider.of<AppState>(context, listen: false).hotel.hotelsId!);
      emit(RoomLoaded(rooms: rooms));
    } catch (e) {
      emit(RoomError(error: "There is an error!"));
    }
  }

  addRoom(RoomsModel room, File image) async {
    emit(RoomUploading());
    try {
      await _roomRepo.addRoom(room, image);
      emit(RoomUploaded());
    } catch (e) {
      emit(RoomUploadingError(error: "There is an error!"));
    }
  }

  updateRoom(RoomsModel room, ImageModel image) async {
    emit(RoomUploading());
    try {
      await _roomRepo.updateRoom(room, image);
      emit(RoomUploaded());
    } catch (e) {
      emit(RoomUploadingError(error: "There is an error!"));
    }
  }

  removeRoom(RoomsModel room) async {
    emit(RoomUploading());
    try {
      await _roomRepo.removeRoom(room);
      emit(RoomUploaded());
    } catch (e) {
      emit(RoomUploadingError(error: "There is an error!"));
    }
  }
}
