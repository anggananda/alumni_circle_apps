import 'package:alumni_circle_app/components/bio_text.dart';
import 'package:alumni_circle_app/components/time_now_screen.dart';
import 'package:alumni_circle_app/cubit/alumni/cubit/alumni_cubit.dart';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/dto/alumni.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/services/db_helper_alumni.dart';
import 'package:alumni_circle_app/services/sync_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_circle_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/utils/menu_items.dart';
import 'package:alumni_circle_app/main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with RouteAware {
  late Future<List<Alumni>> alumniOffline;
  late ProfileCubit _profileCubit;
  late AuthCubit _authCubit;
  late AlumniCubit _alumniCubit;
  late SyncService _syncService;

  @override
  void initState() {
    super.initState();
    _initializeCubits();
    _initializeSyncService();
    _initializeAlumniOffline();
    _checkConnectionAndFetchData();
    _loginIfNotLoggedIn();
  }

  void _initializeCubits() {
    _profileCubit = context.read<ProfileCubit>();
    _authCubit = context.read<AuthCubit>();
    _alumniCubit = context.read<AlumniCubit>();
  }

  void _initializeSyncService() {
    _syncService = SyncService();
  }

  void _initializeAlumniOffline() {
    alumniOffline = DatabaseHelper().getAllAlumni();
  }

  void _checkConnectionAndFetchData() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      debugPrint('Connectivity result: $connectivityResult');

      // ignore: unrelated_type_equality_checks
      if (connectivityResult == ConnectivityResult.none) {
        debugPrint('offline');
        showOfflineDialog(context);
      } else {
        debugPrint('online');
        _fetchDataFromServer();
      }
    } on PlatformException catch (e) {
      debugPrint("Error checking connectivity: $e");
      debugPrint('offline');
      showOfflineDialog(context);
    }
  }

  void _loginIfNotLoggedIn() {
    if (_profileCubit.state.idAlumni == 0) {
      _isLogging();
    }
  }

  void _fetchDataFromServer() async {
    final currentState = _profileCubit.state;
    final accessToken = _authCubit.state.accessToken;
    if (accessToken != null) {
      _alumniCubit.fetchAlumni(currentState.idAlumni, accessToken);
    } else {
      debugPrint("Access token is null");
    }
  }

  void _isLogging() async {
    debugPrint("User is logged in");
    final id = _profileCubit.state.idAlumni;
    final roles = _profileCubit.state.roles;
    _profileCubit.setProfile(roles, id);
    final accessToken = _authCubit.state.accessToken;
    if (accessToken != null) {
      _updateSQLite(id, accessToken);
    } else {
      debugPrint("Access token is null");
    }
  }

  void _updateSQLite(int idAlumni, String accessToken) async {
    try {
      await _syncService.syncAlumni(idAlumni, accessToken);
    } catch (e) {
      debugPrint('Error updating SQLite: $e');
    }
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
    _fetchDataFromServer();
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AlumniCubit, AlumniState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.errorMessage.isNotEmpty) {
                      return FutureBuilder<List<Alumni>>(
                        future: alumniOffline,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Container();
                          } else {
                            final alumniList = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: alumniList.length,
                              itemBuilder: (context, index) {
                                final alumni = alumniList[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                '${Endpoints.urlUas}/static/storages/${alumni.fotoProfile}'),
                                          ),
                                          const SizedBox(width: 10),
                                          TimeNow(alumni: alumni)
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        '${Endpoints.urlUas}/static/storages/${alumni.fotoProfile}',
                                      ),
                                    ),
                                    const SizedBox(
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
                            return FutureBuilder<List<Alumni>>(
                              future: alumniOffline,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Container();
                                } else {
                                  final alumniList = snapshot.data!;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: alumniList.length,
                                    itemBuilder: (context, index) {
                                      final alumni = alumniList[index];
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
                                            const SizedBox(
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
                                            const SizedBox(height: 10.0),
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
                                                value: '${alumni.angkatan}'),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          } else if (state.alumni.isEmpty) {
                            return Container();
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.alumni.length,
                              itemBuilder: (context, index) {
                                final alumni = state.alumni[index];
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
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
                                      const SizedBox(
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
                                      const SizedBox(height: 10.0),
                                      BioText(
                                          label: "Name",
                                          value: alumni.namaALumni ?? 'N/A'),
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
                                          value: '${alumni.angkatan}'),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 250,
                        child: FutureBuilder<List<MenuItem>>(
                          future: getMenuItems(context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Container();
                            } else {
                              return GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 20.0,
                                mainAxisSpacing: 15.0,
                                padding: const EdgeInsets.all(10.0),
                                children: snapshot.data!.map((item) {
                                  return GestureDetector(
                                    onTap: item.onPressed,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AssetImageWidget(
                                            imagePath: item.img,
                                            width: 58,
                                            height: 58,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
