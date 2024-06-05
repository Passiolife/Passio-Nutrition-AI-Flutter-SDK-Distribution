part of 'advisor_image_bloc.dart';

sealed class AdvisorImageEvent {
  const AdvisorImageEvent();
}

class DoInitConversionEvent extends AdvisorImageEvent {
  const DoInitConversionEvent();
}

class DoSendMessageEvent extends AdvisorImageEvent {
  final XFile? image;
  final ImageSource source;

  const DoSendMessageEvent({required this.image, required this.source});
}

class DoImagePickEvent extends AdvisorImageEvent {
  final ImageSource source;

  const DoImagePickEvent({required this.source});
}
