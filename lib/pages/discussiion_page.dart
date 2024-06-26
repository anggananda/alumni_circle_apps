import 'package:alumni_circle_app/components/custom_search_box.dart';
import 'package:alumni_circle_app/components/error_widget.dart';
import 'package:alumni_circle_app/components/paggination_page.dart';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/diskusi/cubit/diskusi_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/details/detail_forum.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/discussion_form_page.dart';
import 'package:alumni_circle_app/pages/update_discussion_page.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  late TextEditingController _searchController;
  int _currentPage = 1;
  // String _searchQuery = '';

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
    final accessToken = context.read<AuthCubit>().state.accessToken;
    BlocProvider.of<DiskusiCubit>(context)
        .fetchDiskusi(_currentPage, _searchController.text, accessToken!);
  }

  void _navigateToDetail(Diskusi diskusi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailForum(diskusi: diskusi),
      ),
    );
  }

  void _navigateToForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscussionFormPage(
          page: _currentPage,
        ),
      ),
    );
  }

  void _updateDiscussion(Diskusi diskusi) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UpdateDiscussionPage(diskusi: diskusi, page: _currentPage),
      ),
    );
  }

  void _deleteDiscuss(int idDiskusi) async {
    final accessToken = context.read<AuthCubit>().state.accessToken;
    final deleteCubit = context.read<DiskusiCubit>();
    deleteCubit.deleteDiskusi(idDiskusi, _currentPage, accessToken!);
    if (deleteCubit.state.errorMessage == '') {
      showSuccessDialog(context, 'Delete success.');
    } else {
      showErrorDialog(context, 'Failed to delete');
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      // _searchQuery = value;
      _currentPage = 1; // Reset halaman ke 1 saat melakukan pencarian
    });
    _fetchData();
  }

  void _onSearchCleared() {
    setState(() {
      // _searchQuery = "";
      _currentPage = 1; // Reset halaman ke 1 saat pencarian dihapus
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Discussion',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          backgroundColor: primaryColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 30,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
              SingleChildScrollView(
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: CustomSearchBox(
                          controller: _searchController,
                          onChanged: (value) => _onSearchChanged(value),
                          onClear: () => _onSearchCleared(),
                          hintText: 'Search Forum...',
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 30),
                          Row(
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
                                    color: addButtonColor,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add, color: Colors.white),
                                      SizedBox(width: 5),
                                      Text(
                                        'Add Discussion',
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
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<DiskusiCubit, DiskusiState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state.errorMessage.isNotEmpty) {
                            return BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return ErrorDisplay(
                                  message: "Failed to fetch discussion",
                                  onRetry: () {
                                    context.read<DiskusiCubit>().fetchDiskusi(
                                        1, '', state.accessToken!); // Retry fetching events
                                  },
                                );
                              },
                            );
                          } else if (state.diskusiList.isEmpty) {
                            return const Center(
                                child: Text('No discussion data available'));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.diskusiList.length,
                              itemBuilder: (context, index) {
                                final diskusi = state.diskusiList[index];
                                return GestureDetector(
                                  onTap: () => _navigateToDetail(diskusi),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: thirdColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 70,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 52, 42, 42),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        '${Endpoints.urlUas}/static/storages/${diskusi.fotoProfile}'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  top: 10),
                                                          child: Text(
                                                            diskusi
                                                                .subjekDiskusi,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    primaryFontColor,
                                                                fontSize: 18),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      diskusi.email,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            secondaryFontColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          formatDateString(
                                                              diskusi.tanggal),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                secondaryFontColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        BlocBuilder<
                                                            ProfileCubit,
                                                            ProfileState>(
                                                          builder:
                                                              (context, state) {
                                                            if (state.roles ==
                                                                    'admin' ||
                                                                diskusi.idAlumni ==
                                                                    state
                                                                        .idAlumni) {
                                                              return Row(
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _updateDiscussion(diskusi);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                                                              decoration: BoxDecoration(
                                                                                color: updateButtonColor,
                                                                                borderRadius: BorderRadius.circular(6),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.grey.withOpacity(0.5),
                                                                                    spreadRadius: 2,
                                                                                    blurRadius: 5,
                                                                                    offset: const Offset(0, 3), // changes position of shadow
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: const Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Icon(Icons.edit, color: primaryFontColor),
                                                                                  SizedBox(width: 5),
                                                                                  Text(
                                                                                    'Edit',
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
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              showConfirmDeleteDialog(
                                                                                  context: context,
                                                                                  onConfirm: () {
                                                                                    _deleteDiscuss(diskusi.idDiskusi);
                                                                                  });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                                                              decoration: BoxDecoration(
                                                                                color: deleteButtonColor,
                                                                                borderRadius: BorderRadius.circular(6),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.grey.withOpacity(0.5),
                                                                                    spreadRadius: 2,
                                                                                    blurRadius: 5,
                                                                                    offset: const Offset(0, 3), // changes position of shadow
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: const Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Icon(Icons.delete, color: primaryFontColor),
                                                                                  SizedBox(width: 5),
                                                                                  Text(
                                                                                    'Delete',
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
                                                                  )
                                                                ],
                                                              );
                                                            } else {
                                                              return Container(); // Return an empty container if the user is not an admin
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                            BlocBuilder<DiskusiCubit, DiskusiState>(
                              builder: (context, state) {
                                return PaginationButton(
                                  buttonTo: 'increment',
                                  color: colors2,
                                  icon: Icons.arrow_forward,
                                  text: 'Next',
                                  isEnabled: state.diskusiList.isNotEmpty,
                                  onTap: () {
                                    setState(() {
                                      if (state.diskusiList.isNotEmpty) {
                                        _currentPage++;
                                        _fetchData();
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
