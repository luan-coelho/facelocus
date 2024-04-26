part of 'event_code_card_bloc.dart';

@immutable
abstract class EventCodeCardState {}

class EventCodeCardInitial extends EventCodeCardState {}

class EventCodeCardLoading extends EventCodeCardState {}

class EventCodeCardError extends EventCodeCardState {
  final String message;

  EventCodeCardError(this.message);
}

class CodeCopiedSuccess extends EventCodeCardState {
  final String code;

  CodeCopiedSuccess(this.code);
}
