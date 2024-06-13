import 'package:alumni_circle_app/components/custom_search_box.dart';
import 'package:alumni_circle_app/cubit/alumni/cubit/alumni_cubit.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserControlScreen extends StatefulWidget {
  const UserControlScreen({Key? key}) : super(key: key);

  @override
  _UserControlScreenState createState() => _UserControlScreenState();
}

class _UserControlScreenState extends State<UserControlScreen> {
  TextEditingController _searchController = TextEditingController();
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
    BlocProvider.of<AlumniCubit>(context)
        .fetchAlumniAll(_currentPage, _searchController.text);
  }

  void _deleteUser(idAlumni) async {
    final deleteCubit = context.read<AlumniCubit>();
    deleteCubit.deleteAlumni(idAlumni, _currentPage);
    if (deleteCubit.state.errorMessage == '') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Delete Discussion')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to Delete Discussion')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Control',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(12),
          child: CustomSearchBox(
            controller: _searchController,
            onChanged: (value) => _fetchData(),
            onClear: () => _fetchData(),
            hintText: 'Search User...',
          ),),
          Expanded(
            child: BlocBuilder<AlumniCubit, AlumniState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.errorMessage.isNotEmpty) {
                  return Center(child: Text(state.errorMessage));
                } else if (state.alumni.isEmpty) {
                  return Center(child: Text('No user data available'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.alumni.length,
                    itemBuilder: (context, index) {
                      final alumni = state.alumni[index];
                      return SingleChildScrollView(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15.0),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  '${Endpoints.urlUas}/static/storages/${alumni.fotoProfile ?? ''}'),
                              radius: 30,
                            ),
                            title: Text(
                              alumni.namaALumni ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildRow(Icons.person, 'Username',
                                      alumni.username ?? 'N/A'),
                                  _buildRow(Icons.email, 'Email',
                                      alumni.email ?? 'N/A'),
                                  _buildRow(Icons.home, 'Alamat',
                                      alumni.alamat ?? 'N/A'),
                                  _buildRow(Icons.school, 'Angkatan',
                                      '${alumni.angkatan}' ?? 'N/A'),
                                  _buildRow(Icons.transgender, 'Jenis Kelamin',
                                      alumni.jenisKelamin ?? 'N/A'),
                                  _buildRow(Icons.security, 'Roles',
                                      alumni.roles ?? 'N/A'),
                                  _buildRow(Icons.work, 'Status Pekerjaan',
                                      alumni.statusPekerjaan ?? 'N/A'),
                                  SizedBox(height: 10),
                                  Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              title: const Text(
                                                "Confirm Delete",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              content: const Text(
                                                "Are you sure you want to delete this event?",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.red,
                                                    onPrimary: Colors.redAccent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    _deleteUser(
                                                        alumni.idAlumni);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                      ),
                                      label: Text('Delete User'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: _currentPage > 1 ? Colors.blue : Colors.grey,
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
                          Icon(Icons.arrow_back, color: Colors.white),
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
                BlocBuilder<AlumniCubit, AlumniState>(
                  builder: (context, state) {
                    return Material(
                      color: state.alumni.isEmpty ? Colors.grey : Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            state.alumni.isEmpty
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
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward, color: Colors.white),
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
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            '$label: $value',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
