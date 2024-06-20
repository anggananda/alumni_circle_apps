import 'package:alumni_circle_app/components/custom_search_box.dart';
import 'package:alumni_circle_app/components/error_widget.dart';
import 'package:alumni_circle_app/components/paggination_page.dart';
import 'package:alumni_circle_app/cubit/alumni/cubit/alumni_cubit.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
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
  String _searchQuery = '';

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
      showSuccessDialog(context, 'Successfully Delete User');
    } else {
      showErrorDialog(context, 'Failed to User');
    }
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
          'User Control',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: CustomSearchBox(
              controller: _searchController,
              onChanged: (value) => _onSearchChanged(value),
              onClear: () => _onSearchCleared(),
              hintText: 'Search User...',
            ),
          ),
          Expanded(
            child: BlocBuilder<AlumniCubit, AlumniState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.errorMessage.isNotEmpty) {
                  return ErrorDisplay(
                      message: state.errorMessage,
                      onRetry: () {
                        context
                            .read<AlumniCubit>()
                            .fetchAlumniAll(1, ''); // Retry fetching events
                      },
                    );
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
                                        showConfirmDeleteDialog(
                                            context: context,
                                            onConfirm: () {
                                              _deleteUser(alumni.idAlumni);
                                            });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                      ),
                                      label: Text('Delete User'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: Colors.red,
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
                BlocBuilder<AlumniCubit, AlumniState>(
                  builder: (context, state) {
                    return PaginationButton(
                      buttonTo: 'increment',
                      color: colors2,
                      icon: Icons.arrow_forward,
                      text: 'Next',
                      isEnabled: !state.alumni.isEmpty,
                      onTap: () {
                        setState(() {
                          if (!state.alumni.isEmpty) {
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
