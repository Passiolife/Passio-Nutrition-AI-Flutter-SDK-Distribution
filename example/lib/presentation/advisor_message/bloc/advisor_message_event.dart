part of 'advisor_message_bloc.dart';

sealed class AdvisorMessageEvent {
  const AdvisorMessageEvent();
}

class DoInitConversionEvent extends AdvisorMessageEvent {
  const DoInitConversionEvent();
}

class DoSendMessageEvent extends AdvisorMessageEvent {
  final String message;

  const DoSendMessageEvent({required this.message});
}

class DoFetchIngredientEvent extends AdvisorMessageEvent {
  final PassioAdvisorResponse? response;

  const DoFetchIngredientEvent({this.response});
}
