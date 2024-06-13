part of 'event_cubit.dart';

@immutable
class EventState {
  final List<Events> eventList;
  final bool isLoading;
  final String errorMessage;

  const EventState({
    required this.eventList,
    required this.isLoading,
    required this.errorMessage,
  });

  const EventState.initial()
      : eventList = const [],
        isLoading = false,
        errorMessage = '';
        

  EventState copyWith({
    List<Events>? eventList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventState(
      eventList: eventList ?? this.eventList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
