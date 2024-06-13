import 'package:alumni_circle_app/dto/question.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit() : super(const QuestionState.initial());
  void fetchFeedback(int page, String search) async {
    emit(state.copyWith(isLoading: true));
    try {
      final questionList = await DataService.fetchQuestion(page, search);
      emit(state.copyWith(
        questionList: questionList,
        isLoading: false,
        errorMessage: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch feedback',
      ));
    }
  }

  void sendQuestion(int idAlumni, String question, int page) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.sendQuestion(idAlumni, question);
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
