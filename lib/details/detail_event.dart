import 'package:alumni_circle_app/cubit/event/cubit/event_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/dto/event.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/google_map_page.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailEvent extends StatefulWidget {
  final Events event;
  final VoidCallback? onDataSubmitted;
  final int? page;
  const DetailEvent(
      {Key? key, required this.event, this.onDataSubmitted, this.page})
      : super(key: key);

  @override
  State<DetailEvent> createState() => _DetailEventState();
}

class _DetailEventState extends State<DetailEvent> {
  void _sendListEvent() async {
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;

    final idAlumni = currentState.idAlumni;
    final idEvent = widget.event.idEvent;

    debugPrint('$idAlumni, $idEvent');

    final response = await DataService.sendListEvent(idAlumni, idEvent);

    if (response.statusCode == 201) {
      showSuccessDialog(context, 'Success to add Event to List Event');
    } else {
      showInfoDialog(context, widget.event.namaEvent,
          'The event has been added to the event list');
    }
  }

  void _deleteEvent(idEvent) async {
    final deleteCubit = context.read<EventCubit>();
    deleteCubit.deleteEvent(idEvent, widget.page!);
    Navigator.pop(context);
    if (deleteCubit.state.errorMessage == '') {
      showSuccessDialog(context, 'Successfully Delete Vacancy');
    } else {
      showErrorDialog(context, 'Failed to vacancy');
    }
  }

  void _navigateToMap(Events event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoogleMapPage(
          event: event,
        ),
      ),
    );
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
                        '${Endpoints.urlUas}/static/storages/${widget.event.gambar}'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 70,
                      padding: EdgeInsets.symmetric(
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
                              padding: EdgeInsets.all(5),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "🌟 ${widget.event.namaEvent}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryFontColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Details",
                            style: TextStyle(color: primaryFontColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _navigateToMap(widget.event);
                              },
                              icon: Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                              label: Text(
                                'Open Map',
                                style: TextStyle(
                                    color: primaryFontColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.green),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _sendListEvent();
                              },
                              icon: Icon(
                                Icons.bookmark_add,
                                color: primaryColor,
                              ),
                              label: Text(
                                'Save Event',
                                style: TextStyle(
                                    color: primaryFontColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: primaryColor),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(
                height: 15.0,
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: 370,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: primaryFontColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Date : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: formatDateString(widget.event.tanggalEvent),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: 370,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: primaryFontColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Location : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: widget.event.lokasi,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: 370,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: primaryFontColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Category : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: widget.event.category,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.event.deskripsi,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: primaryFontColor),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: 370,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: primaryFontColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'CP :',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ' 082236903868 (dwi angga)',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                if (state.roles == 'admin') {
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                label: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    // fontSize: 15,
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
                                  showConfirmDeleteDialog(
                                      context: context,
                                      onConfirm: () {
                                        _deleteEvent(widget.event.idEvent);
                                      });
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
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
