import 'package:alumni_circle_app/dto/feedback.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(const FeedbackState.initial());
  void fetchFeedback(int page, String search) async {
  emit(state.copyWith(isLoading: true));
  try {
    print('Fetching feedback for page $page with search query "$search"'); // Logging
    final feedbackList = await DataService.fetchFeedback(page, search);
    print('Fetched feedback: $feedbackList'); // Logging

    emit(state.copyWith(
      feedbackList: feedbackList,
      isLoading: false,
      errorMessage: '',
    ));
  } catch (e) {
    print('Error fetching feedback: $e'); // Logging
    emit(state.copyWith(
      isLoading: false,
      errorMessage: 'Failed to fetch feedback',
    ));
  }
}


  void sendFeedback(int idAlumni, String feedback, int page) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.sendFeedback(idAlumni, feedback);
      if (response.statusCode == 201) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchFeedback(page, ''); 
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to send Feedback',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send Feedback',
      ));
    }
  }

}
