import 'package:alumni_circle_app/cubit/alumni/cubit/alumni_cubit.dart';
import 'package:alumni_circle_app/dto/alumni.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/update_profile_page.dart';
import 'package:alumni_circle_app/services/db_helper_alumni.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Alumni>> alumniOffline;

  @override
  void initState() {
    super.initState();
    fetchAlumniData();
  }

  Future<void> fetchAlumniData() async {
    setState(() {
      alumniOffline = DatabaseHelper().getAllAlumni();
    });
  }

  void _navigateToUpdate(Alumni alumni) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfilePage(alumni: alumni),
      ),
    );
  }

  void _showOptions(BuildContext context, Alumni alumni) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[200]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose an Option',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text(
                  'Update Profile',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToUpdate(alumni);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.red),
                title: const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/change_password');
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: colors2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: BlocBuilder<AlumniCubit, AlumniState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.errorMessage.isNotEmpty) {
            return FutureBuilder<List<Alumni>>(
              future: alumniOffline,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data found.'));
                } else {
                  final alumniList = snapshot.data!;
                  return _buildAlumniList(alumniList);
                }
              },
            );
          } else if (state.alumni.isEmpty) {
            return const Center(child: Text('No Profile data available'));
          } else {
            return _buildAlumniList(state.alumni);
          }
        },
      ),
    );
  }

  Widget _buildAlumniList(List<Alumni> alumniList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: alumniList.length,
      itemBuilder: (context, index) {
        final alumni = alumniList[index];
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFEAEAEA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          '${Endpoints.urlUas}/static/storages/${alumni.fotoProfile}'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _showOptions(context, alumni);
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(244, 206, 20, 1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit,
                              size: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  alumni.username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'League Spartan',
                  ),
                ),
                const SizedBox(height: 10),
                _buildInfoTile('Name', alumni.namaALumni ?? 'Anonimus',
                    CupertinoIcons.person),
                const SizedBox(height: 10),
                _buildInfoTile(
                    'Email', alumni.email ?? 'N/A', Icons.email_outlined),
                const SizedBox(height: 10),
                _buildInfoTile('Address', alumni.alamat ?? 'N/A', Icons.place),
                const SizedBox(height: 10),
                _buildInfoTile(
                  'Gender',
                  alumni.jenisKelamin ?? 'N/A',
                  alumni.jenisKelamin == 'laki-laki'
                      ? Icons.male
                      : Icons.female,
                ),
                const SizedBox(height: 10),
                _buildInfoTile(
                  'Graduate Date',
                  formatDateString(alumni.tanggalLulus!),
                  Icons.date_range_outlined,
                ),
                const SizedBox(height: 10),
                _buildInfoTile(
                    'Batch', alumni.angkatan.toString(), Icons.school),
                const SizedBox(height: 10),
                _buildInfoTile(
                    'Job Status', alumni.statusPekerjaan ?? 'N/A', Icons.work),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(String title, String subtitle, IconData icon) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Color.fromRGBO(244, 206, 20, 1),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        leading: Icon(icon, color: Colors.black),
        tileColor: Colors.black,
        textColor: Colors.black,
      ),
    );
  }
}
