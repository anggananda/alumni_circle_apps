import 'package:alumni_circle_app/dto/reply.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  ReplyCubit() : super(const ReplyState.initial());

  void fetchReply(int idDiskusi, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(idDiskusi: idDiskusi));
    try {
      final replyList = await DataService.fetchReply(idDiskusi, accessToken);
      emit(state.copyWith(
        replyList: replyList,
        isLoading: false,
        errorMessage: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch diskusi',
      ));
    }
  }

  void sendReply(int idAlumni, int idDiskusi, String content, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.sendReplies(idAlumni, idDiskusi, content, accessToken);
      if (response.statusCode == 201) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchReply(idDiskusi, accessToken); // Refresh the list
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to send diskusi',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send diskusi',
      ));
    }
  }

  void updateReply(int idReply, String content, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.updateReply(idReply, content, accessToken);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchReply(state.idDiskusi, accessToken); // Refresh the list
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update diskusi',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update diskusi',
      ));
    }
  }

  void deleteReply(int idReply, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.deleteReply(idReply, accessToken);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchReply(state.idDiskusi, accessToken); // Refresh the list
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to delete diskusi',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete diskusi',
      ));
    }
  }
}
