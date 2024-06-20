part of 'category_cubit.dart';

@immutable
class CategoryState {
  final List<Categories> categoryList;
  final bool isLoading;
  final String errorMessage;

  const CategoryState({
    required this.categoryList,
    required this.isLoading,
    required this.errorMessage,
  });

  const CategoryState.initial()
      : categoryList = const [],
        isLoading = false,
        errorMessage = '';

  CategoryState copyWith({
    List<Categories>? categoryList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CategoryState(
      categoryList: categoryList ?? this.categoryList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
