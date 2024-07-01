import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/cubit/vacancy/cubit/vacancy_cubit.dart';
import 'package:alumni_circle_app/dto/vacancy.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailVacancy extends StatefulWidget {
  final Vacancies vacancy;
  final VoidCallback? onDataSubmitted;
  final int? page;
  const DetailVacancy(
      {Key? key, required this.vacancy, this.onDataSubmitted, this.page})
      : super(key: key);

  @override
  State<DetailVacancy> createState() => _DetailVacancyState();
}

class _DetailVacancyState extends State<DetailVacancy> {
  void _sendListVacancy() async {
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;

    final idAlumni = currentState.idAlumni;
    final idVacancy = widget.vacancy.idVacancy;

    debugPrint('$idAlumni, $idVacancy');
    final accessToken = context.read<AuthCubit>().state.accessToken;

    final response = await DataService.sendListVacancy(idAlumni, idVacancy, accessToken!);
    if (response.statusCode == 201) {
      showSuccessDialog(context, 'Success to add Event to List Event');
    } else {
      showInfoDialog(context, widget.vacancy.namaVacancy,'The event has been added to the event list');
    }
  }

  void _deleteVacancy(idVacancy) async {
    final accessToken = context.read<AuthCubit>().state.accessToken;
    final deleteCubit = context.read<VacancyCubit>();
    deleteCubit.deleteVacancy(idVacancy, widget.page!, accessToken!);
    Navigator.pop(context);
    if (deleteCubit.state.errorMessage == '') {
      showSuccessDialog(context, 'Successfully Delete Vacancy');
    } else {
      showErrorDialog(context, 'Failed to vacancy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                        '${Endpoints.urlUas}/static/storages/${widget.vacancy.gambar}'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 70,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: secondaryColor,
                              ),
                              child: const Icon(Icons.arrow_back),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "🌟 ${widget.vacancy.namaVacancy}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: primaryFontColor),
                              overflow: TextOverflow
                                  .ellipsis, // Potong teks jika terlalu panjang
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Text(
                            "Details",
                            style: TextStyle(color: primaryFontColor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _sendListVacancy();
                        },
                        icon: const Icon(
                          Icons.bookmark_add,
                          color: primaryColor,
                        ),
                        label: const Text(
                          'Save Vacancy',
                          style: TextStyle(color: primaryFontColor, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primaryColor),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.vacancy.deskripsi,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(color: primaryFontColor),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                if (state.roles == 'admin') {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            label: const Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.redAccent, backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5,
                              shadowColor: Colors.redAccent,
                            ),
                            onPressed: () {
                              showConfirmDeleteDialog(context: context, onConfirm: (){
                                _deleteVacancy(widget.vacancy.idVacancy);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
