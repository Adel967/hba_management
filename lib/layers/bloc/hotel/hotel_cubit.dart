import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hba_management/layers/data/model/hotel_model.dart';
import 'package:hba_management/layers/data/model/image_model.dart';
import 'package:hba_management/layers/data/repository/hotel_repository.dart';
import 'package:meta/meta.dart';

import '../../../injection_container.dart';

part 'hotel_state.dart';

class HotelCubit extends Cubit<HotelState> {
  HotelCubit() : super(HotelInitial());

  final _hotelRepository = sl<HotelRepository>();

  getHotels() async {
    emit(HotelLoading());
    try {
      final hotels = await _hotelRepository.getHotels();
      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelError(error: "There is an error!"));
    }
  }

  addHotel(HotelModel hotel, List<File> images) async {
    emit(HotelUploading());
    try {
      await _hotelRepository.addHotel(hotel, images);
      emit(HotelUploaded());
    } catch (e) {
      emit(HotelUploadingError(error: "There is an error!"));
    }
  }

  updateHotel(HotelModel hotel, List<ImageModel> images) async {
    emit(HotelUploading());
    try {
      await _hotelRepository.updateHotel(hotel, images);
      emit(HotelUploaded());
    } catch (e) {
      emit(HotelUploadingError(error: "There is an error!"));
    }
  }

  removeHotel(String hotelId) async {
    emit(HotelUploading());
    try {
      await _hotelRepository.removeHotel(hotelId);
      emit(HotelUploaded());
    } catch (e) {
      emit(HotelUploadingError(error: "There is an error!"));
    }
  }
}
