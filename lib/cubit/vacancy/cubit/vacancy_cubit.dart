import 'dart:io';
import 'package:alumni_circle_app/dto/event.dart';
import 'package:alumni_circle_app/dto/vacancy.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'vacancy_state.dart';

class VacancyCubit extends Cubit<VacancyState> {
  VacancyCubit() : super(const VacancyState.initial());
  void fetchVacancy(int page, String search) async {
    emit(state.copyWith(isLoading: true));
    try {
      final vacancyList = await DataService.fetchVacancies(page, search);
      emit(state.copyWith(
        vacancyList: vacancyList,
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

  void sendVacancy(String vacancyName, String vacancyDescripsion, File? imageFile, int page) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.sendVacancy(vacancyName, vacancyDescripsion, imageFile);
      if (response.statusCode == 201) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchVacancy(page, ''); 
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

  void updateVacancy(int idVacancy, String vacancyName, String vacancyDescripsion, File? imageFile, int page) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.updateVacancy(idVacancy, vacancyName, vacancyDescripsion, imageFile);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchVacancy(page, ''); // Refresh the list
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

  void deleteVacancy(int idVacancy, int page) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.deleteVacancy(idVacancy);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchVacancy(page, ''); // Refresh the list
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
