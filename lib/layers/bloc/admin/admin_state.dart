part of 'admin_cubit.dart';

@immutable
abstract class AdminState extends Equatable{}


class AdminInitial extends AdminState {
  @override
  List<Object?> get props => [];
}

class AdminLoading extends AdminState {
  @override
  List<Object?> get props => [];
}

class AdminUploading extends AdminState {
  @override
  List<Object?> get props => [];
}

class AdminUploaded extends AdminState {
  @override
  List<Object?> get props => [];
}

class AdminUploadingError extends AdminState {
  final String error;

  AdminUploadingError({required this.error});
  @override
  List<Object?> get props => [this.error];
}

class AdminLoaded extends AdminState {
  List<UserModel> admins = [];

  AdminLoaded({required this.admins});

  @override
  List<Object?> get props => [this.admins];
}

class AdminError extends AdminState {
  final String error;

  AdminError({required this.error});

  @override
  List<Object?> get props => [this.error];
}

