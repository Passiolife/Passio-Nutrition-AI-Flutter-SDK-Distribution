part of 'recognize_image_bloc.dart';

abstract class RecognizeImageEvent {}

class DoImagePickEvent extends RecognizeImageEvent {
  final ImageSource source;

  DoImagePickEvent({required this.source});
}

class DoOnImageSelectEvent extends RecognizeImageEvent {
  final XFile? image;
  final ImageSource source;

  DoOnImageSelectEvent({required this.image, required this.source});
}
