import 'package:flutter/material.dart';
import 'package:my_app/pages/vacancy_slider.dart';
import 'package:my_app/utils/constants.dart';


class JobVacancyPage extends StatefulWidget {
  const JobVacancyPage({super.key});

  @override
  State<JobVacancyPage> createState() => _JobVacancyPageState();
}

class _JobVacancyPageState extends State<JobVacancyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Vacancy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
        color: secondaryColor,
        child: Column(
          children: [
            Container(
                height: 140,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  color: primaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 30.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Vacancy...',
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(color: primaryFontColor),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "See All the Vacancies",
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              VacancySlider()
          ],
        ),
      ),
      ) 
    );
  }
}