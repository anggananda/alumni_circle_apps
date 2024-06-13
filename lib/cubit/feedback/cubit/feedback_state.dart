part of 'feedback_cubit.dart';

@immutable
class FeedbackState {
  final List<FeedBacks> feedbackList;
  final bool isLoading;
  final String errorMessage;

  const FeedbackState({
    required this.feedbackList,
    required this.isLoading,
    required this.errorMessage,
  });

  const FeedbackState.initial()
      : feedbackList = const [],
        isLoading = false,
        errorMessage = '';
        

  FeedbackState copyWith({
    List<FeedBacks>? feedbackList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FeedbackState(
      feedbackList: feedbackList ?? this.feedbackList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

