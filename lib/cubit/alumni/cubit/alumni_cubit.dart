import 'dart:io';

import 'package:alumni_circle_app/dto/alumni.dart';
import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'alumni_state.dart';

class AlumniCubit extends Cubit<AlumniState> {
  AlumniCubit() : super(const AlumniState.initial());

  void fetchAlumniAll(int page, String search) async {
    emit(state.copyWith(isLoading: true));
    try {
      final alumniList = await DataService.fetchAlumniAll(page, search);
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

  void fetchAlumni(int idAlumni) async {
    emit(state.copyWith(isLoading: true));
    try {
      final alumni = await DataService.fetchAlumni(idAlumni);
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
      String gender,
      String address,
      String email,
      String graduateDate,
      String batch,
      String jobStatus,
      File? imageFile,) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.updateAlumni(idAlumni, name, gender,
          address, email, graduateDate, batch, jobStatus, imageFile);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchAlumni(idAlumni); // Refresh the list
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

  void deleteAlumni(int idAlumni, int page) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.deleteAlumni(idAlumni);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchAlumniAll(page, ''); // Refresh the list
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
