import 'package:alumni_circle_app/components/custom_search_box.dart';
import 'package:alumni_circle_app/components/error_widget.dart';
import 'package:alumni_circle_app/components/paggination_page.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/cubit/vacancy/cubit/vacancy_cubit.dart';
import 'package:alumni_circle_app/details/detail_vacancy.dart';
import 'package:alumni_circle_app/dto/vacancy.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/update_vacancy_page.dart';
import 'package:alumni_circle_app/pages/vacancy_form_page.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobVacancyPage extends StatefulWidget {
  const JobVacancyPage({super.key});

  @override
  State<JobVacancyPage> createState() => _JobVacancyPageState();
}

class _JobVacancyPageState extends State<JobVacancyPage> {
  late TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  String _searchQuery = "";

  @override
  void initState() {
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
    BlocProvider.of<VacancyCubit>(context)
        .fetchVacancy(_currentPage, _searchController.text);
  }

  void _navigateToDetail(Vacancies vacancy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailVacancy(
          vacancy: vacancy,
          page: _currentPage,
        ),
      ),
    );
  }

  void _navigateToForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VacancyFormPage(
          page: _currentPage,
        ),
      ),
    );
  }

  void _updateVacancy(Vacancies vacancy) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UpdateVacancyPage(vacancy: vacancy, page: _currentPage),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 1; // Reset halaman ke 1 saat melakukan pencarian
    });
    _fetchData();
  }

  void _onSearchCleared() {
    setState(() {
      _searchQuery = "";
      _currentPage = 1; // Reset halaman ke 1 saat pencarian dihapus
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Vacancy',
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
                  hintText: 'Search Vacancy...',
                ),
              ),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state.roles == 'admin') {
                    return Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                _navigateToForm();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Add Vacancy',
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
                        )
                      ],
                    );
                  } else {
                    return Container(); // Return an empty container if the user is not an admin
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "See All the Vacancies",
                      style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<VacancyCubit, VacancyState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.errorMessage.isNotEmpty) {
                    return ErrorDisplay(
                      message: state.errorMessage,
                      onRetry: () {
                        context
                            .read<VacancyCubit>()
                            .fetchVacancy(1, ''); // Retry fetching events
                      },
                    );
                  } else if (state.vacancyList.isEmpty) {
                    return Center(child: Text('No discussion data available'));
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
                              itemCount: state.vacancyList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                // Tambahkan jarak vertikal antara setiap item
                                return SizedBox(height: 10);
                              },
                              itemBuilder: (context, index) {
                                final vacancy = state.vacancyList[index];
                                return GestureDetector(
                                  onTap: () {
                                    _navigateToDetail(vacancy);
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
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      '${Endpoints.urlUas}/static/storages/${vacancy.gambar}'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    vacancy.namaVacancy,
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Flexible(
                                                    child: Text(
                                                      vacancy.deskripsi,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          BlocBuilder<ProfileCubit,
                                              ProfileState>(
                                            builder: (context, state) {
                                              if (state.roles == 'admin') {
                                                return Container(
                                                  padding: EdgeInsets.only(
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
                                                      foregroundColor: Colors.greenAccent, backgroundColor: Colors.green, padding: const EdgeInsets
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
                                                      _updateVacancy(vacancy);
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
                        SizedBox(height: 15), // Tambahkan jarak setelah daftar
                      ],
                    );
                  }
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                    SizedBox(width: 20),
                    Text(
                      'Page $_currentPage',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                    BlocBuilder<VacancyCubit, VacancyState>(
                      builder: (context, state) {
                        return PaginationButton(
                          buttonTo: 'increment',
                          color: colors2,
                          icon: Icons.arrow_forward,
                          text: 'Next',
                          isEnabled: !state.vacancyList.isEmpty,
                          onTap: () {
                            setState(() {
                              if (!state.vacancyList.isEmpty) {
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
