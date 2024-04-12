import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/jobvacancy.dart';

class VacancySlider extends StatelessWidget {
  const VacancySlider({super.key});

  @override
  Widget build(BuildContext context) {
    List<JobVacancies> vacancies = getJobVacancies(context);
    return Container(
        height: 410,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: ListView.separated(
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              JobVacancies vacancy = vacancies[index];

              return GestureDetector(
                onTap: vacancy.onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: thirdColor, // Ubah warna sesuai kebutuhan
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Warna bayangan
                          spreadRadius: 2, // Radius penyebaran bayangan
                          blurRadius: 5, // Radius blur bayangan
                          offset: Offset(0,
                              3), // Offset (pergeseran) bayangan dalam x dan y
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(vacancy.img),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vacancy.title,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 5),
                                Flexible(
                                  child: Text(
                                    vacancy.preview,
                                    overflow: TextOverflow.fade,
                                    // maxLines: 2,
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              // Separator antara event
              return const SizedBox(
                height: 15.0,
              );
            },
            itemCount: vacancies.length));
  }
}
