part of 'legacy_api_bloc.dart';

sealed class LegacyApiState {
  const LegacyApiState();
}

final class LegacyApiInitial extends LegacyApiState {
  const LegacyApiInitial();
}

final class FetchLegacySuccessState extends LegacyApiState {
  final String data;
  const FetchLegacySuccessState(this.data);
}
