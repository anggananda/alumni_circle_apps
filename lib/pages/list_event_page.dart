import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/dto/list_event.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


class ListEventPage extends StatefulWidget {
  const ListEventPage({Key? key}) : super(key: key);

  @override
  _ListEventPageState createState() => _ListEventPageState();
}

class _ListEventPageState extends State<ListEventPage> {
  Future<List<ListEvents>>? _listEvent;

  void _deleteListEvent(int idListEvent){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin menghapus postingan ini?"),
        actions: [
          TextButton(
            onPressed: () {
              DataService.deleteListEvent(idListEvent);
              Navigator.pop(context);
              setState(() {
                final cubit = context.read<ProfileCubit>();
                final currentState = cubit.state;
                _listEvent = DataService.fetchListEvent(currentState.idAlumni);
              });
            },
            child: const Text('Ya'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tidak'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;
    _listEvent = DataService.fetchListEvent(currentState.idAlumni);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEAEA),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 206, 20,1),
        title: const Text('List Event'),
      ),
      body: FutureBuilder<List<ListEvents>>(
        future: _listEvent,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  child: ListTile(
                    // ignore: unnecessary_null_comparison
                    title: item.gambar != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                fit: BoxFit.fitWidth,
                                width: 300,
                                height: 300,
                                Uri.parse(
                                        '${Endpoints.urlUas}/static/storages/${item.gambar!}')
                                    .toString(),
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons
                                        .error), // Display error icon if image fails to load
                              ),
                            ],
                          )
                        : null,
                    subtitle: Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Nama Event : ${item.namaEvent}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Tanggal : ${item.tanggalEvent}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Lokasi : ${item.lokasi}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Deskripsi : ${item.deskripsi}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _deleteListEvent(item.idListEvent);
                            },
                            child: const Text(
                              'Remove',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    ]),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}