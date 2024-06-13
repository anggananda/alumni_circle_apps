import 'package:alumni_circle_app/components/custom_search_box.dart';
import 'package:alumni_circle_app/cubit/diskusi/cubit/diskusi_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/details/detail_forum.dart';
import 'package:alumni_circle_app/dto/total.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/discussion_form_page.dart';
import 'package:alumni_circle_app/pages/update_discussion_page.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({Key? key}) : super(key: key);

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
late TextEditingController _searchController; 
  int _currentPage = 1;

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
    BlocProvider.of<DiskusiCubit>(context)
        .fetchDiskusi(_currentPage, _searchController.text);
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
    final deleteCubit = context.read<DiskusiCubit>();
    deleteCubit.deleteDiskusi(idDiskusi, _currentPage);
    if (deleteCubit.state.errorMessage == '') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Delete Discussion')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to Delete Discussion')));
    }
    Navigator.pop(context);
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
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: CustomSearchBox(
                          controller: _searchController,
                          onChanged: (value) => _fetchData(),
                          onClear: () => _fetchData(),
                          hintText: 'Search Forum...',
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(width: 15),
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
                            return Center(child: CircularProgressIndicator());
                          } else if (state.errorMessage.isNotEmpty) {
                            return Center(child: Text(state.errorMessage));
                          } else if (state.diskusiList.isEmpty) {
                            return Center(
                                child: Text('No discussion data available'));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
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
                                                offset: Offset(0, 3),
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
                                                        Expanded(
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
                                                        ),
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
                                                    SizedBox(
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
                                                                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.green,
                                                                                borderRadius: BorderRadius.circular(6),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.grey.withOpacity(0.5),
                                                                                    spreadRadius: 2,
                                                                                    blurRadius: 5,
                                                                                    offset: Offset(0, 3), // changes position of shadow
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Row(
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
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(15.0),
                                                                                    ),
                                                                                    title: const Text(
                                                                                      "Confirm Delete",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.red,
                                                                                      ),
                                                                                    ),
                                                                                    content: const Text(
                                                                                      "Are you sure you want to delete this reply?",
                                                                                      style: TextStyle(fontSize: 16),
                                                                                    ),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                        child: const Text(
                                                                                          "Cancel",
                                                                                          style: TextStyle(color: Colors.grey),
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                      ElevatedButton(
                                                                                        child: const Text(
                                                                                          "Delete",
                                                                                          style: TextStyle(color: Colors.white),
                                                                                        ),
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          primary: Colors.red,
                                                                                          onPrimary: Colors.redAccent,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                          ),
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          _deleteDiscuss(diskusi.idDiskusi);
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.red,
                                                                                borderRadius: BorderRadius.circular(6),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.grey.withOpacity(0.5),
                                                                                    spreadRadius: 2,
                                                                                    blurRadius: 5,
                                                                                    offset: Offset(0, 3), // changes position of shadow
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Row(
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
                                                    SizedBox(
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
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              color:
                                  _currentPage > 1 ? Colors.blue : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: _currentPage > 1
                                    ? () {
                                        setState(() {
                                          if (_currentPage > 1) {
                                            _currentPage--;
                                            _fetchData();
                                          }
                                        });
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.arrow_back,
                                          color: Colors.white),
                                      SizedBox(width: 5),
                                      Text(
                                        'Previous',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Page $_currentPage',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 20),
                            BlocBuilder<DiskusiCubit, DiskusiState>(
                              builder: (context, state) {
                                return Material(
                                  color: state.diskusiList.isEmpty
                                      ? Colors.grey
                                      : Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      setState(() {
                                        state.diskusiList.isEmpty
                                            ? _currentPage
                                            : _currentPage++;
                                        _fetchData();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Next',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(Icons.arrow_forward,
                                              color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
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
            ],
          ),
        ));
  }
}
