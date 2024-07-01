import 'dart:io';
import 'package:alumni_circle_app/dto/alumni.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'alumni_state.dart';

class AlumniCubit extends Cubit<AlumniState> {
  AlumniCubit() : super(const AlumniState.initial());

  void fetchAlumniAll(int page, String search, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final alumniList =
          await DataService.fetchAlumniAll(page, search, accessToken);
      emit(state.copyWith(
        alumni: alumniList,
        isLoading: false,
        errorMessage: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch alumni',
      ));
    }
  }

  void fetchAlumni(int idAlumni, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final alumni = await DataService.fetchAlumni(idAlumni, accessToken);
      emit(state.copyWith(
        alumni: alumni,
        isLoading: false,
        errorMessage: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch alumni',
      ));
    }
  }

  void updateAlumni(
      int idAlumni,
      String name,
      String username,
      String gender,
      String address,
      String email,
      String graduateDate,
      String batch,
      String jobStatus,
      File? imageFile,
      String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.updateAlumni(
          idAlumni,
          name,
          username,
          gender,
          address,
          email,
          graduateDate,
          batch,
          jobStatus,
          imageFile,
          accessToken);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchAlumni(idAlumni, accessToken); // Refresh the list
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update diskusi ${response.statusCode}',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update diskusi',
      ));
    }
  }

  void deleteAlumni(int idAlumni, int page, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.deleteAlumni(idAlumni, accessToken);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchAlumniAll(page, '', accessToken); // Refresh the list
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to delete alumni',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete alumni',
      ));
    }
  }
}
