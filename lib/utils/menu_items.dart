import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final VoidCallback onPressed;
  final String img; // Tambahkan properti img

  MenuItem({required this.title, required this.onPressed, required this.img});
}

List<MenuItem> getMenuItems(BuildContext context) {
  return [
    MenuItem(
      title: 'Discussion',
      img: 'assets/images/discussion.png',
      onPressed: () => Navigator.pushNamed(context, '/discussion'),
    ),
    MenuItem(
      title: 'Event',
      img: 'assets/images/event.png',
      onPressed: () => Navigator.pushNamed(context, '/event'),
    ),
    MenuItem(
      title: 'Job Vacancy',
      img: 'assets/images/jobvacancy.png',
      onPressed: () => Navigator.pushNamed(context, '/jobvacancy'),
    ),
    MenuItem(
      title: 'List Event',
      img: 'assets/images/listevent.png',
      onPressed: () => Navigator.pushNamed(context, '/listevent'),
    ),
    MenuItem(
      title: 'List Vacancy',
      img: 'assets/images/listvacancy.png',
      onPressed: () => Navigator.pushNamed(context, '/listvacancy'),
    ),
  ];
}
