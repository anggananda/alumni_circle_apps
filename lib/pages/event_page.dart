import 'package:alumni_circle_app/components/custom_search_box.dart';
import 'package:alumni_circle_app/components/error_widget.dart';
import 'package:alumni_circle_app/components/paggination_page.dart';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/event/cubit/event_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/details/detail_event.dart';
import 'package:alumni_circle_app/dto/event.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/event_form_page.dart';
import 'package:alumni_circle_app/pages/update_event_page.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/components/category_event_slider.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;

  @override
  void initState(){
    super.initState();
    _searchController = TextEditingController();
    _fetchData();
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchData() {
    final accessToken = context.read<AuthCubit>().state.accessToken;
    BlocProvider.of<EventCubit>(context)
        .fetchEvent(_currentPage, _searchController.text, accessToken!);
  }

  void _navigateToDetail(Events event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailEvent(event: event, page: _currentPage),
      ),
    );
  }

  void _navigateToForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventFormPage(
          page: _currentPage,
        ),
      ),
    );
  }

  void _updateEvent(Events event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateEventPage(event: event, page: _currentPage),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _currentPage = 1; // Reset halaman ke 1 saat melakukan pencarian
    });
    _fetchData();
  }

  void _onSearchCleared() {
    setState(() {
      _currentPage = 1; // Reset halaman ke 1 saat pencarian dihapus
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: secondaryColor,
          child: Column(
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  color: primaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 30.0),
                child: CustomSearchBox(
                  controller: _searchController,
                  onChanged: (value) => _onSearchChanged(value),
                  onClear: () => _onSearchCleared(),
                  hintText: 'Search Event...',
                ),
              ),
              const SizedBox(height: 20.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Category",
                      style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const CategorySlider(),
              const SizedBox(height: 10.0),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state.roles == 'admin') {
                    return Row(
                      children: [
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            _navigateToForm();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  'Add Event',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(height: 10.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "See All the Events",
                      style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              BlocBuilder<EventCubit, EventState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.errorMessage.isNotEmpty) {
                    return BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return ErrorDisplay(
                          message: "Failed to fetch Event",
                          onRetry: () {
                            context.read<EventCubit>().fetchEvent(1, '',
                                state.accessToken!); // Retry fetching events
                          },
                        );
                      },
                    );
                  } else if (state.eventList.isEmpty) {
                    return const Center(child: Text('No discussion data available'));
                  } else {
                    return Column(
                      children: [
                        Container(
                            height: 410,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: state.eventList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                // Tambahkan jarak vertikal antara setiap item
                                return const SizedBox(height: 10);
                              },
                              itemBuilder: (context, index) {
                                final event = state.eventList[index];
                                return GestureDetector(
                                  onTap: () {
                                    _navigateToDetail(event);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: thirdColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // Bagian Gambar Event
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      '${Endpoints.urlUas}/static/storages/${event.gambar}'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Detail Event
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    event.namaEvent,
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Flexible(
                                                    child: Text(
                                                      event.deskripsi,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Tombol Edit (hanya muncul untuk admin)
                                          BlocBuilder<ProfileCubit,
                                              ProfileState>(
                                            builder: (context, state) {
                                              if (state.roles == 'admin') {
                                                return Container(
                                                  padding: const EdgeInsets.only(
                                                      right: 10),
                                                  child: ElevatedButton.icon(
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                      color: Colors.black,
                                                    ),
                                                    label: const Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          Colors.greenAccent,
                                                      backgroundColor:
                                                          Colors.green,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12,
                                                          horizontal: 16),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      elevation: 5,
                                                      shadowColor:
                                                          Colors.redAccent,
                                                    ),
                                                    onPressed: () {
                                                      _updateEvent(event);
                                                    },
                                                  ),
                                                );
                                              } else {
                                                return Container(); // Tombol Edit tidak ditampilkan
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                        const SizedBox(height: 15), // Tambahkan jarak setelah daftar
                      ],
                    );
                  }
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PaginationButton(
                      buttonTo: 'decrement',
                      color: colors2,
                      icon: Icons.arrow_back,
                      text: 'Previous',
                      isEnabled: _currentPage > 1,
                      onTap: () {
                        setState(() {
                          if (_currentPage > 1) {
                            _currentPage--;
                            _fetchData();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Page $_currentPage',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    BlocBuilder<EventCubit, EventState>(
                      builder: (context, state) {
                        return PaginationButton(
                          buttonTo: 'increment',
                          color: colors2,
                          icon: Icons.arrow_forward,
                          text: 'Next',
                          isEnabled: state.eventList.isNotEmpty,
                          onTap: () {
                            setState(() {
                              if (state.eventList.isNotEmpty) {
                                _currentPage++;
                                _fetchData();
                              }
                            });
                          },
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
