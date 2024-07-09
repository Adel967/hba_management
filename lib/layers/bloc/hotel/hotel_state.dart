part of 'hotel_cubit.dart';

@immutable
abstract class HotelState extends Equatable {}

class HotelInitial extends HotelState {
  @override
  List<Object?> get props => [];
}

class HotelLoading extends HotelState {
  @override
  List<Object?> get props => [];
}

class HotelUploading extends HotelState {
  @override
  List<Object?> get props => [];
}

class HotelUploaded extends HotelState {
  @override
  List<Object?> get props => [];
}

class HotelUploadingError extends HotelState {
  final String error;

  HotelUploadingError({required this.error});

  @override
  List<Object?> get props => [this.error];
}

class HotelLoaded extends HotelState {
  List<HotelModel> hotels = [];

  HotelLoaded({required this.hotels});

  @override
  List<Object?> get props => [this.hotels];
}

class HotelError extends HotelState {
  final String error;

  HotelError({required this.error});

  @override
  List<Object?> get props => [this.error];
}
