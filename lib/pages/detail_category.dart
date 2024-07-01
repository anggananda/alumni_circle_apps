import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/event/cubit/event_cubit.dart';
import 'package:alumni_circle_app/dto/category.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailCategory extends StatefulWidget {
  final Categories category;
  final VoidCallback? refreshData;
  const DetailCategory(
      {super.key, required this.category, this.refreshData});

  @override
  State<DetailCategory> createState() => _DetailCategoryState();
}

class _DetailCategoryState extends State<DetailCategory> {
  @override
  void initState() {
    super.initState();
    final accessToken = context.read<AuthCubit>().state.accessToken;
    BlocProvider.of<EventCubit>(context)
        .fetchEventCategory(widget.category.idCategory, accessToken!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: secondaryColor,
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      '${Endpoints.urlUas}/static/storages/${widget.category.image}'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 70,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.refreshData!();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: secondaryColor,
                            ),
                            child: const Icon(Icons.arrow_back),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "🌟 Overview",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryFontColor),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Details",
                    style: TextStyle(color: primaryFontColor),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.category.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(color: primaryFontColor),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  "Preview",
                  style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            BlocBuilder<EventCubit, EventState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.errorMessage.isNotEmpty) {
                  return Center(child: Text(state.errorMessage));
                } else if (state.eventList.isEmpty) {
                  return Container();
                } else {
                  return Container(
                    height: 150,
                    padding: const EdgeInsets.all(10),
                    child: ListView.separated(
                      itemCount: state.eventList.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 15.0,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final event = state.eventList[index];
                        return Container(
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  '${Endpoints.urlUas}/static/storages/${event.gambar}'), // Pastikan 'event.imageUrl' mengandung URL gambar
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    event.namaEvent,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ));
  }
}
