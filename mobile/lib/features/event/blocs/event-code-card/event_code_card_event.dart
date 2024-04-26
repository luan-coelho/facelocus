part of 'event_code_card_bloc.dart';

@immutable
abstract class EventCodeCardEvent {}

class GenerateNewCode extends EventCodeCardEvent {
  final int id;

  GenerateNewCode(this.id);
}
