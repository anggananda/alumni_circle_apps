import 'package:flutter/material.dart';
import 'package:my_app/utils/constants.dart';
import 'package:my_app/utils/event.dart';

class ListVacancyPage extends StatelessWidget {
  const ListVacancyPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<EventCount> events = getEventCounts(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Vacancy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: secondaryColor,
        child: ListView.separated(
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            EventCount event = events[index];
            return ListTile(
              title: Text(event.title),
              subtitle: Text(event.preview),
              leading: Image.network(
                event.img,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              onTap: event.onPressed,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.grey,
              thickness: 1,
              height: 0,
            );
          },
        ),
      ),
    );
  }
}