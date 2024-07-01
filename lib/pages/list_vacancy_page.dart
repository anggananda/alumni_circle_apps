import 'package:alumni_circle_app/components/error_widget.dart';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/dto/list_vacancy.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListVacancyPage extends StatefulWidget {
  const ListVacancyPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListVacancyPageState createState() => _ListVacancyPageState();
}

class _ListVacancyPageState extends State<ListVacancyPage> {
  Future<List<ListVacancy>>? _listVacancy;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final accessToken = context.read<AuthCubit>().state.accessToken;
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;
    setState(() {
      _listVacancy = DataService.fetchListVacancy(currentState.idAlumni, accessToken!);
    });
  }

  Future<void> _deleteListVacancy(int idListVacancy) async {
    final accessToken = context.read<AuthCubit>().state.accessToken;
    final response = await DataService.deleteListVacancy(idListVacancy, accessToken!);
    if (response.statusCode == 200) {
      showSuccessDialog(context, 'Successfully Deleted List Vacancy');
      _fetchData();
    } else {
      showErrorDialog(context, 'Failed to Delete List Vacancy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(244, 206, 20, 1),
        title: const Text('List Vacancy', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ListVacancy>>(
        future: _listVacancy,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    // ignore: unnecessary_null_comparison
                    leading: item.gambar != null
                        ? Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${Endpoints.urlUas}/static/storages/${item.gambar}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.namaVacancy,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () {
                        showConfirmDeleteDialog(
                            context: context,
                            onConfirm: () {
                              _deleteListVacancy(item.idListVacancy);
                            });
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorDisplay(
                message: 'Failed to display list',
                onRetry: () {
                  _fetchData(); // Retry fetching events
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
