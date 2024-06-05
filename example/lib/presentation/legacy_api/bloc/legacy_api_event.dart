part of 'legacy_api_bloc.dart';

sealed class LegacyApiEvent {
  const LegacyApiEvent();
}

final class DoFetchLegacyEvent extends LegacyApiEvent {
  final PassioID passioID;

  const DoFetchLegacyEvent(this.passioID);
}
