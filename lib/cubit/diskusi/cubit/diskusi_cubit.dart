import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'diskusi_state.dart';

class DiskusiCubit extends Cubit<DiskusiState> {
  DiskusiCubit() : super(const DiskusiState.initial());

  void fetchDiskusi(int page, String search, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final diskusiList = await DataService.fetchDiskusi(page, search, accessToken);
      emit(state.copyWith(
        diskusiList: diskusiList,
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

  void sendDiskusi(int idAlumni, String subject, String content, int page, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.sendDiskusi(idAlumni, subject, content, accessToken);
      if (response.statusCode == 201) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchDiskusi(page, '', accessToken); // Refresh the list
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

  void updateDiskusi(int idDiskusi, String subject, String content, int page, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.updateDiskusi(idDiskusi, subject, content, accessToken);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchDiskusi(page, '', accessToken); // Refresh the list
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

  void deleteDiskusi(int idDiskusi, int page, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.deleteDiskusi(idDiskusi, accessToken);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchDiskusi(page, '', accessToken); // Refresh the list
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
