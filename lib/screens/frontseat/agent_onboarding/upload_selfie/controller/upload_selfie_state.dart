part of 'upload_selfie_bloc.dart';

class UploadSelfieState {
  String imagePath;
  UploadSelfieState({required this.imagePath});
}

class UploadSelfieInitial extends UploadSelfieState {
  UploadSelfieInitial() : super(imagePath: '');
}
