part of 'vacancy_cubit.dart';

@immutable
class VacancyState {
  final List<Vacancies> vacancyList;
  final bool isLoading;
  final String errorMessage;

  const VacancyState({
    required this.vacancyList,
    required this.isLoading,
    required this.errorMessage,
  });

  const VacancyState.initial()
      : vacancyList = const [],
        isLoading = false,
        errorMessage = '';
        

  VacancyState copyWith({
    List<Vacancies>? vacancyList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return VacancyState(
      vacancyList: vacancyList ?? this.vacancyList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
