import 'package:alumni_circle_app/cubit/alumni/cubit/alumni_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/dto/alumni.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/update_profile_page.dart';
import 'package:alumni_circle_app/services/data_service.dart';
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
  void _navigateToUpdate(Alumni alumni) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfilePage(alumni: alumni),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: BlocBuilder<AlumniCubit, AlumniState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.errorMessage.isNotEmpty) {
            return Center(child: Text(state.errorMessage));
          } else if (state.alumni.isEmpty) {
            return Center(child: Text('No Profile data available'));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.alumni.length,
              itemBuilder: (context, index) {
                final alumni = state.alumni[index];
                return SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFEAEAEA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
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
                                  _navigateToUpdate(alumni);
                                },
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(244, 206, 20, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.edit,
                                      size: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          alumni.username,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'League Spartan',
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildInfoTile('Name', alumni.namaALumni ?? 'Anonimus',
                            CupertinoIcons.person),
                        SizedBox(height: 10),
                        _buildInfoTile('Email', alumni.email ?? 'N/A',
                            Icons.email_outlined),
                        SizedBox(height: 10),
                        _buildInfoTile(
                            'Address', alumni.alamat ?? 'N/A', Icons.place),
                        SizedBox(height: 10),
                        _buildInfoTile(
                            'Gender',
                            alumni.jenisKelamin ?? 'N/A',
                            alumni.jenisKelamin == 'laki-laki'
                                ? Icons.male
                                : Icons.female),
                        SizedBox(height: 10),
                        _buildInfoTile(
                            'Graduate Date',
                            formatDateString(alumni.tanggalLulus!) ?? 'N/A',
                            Icons.date_range_outlined),
                        SizedBox(height: 10),
                        _buildInfoTile(
                            'Batch', alumni.angkatan.toString(), Icons.school),
                        SizedBox(height: 10),
                        _buildInfoTile('Job Status',
                            alumni.statusPekerjaan ?? 'N/A', Icons.work),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String subtitle, IconData icon) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 5),
          color: Color.fromRGBO(244, 206, 20, 1),
        )
      ], borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        tileColor: Colors.black,
        textColor: Colors.black,
      ),
    );
  }
}
