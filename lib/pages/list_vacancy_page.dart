import 'package:alumni_circle_app/components/error_widget.dart';
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
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;
    setState(() {
      _listVacancy = DataService.fetchListVacancy(currentState.idAlumni);
    });
  }

  Future<void> _deleteListVacancy(int idListVacancy) async {
    final response = await DataService.deleteListVacancy(idListVacancy);
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
      backgroundColor: Color(0xFFEAEAEA),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 206, 20, 1),
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
                    contentPadding: EdgeInsets.all(16),
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
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${Endpoints.urlUas}/static/storages/${item.gambar!}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.namaVacancy,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Deskripsi : ${item.deskripsi}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
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
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
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
