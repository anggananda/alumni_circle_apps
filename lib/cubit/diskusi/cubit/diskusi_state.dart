part of 'diskusi_cubit.dart';

@immutable
class DiskusiState {
  final List<Diskusi> diskusiList;
  final bool isLoading;
  final String errorMessage;

  const DiskusiState({
    required this.diskusiList,
    required this.isLoading,
    required this.errorMessage,
  });

  const DiskusiState.initial()
      : diskusiList = const [],
        isLoading = false,
        errorMessage = '';

  DiskusiState copyWith({
    List<Diskusi>? diskusiList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DiskusiState(
      diskusiList: diskusiList ?? this.diskusiList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
