part of 'static_image_bloc.dart';

abstract class StaticImageEvent {}

class DoImagePickEvent extends StaticImageEvent {
  final ImageSource source;

  DoImagePickEvent({required this.source});
}

class DoOnImageSelectEvent extends StaticImageEvent {
  final XFile? image;
  final ImageSource source;

  DoOnImageSelectEvent({required this.image, required this.source});
}
