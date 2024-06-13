part of 'question_cubit.dart';

@immutable
class QuestionState {
  final List<Question> questionList;
  final bool isLoading;
  final String errorMessage;

  const QuestionState({
    required this.questionList,
    required this.isLoading,
    required this.errorMessage,
  });

  const QuestionState.initial()
      : questionList = const [],
        isLoading = false,
        errorMessage = '';
        

  QuestionState copyWith({
    List<Question>? questionList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return QuestionState(
      questionList: questionList ?? this.questionList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

