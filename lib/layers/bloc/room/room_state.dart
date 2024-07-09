part of 'room_cubit.dart';

@immutable
abstract class RoomState extends Equatable {}

class RoomInitial extends RoomState {
  @override
  List<Object?> get props => [];
}

class RoomLoading extends RoomState {
  @override
  List<Object?> get props => [];
}

class RoomUploading extends RoomState {
  @override
  List<Object?> get props => [];
}

class RoomUploaded extends RoomState {
  @override
  List<Object?> get props => [];
}

class RoomUploadingError extends RoomState {
  final String error;

  RoomUploadingError({required this.error});

  @override
  List<Object?> get props => [this.error];
}

class RoomLoaded extends RoomState {
  List<RoomsModel> rooms = [];

  RoomLoaded({required this.rooms});

  @override
  List<Object?> get props => [this.rooms];
}

class RoomError extends RoomState {
  final String error;

  RoomError({required this.error});

  @override
  List<Object?> get props => [this.error];
}
