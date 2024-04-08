import 'package:flutter/material.dart';
import 'package:my_app/utils/constants.dart';

class ListVacancyPage extends StatelessWidget {
  const ListVacancyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Vacancy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
        backgroundColor: primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: secondaryColor,
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: const Text('Go back!'),
      //   ),
      // ),
    );
  }
}