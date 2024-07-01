import 'dart:io';
import 'package:alumni_circle_app/cubit/alumni/cubit/alumni_cubit.dart';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/dto/alumni.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/services/sync_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:alumni_circle_app/utils/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UpdateProfilePage extends StatefulWidget {
  final Alumni alumni;
  const UpdateProfilePage({Key? key, required this.alumni}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _addressController = TextEditingController();
  late TextEditingController _jobStatusController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();
  String _gender = '';
  // late String _graduateDate;
  int _selectedBatch = 18;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.alumni.namaALumni ?? '');
    _usernameController = TextEditingController(text: widget.alumni.username);
    _emailController = TextEditingController(text: widget.alumni.email ?? '');
    _addressController =
        TextEditingController(text: widget.alumni.alamat ?? '');
    _jobStatusController =
        TextEditingController(text: widget.alumni.statusPekerjaan ?? '');
    _gender = widget.alumni.jenisKelamin ?? '';
    _dateController = TextEditingController(
        text: formatDateString(widget.alumni.tanggalLulus!));
    _selectedBatch = widget.alumni.angkatan != null
        ? int.parse(widget.alumni.angkatan!)
        : 18;
  }

  File? _image;
  // final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _jobStatusController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    String name = _nameController.text;
    String username = _usernameController.text;
    String gender = _gender;
    String address = _addressController.text;
    String email = _emailController.text;
    String graduateDate = _dateController.text;  
    String batch = _selectedBatch.toString();
    String jobStatus = _jobStatusController.text;

    if (name.isEmpty ||
        username.isEmpty ||
        gender.isEmpty ||
        address.isEmpty ||
        graduateDate.isEmpty ||
        email.isEmpty ||
        batch.isEmpty ||
        jobStatus.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("fill all of the data!")));
      return;
    }

    debugPrint(graduateDate);


    final accessToken = context.read<AuthCubit>().state.accessToken;
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;

    final send = context.read<AlumniCubit>(); // Gunakan DiskusiCubit
    send.updateAlumni(currentState.idAlumni, name, username, gender, address, email,
        graduateDate, batch, jobStatus, _image, accessToken!);
    _updateSqlite(currentState.idAlumni, accessToken);
    Navigator.pop(context);
    if (send.state.errorMessage == '') {
      showSuccessDialog(context, 'Successfully Update Profile');
    } else {
      showErrorDialog(context, 'Failed to update profile');
    }
  }

  void _updateSqlite(int idAlumni, String accessToken) async {
    final syncService = SyncService();
    await syncService.syncAlumni(idAlumni, accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Update Profile', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // _showPicker(context);
                            ImagePickerUtil.showPicker(
                              context: context,
                              onImagePicked: (File? pickedFile) {
                                setState(() {
                                  _image = pickedFile;
                                });
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _image != null
                                ? Image.file(_image!).image
                                : NetworkImage(
                                    '${Endpoints.urlUas}/static/storages/${widget.alumni.fotoProfile}'),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              ImagePickerUtil.showPicker(
                                context: context,
                                onImagePicked: (File? pickedFile) {
                                  setState(() {
                                    _image = pickedFile;
                                  });
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: addButtonColor,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ToggleButtons(
                    isSelected: [
                      _gender == 'laki-laki',
                      _gender == 'perempuan'
                    ],
                    onPressed: (int newIndex) {
                      setState(() {
                        _gender = newIndex == 0 ? 'laki-laki' : 'perempuan';
                      });
                    },
                    borderRadius: BorderRadius.circular(30.0),
                    borderWidth: 2.0,
                    borderColor: Colors.grey[400],
                    selectedBorderColor: Colors.green,
                    fillColor: Colors.transparent,
                    selectedColor: Colors.green[800],
                    color: Colors.grey[600],
                    constraints: const BoxConstraints(minHeight: 50.0),
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          'Male',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          'Female',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Graduate Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: "Date",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          // Memunculkan date picker saat input ditekan
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 8),
                  // Add your DatePicker widget here
                  const SizedBox(height: 16),
                  Text(
                    'Batch',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    value: _selectedBatch,
                    items: List.generate(7, (index) => 18 + index)
                        .map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedBatch = newValue ?? 18;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Job Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _jobStatusController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _updateProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: addButtonColor,
                      ),
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
}
