part of 'advisor_image_bloc.dart';

sealed class AdvisorImageState {
  const AdvisorImageState();
}

final class AdvisorImageInitial extends AdvisorImageState {
  const AdvisorImageInitial();
}

final class InitializationSuccessState extends AdvisorImageState {
  const InitializationSuccessState();
}

final class InitializationErrorState extends AdvisorImageState {
  final String message;

  const InitializationErrorState({required this.message});
}

final class SendMessageErrorState extends AdvisorImageState {
  final String message;

  const SendMessageErrorState({required this.message});
}

final class SendMessageSuccessState extends AdvisorImageState {
  final PassioAdvisorResponse data;

  const SendMessageSuccessState({required this.data});
}

/// states for DoImagePickEvent
class OnSelectImageState extends AdvisorImageState {
  final XFile? image;

  const OnSelectImageState({required this.image});
}

class OnSelectImageLoadingState extends AdvisorImageState {
  final bool isLoading;

  const OnSelectImageLoadingState({required this.isLoading});
}

class OnSelectImageFailureState extends AdvisorImageState {
  final String message;

  const OnSelectImageFailureState({required this.message});
}
