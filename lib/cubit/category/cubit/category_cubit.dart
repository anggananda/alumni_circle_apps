import 'package:alumni_circle_app/dto/category.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryState.initial());

  void fetchCategory(String accessToken) async {
    emit(state.copyWith(isLoading: true));
    try {
      final categoryList = await DataService.fetchCategory(accessToken);
      emit(state.copyWith(
        categoryList: categoryList,
        isLoading: false,
        errorMessage: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch Category',
      ));
    }
  }
}
