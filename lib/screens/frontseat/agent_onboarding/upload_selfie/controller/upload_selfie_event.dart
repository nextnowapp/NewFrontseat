part of 'upload_selfie_bloc.dart';

@immutable
abstract class UploadSelfieEvent {}

class PickImageEvent extends UploadSelfieEvent {
  String image;
  PickImageEvent({required this.image});
}

class UpdateSelfieEvent extends UploadSelfieEvent {
  String image;
  BuildContext context;
  UpdateSelfieEvent({required this.image, required this.context});
}
