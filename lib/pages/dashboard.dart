import 'package:alumni_circle_app/components/bio_text.dart';
import 'package:alumni_circle_app/components/time_now_screen.dart';
import 'package:alumni_circle_app/cubit/alumni/cubit/alumni_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_circle_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/utils/menu_items.dart';
import 'package:alumni_circle_app/main.dart'; // Import main.dart untuk mengakses routeObserver

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Dipanggil ketika kembali ke halaman ini
    _fetchData();
  }

  void _fetchData() {
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;
    BlocProvider.of<AlumniCubit>(context).fetchAlumni(currentState.idAlumni);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned(
                right: 0.0,
                left: 0.0,
                top: -10.0,
                child: Opacity(
                  opacity: 0.2,
                  child: Center(
                    child: AssetImageWidget(
                      imagePath: 'assets/images/intropage.png',
                      width: 500,
                      height: 259,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<AlumniCubit, AlumniState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state.errorMessage.isNotEmpty) {
                            return Container();
                          } else if (state.alumni.isEmpty) {
                            return Container();
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.alumni.length,
                              itemBuilder: (context, index) {
                                final alumni = state.alumni[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                              '${Endpoints.urlUas}/static/storages/${alumni.fotoProfile}' ??
                                                  '',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          TimeNow(
                                            alumni: alumni,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 174.0,
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: secondaryColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 24.0,
                        ),
                        child: Column(
                          children: [
                            BlocBuilder<AlumniCubit, AlumniState>(
                              builder: (context, state) {
                                if (state.isLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state.errorMessage.isNotEmpty) {
                                  return Center(
                                      child: Text(state.errorMessage));
                                } else if (state.alumni.isEmpty) {
                                  return Center(
                                      child: Text('No alumni data available'));
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.alumni.length,
                                    itemBuilder: (context, index) {
                                      final alumni = state.alumni[index];
                                      return Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: thirdColor,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                          horizontal: 15.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              child: Text(
                                                "Bio",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                  color: primaryFontColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const Divider(),
                                            SizedBox(height: 10.0),
                                            BioText(
                                                label: "Name",
                                                value:
                                                    alumni.namaALumni ?? 'N/A'),
                                            const Divider(),
                                            BioText(
                                                label: "Email",
                                                value: alumni.email ?? 'N/A'),
                                            const Divider(),
                                            BioText(
                                                label: "Address",
                                                value: alumni.alamat ?? 'N/A'),
                                            const Divider(),
                                            BioText(
                                              label: "Graduate Date",
                                              value: alumni.tanggalLulus != null
                                                  ? formatDateString(
                                                      alumni.tanggalLulus!)
                                                  : 'N/A',
                                            ),
                                            const Divider(),
                                            BioText(
                                                label: "Batch",
                                                value: '${alumni.angkatan}' ??
                                                    '0'),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 250,
                              padding: const EdgeInsets.all(10.0),
                              child: GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 20.0,
                                mainAxisSpacing: 15.0,
                                padding: const EdgeInsets.all(10.0),
                                children: getMenuItems(context).map((item) {
                                  return GestureDetector(
                                    onTap: item.onPressed,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(
                                                0.5), // Warna bayangan
                                            spreadRadius:
                                                2, // Jarak bayangan dari objek
                                            blurRadius:
                                                5, // Besarnya "blur" pada bayangan
                                            offset: Offset(0,
                                                3), // Posisi bayangan relatif terhadap objek
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AssetImageWidget(
                                            imagePath: item.img,
                                            width: 64,
                                            height: 64,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Berikan jarak antara gambar dan teks
                                          Text(
                                            item.title,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
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
        );
  }
}
