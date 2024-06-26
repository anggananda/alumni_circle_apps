import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/category/cubit/category_cubit.dart';
import 'package:alumni_circle_app/cubit/event/cubit/event_cubit.dart';
import 'package:alumni_circle_app/dto/category.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/detail_category.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorySlider extends StatefulWidget {
  const CategorySlider({super.key});

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  @override
  void initState() {
    super.initState();
    final accessToken = context.read<AuthCubit>().state.accessToken;
    BlocProvider.of<CategoryCubit>(context).fetchCategory(accessToken!);
  }

  void _navigateToDetail(Categories category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailCategory(
          category: category,
          refreshData: _fetchData,
        ),
      ),
    );
  }

  void _fetchData() {
    final accessToken = context.read<AuthCubit>().state.accessToken;
    BlocProvider.of<EventCubit>(context).fetchEvent(1, '', accessToken!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage.isNotEmpty) {
          return Container();
        } else if (state.categoryList.isEmpty) {
          return const Center(child: Text('No discussion data available'));
        } else {
          return Container(
            height: 250,
            padding: const EdgeInsets.all(10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: state.categoryList.map((category) {
                return GestureDetector(
                  onTap: () {
                    _navigateToDetail(category);
                  },
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(
                            '${Endpoints.urlUas}/static/storages/${category.image}'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          category.nameCategory,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
