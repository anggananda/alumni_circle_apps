part of 'alumni_cubit.dart';

@immutable
class AlumniState {
  final List<Alumni> alumni;
  final bool isLoading;
  final String errorMessage;

  const AlumniState({
    required this.alumni,
    required this.isLoading,
    required this.errorMessage,
  });

  const AlumniState.initial()
      : alumni = const [],
        isLoading = false,
        errorMessage = '';

  AlumniState copyWith({
    List<Alumni>? alumni,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AlumniState(
      alumni: alumni ?? this.alumni,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

