import 'dart:io';
import 'package:alumni_circle_app/dto/event.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(const EventState.initial());
  void fetchEvent(int page, String search, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final eventList = await DataService.fetchEvents(page, search, accessToken);
      emit(state.copyWith(
        eventList: eventList,
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

  void fetchEventCategory(int idCategory, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final eventList = await DataService.fetchEventCategory(idCategory, accessToken);
      emit(state.copyWith(
        eventList: eventList,
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

  void sendEvent(int idCategory, String eventName, String eventDate, String eventLocation, String eventDescription, File? imageFile, int page, String latitude, String longitude, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.sendEvent(idCategory, eventName, eventDate, eventLocation, eventDescription, imageFile, latitude, longitude, accessToken);
      if (response.statusCode == 201) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchEvent(page, '', accessToken); 
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

  void updateEvent(int idEvent, int idCategory, String eventName, String eventDate, String eventLocation, String eventDescription, File? imageFile, int page, String latitude, String longitude, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.updateEvent(idEvent, idCategory, eventName, eventDate, eventLocation, eventDescription, imageFile, latitude, longitude, accessToken);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchEvent(page, '', accessToken); // Refresh the list
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

  void deleteEvent(int idEvent, int page, String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await DataService.deleteEvent(idEvent, accessToken);
      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '',
        ));
        fetchEvent(page, '', accessToken); // Refresh the list
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
